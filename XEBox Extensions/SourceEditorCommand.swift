//
//  SourceEditorCommand.swift
//  XEBox Extensions
//
//  Created by Lu Yibin on 19/10/2016.
//  Copyright © 2016 Lu Yibin. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        switch invocation.commandIdentifier {
        case "com.robinlu.XEBox.XEBox-Extensions.ImportForMe":
            importForMe(with: invocation)
        case "com.robinlu.XEBox.XEBox-Extensions.LocalizeString":
            localizingString(with: invocation)
        case "com.robinlu.XEBox.XEBox-Extensions.MoveUpIntoBraces":
            moveUpIntoBraces(with: invocation)
        case "com.robinlu.XEBox.XEBox-Extensions.UnwrapOptional":
            unwrapOptional(with: invocation)
        default:
            fatalError("\(invocation.commandIdentifier) not supported.")
        }
        
        completionHandler(nil)
    }
    
    func importForMe(with invocation: XCSourceEditorCommandInvocation) {
        let lastWordRegex = try! NSRegularExpression(pattern: "\\s*([\\w.]+)\\W*$", options: [])
        if let range = invocation.buffer.selections[0] as? XCSourceTextRange {
            var lastImportLine = 0
            let regex = try! NSRegularExpression(pattern: "^\\s*import\\s*\\w", options: [])
            for (i, line) in invocation.buffer.lines.enumerated() {
                if i == range.start.line {
                    continue
                }
                if let buffer = line as? String {
                    if let result = regex.firstMatch(in: buffer, options: [], range: buffer.fullRange) {
                        if result.range.location != NSNotFound {
                            lastImportLine = i
                        }
                    }
                }
            }
            
            if let currentLine = invocation.buffer.lines[range.start.line] as? String {
                if let result = lastWordRegex.firstMatch(in: currentLine, options: [], range: currentLine.fullRange) {
                    if result.numberOfRanges > 1 {
                        let wordRange = result.rangeAt(1)
                        let word = (currentLine as NSString).substring(with: wordRange)
                        if !word.isEmpty {
                            invocation.buffer.lines.insert("import \(word)", at: lastImportLine+1)
                            invocation.buffer.lines.removeObject(at: range.start.line)
                        }
                    }
                }
            }
        }
    }
    
    func localizingString(with invocation: XCSourceEditorCommandInvocation) {
        let quoteRegex = try! NSRegularExpression(pattern: "([\"'])(?:(?=(\\\\?))\\2.)*?\\1", options: [])
        if let range = invocation.buffer.selections[0] as? XCSourceTextRange {
            if let currentLine = invocation.buffer.lines[range.start.line] as? String {
                if let result = quoteRegex.matches(in: currentLine, options: [], range: currentLine.fullRange).last {
                    guard result.range.location != NSNotFound else {
                        return
                    }
                    let quote = (currentLine as NSString).substring(with: result.range)
                    let newQuote = "NSLocalizedString(\(quote), comment:\(quote))"
                    let newLine = (currentLine as NSString).replacingOccurrences(of: quote, with: newQuote, options: [], range: result.range)
                    invocation.buffer.lines.replaceObject(at: range.start.line, with: newLine)
                    let newStart = XCSourceTextPosition(line: range.start.line, column: result.range.location + newQuote.characters.count)
                    invocation.buffer.selections[0] = XCSourceTextRange(start: newStart, end: newStart)
                }
            }
        }
    }
    
    func moveUpIntoBraces(with invocation: XCSourceEditorCommandInvocation) {
        let endBraceRegex = try! NSRegularExpression(pattern: "\\s*\\}\\s*(//.*)?$", options: [])
        if let range = invocation.buffer.selections[0] as? XCSourceTextRange {
            let selectedRange = NSRange(location: range.start.line, length: range.end.line - range.start.line+1)
            let prefix = invocation.buffer.indentation()
            let selectedLines = invocation.buffer.lines.subarray(with: selectedRange).map({ (line) -> String in
                return "\(prefix)\(line)"
            })
            invocation.buffer.lines.removeObjects(in: selectedRange)
            for i in (0..<range.start.line).reversed() {
                if let lineContent = invocation.buffer.lines[i] as? String {
                    if let result = endBraceRegex.matches(in: lineContent, options: [], range: lineContent.fullRange).last {
                        guard result.range.location != NSNotFound else {
                            return
                        }
                        let braceLine = (lineContent as NSString).substring(with: result.range)
                        let remain = (lineContent as NSString).replacingOccurrences(of: braceLine, with: "", options: [], range: result.range)
                        var replaceRange = NSRange(location: i, length: 1)
                        invocation.buffer.lines.replaceObjects(in: replaceRange, withObjectsFrom: [remain,"", braceLine] )
                        replaceRange.location = replaceRange.location + 1
                        invocation.buffer.lines.replaceObjects(in: replaceRange, withObjectsFrom: selectedLines)
                        let newStart = XCSourceTextPosition(line: replaceRange.location, column: 0)
                        invocation.buffer.selections[0] = XCSourceTextRange(start: newStart, end: newStart)
                        break
                    }
                }
            }
        }
    }

    func unwrapOptional(with invocation: XCSourceEditorCommandInvocation) {
        if let range = invocation.buffer.selections[0] as? XCSourceTextRange {
            if let currentLine = invocation.buffer.lines[range.start.line] as? String {
                if let position = currentLine.positionOfFirstNonSpace() {
                    var newLine = currentLine
                    let idx = currentLine.index(of: position)
                    newLine.insert(contentsOf: "if ".characters, at: idx)
                    newLine.insert(contentsOf: " {".characters, at: newLine.index(before: newLine.endIndex))
                    let indent = currentLine.substring(to: idx)
                    let replaceRange = NSRange(location: range.start.line, length: 1)
                    invocation.buffer.lines.replaceObjects(in: replaceRange, withObjectsFrom: [newLine,"\n","\(indent)}"])
                    let start = XCSourceTextPosition(line: range.start.line, column: newLine.characters.count - 2)
                    let newSelection = XCSourceTextRange(start: start, end: start)
                    invocation.buffer.selections.replaceObject(at: 0, with: newSelection)
                }
            }
        }
    }
}

extension XCSourceTextBuffer {
    func indentation(n:Int = 1) -> String {
        if self.usesTabsForIndentation {
            return String(repeating: "\t", count: n)
        } else {
            return String(repeating: " ", count: self.indentationWidth * n)
        }
    }
}
extension String {
    var fullRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }
    
    func positionOfFirstNonSpace() -> Int? {
        let nonSpaceRegex = try! NSRegularExpression(pattern: "\\S", options: [])
        if let result = nonSpaceRegex.firstMatch(in: self, options: [], range: self.fullRange) {
            guard result.range.location != NSNotFound else {
                return nil
            }
            return result.range.location
        }
        return nil
    }
    
    func index(of position:Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: position)
    }
}
