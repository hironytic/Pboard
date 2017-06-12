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
        
        public static let alert_OK = ResourceString(key: "Pboard.alert_OK")
        
        public static let noItemsFound = ResourceString(key: "Pboard.noItemsFound")
        
        public static let valueType_string = ResourceString(key: "Pboard.valueType_string")
        public static let valueType_number = ResourceString(key: "Pboard.valueType_number")
        public static let valueType_boolean = ResourceString(key: "Pboard.valueType_boolean")
        public static let valueType_image = ResourceString(key: "Pboard.valueType_image")
        public static let valueType_color = ResourceString(key: "Pboard.valueType_color")
        public static let valueType_URL = ResourceString(key: "Pboard.valueType_URL")
        public static let valueType_data = ResourceString(key: "Pboard.valueType_data")
        public static let valueType_date = ResourceString(key: "Pboard.valueType_date")
        public static let valueType_dictionary = ResourceString(key: "Pboard.valueType_dictionary")
        public static let valueType_array = ResourceString(key: "Pboard.valueType_array")
        public static let valueType_unknown = ResourceString(key: "Pboard.valueType_unknown")
        
        public static let itemHeaderFormat = ResourceStringFormat(key: "Pboard.itemHeaderFormat")
        
        public static let headerUti = ResourceString(key: "Pboard.headerUti")
        public static let headerValueFormat = ResourceStringFormat(key: "Pboard.headerValueFormat")
        
        public static let openThisURL = ResourceString(key: "Pboard.openThisURL")
        
        public static let dataBytesFormat = ResourceStringFormat(key: "Pboard.dataBytesFormat")
        public static let sendToITunes = ResourceString(key: "Pboard.sendToITunes")
        public static let dataFileNameFormat = ResourceStringFormat(key: "Pboard.dataFileNameFormat")
        public static let failedToSendToITunes = ResourceString(key: "Pboard.failedToSendToITunes")
        public static let sentToITunes = ResourceString(key: "Pboard.sentToITunes")
        public static let arrayIndexFormat = ResourceStringFormat(key: "Pboard.arrayIndexFormat")
        public static let booleanTrue = ResourceString(key: "Pboard.booleanTrue")
        public static let booleanFalse = ResourceString(key: "Pboard.booleanFalse")
    }
}
