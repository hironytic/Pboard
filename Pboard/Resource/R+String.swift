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

public extension R {
    public struct String {
        private init() { }
        
        public static let valueType_string = "Pboard.valueType_string"
        public static let valueType_number = "Pboard.valueType_number"
        public static let valueType_image = "Pboard.valueType_image"
        public static let valueType_color = "Pboard.valueType_color"
        public static let valueType_URL = "Pboard.valueType_URL"
        public static let valueType_data = "Pboard.valueType_data"
        public static let valueType_unknown = "Pboard.valueType_unknown"
        
        public static let itemHeaderFormat = "Pboard.itemHeaderFormat"
        
        public static let headerUti = "Pboard.headerUti"
        public static let headerValueFormat = "Pboard.headerValueFormat"
    }
}
