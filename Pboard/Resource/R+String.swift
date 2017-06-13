//
// R+String.swift
// Pboard
//
// Copyright (c) 2017 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public struct ResourceString {
    public var key: String

    public func localized() -> String {
        return NSLocalizedString(key, comment: "")
    }
}

public struct ResourceStringFormat {
    public var key: String

    public func localized(_ arguments: CVarArg...) -> String {
        return localized(arguments: arguments)
    }
    
    public func localized(arguments: [CVarArg]) -> String {
        let formatString = NSLocalizedString(key, comment: "")
        return Swift.String(format: formatString, arguments: arguments)
    }
}

public extension R {
    public struct String {
        private init() { }
        
        public static let alertOK = ResourceString(key: "Pboard.alertOK")
        
        public static let noItemsFound = ResourceString(key: "Pboard.noItemsFound")
        
        public static let valueTypeString = ResourceString(key: "Pboard.valueTypeString")
        public static let valueTypeNumber = ResourceString(key: "Pboard.valueTypeNumber")
        public static let valueTypeBoolean = ResourceString(key: "Pboard.valueTypeBoolean")
        public static let valueTypeImage = ResourceString(key: "Pboard.valueTypeImage")
        public static let valueTypeColor = ResourceString(key: "Pboard.valueTypeColor")
        public static let valueTypeURL = ResourceString(key: "Pboard.valueTypeURL")
        public static let valueTypeData = ResourceString(key: "Pboard.valueTypeData")
        public static let valueTypeDate = ResourceString(key: "Pboard.valueTypeDate")
        public static let valueTypeDictionary = ResourceString(key: "Pboard.valueTypeDictionary")
        public static let valueTypeArray = ResourceString(key: "Pboard.valueTypeArray")
        public static let valueTypeUnknown = ResourceString(key: "Pboard.valueTypeUnknown")
        
        public static let itemHeader = ResourceStringFormat(key: "Pboard.itemHeader.format")
        
        public static let headerUti = ResourceString(key: "Pboard.headerUti")
        public static let headerValue = ResourceStringFormat(key: "Pboard.headerValue.format")
        
        public static let openThisURL = ResourceString(key: "Pboard.openThisURL")
        
        public static let dataBytes = ResourceStringFormat(key: "Pboard.dataBytes.format")
        public static let sendToITunes = ResourceString(key: "Pboard.sendToITunes")
        public static let dataFileName = ResourceStringFormat(key: "Pboard.dataFileName.format")
        public static let failedToSendToITunes = ResourceString(key: "Pboard.failedToSendToITunes")
        public static let sentToITunes = ResourceString(key: "Pboard.sentToITunes")
        public static let arrayIndex = ResourceStringFormat(key: "Pboard.arrayIndex.format")
        public static let booleanTrue = ResourceString(key: "Pboard.booleanTrue")
        public static let booleanFalse = ResourceString(key: "Pboard.booleanFalse")
    }
}
