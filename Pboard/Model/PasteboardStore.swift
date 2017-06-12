//
// PasteboardStore.swift
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

import UIKit
import Eventitic

public struct ItemRepresentation {
    public var uti: String
    public var data: Any
}

public class PasteboardStore {
    public static let shared = PasteboardStore()
    
    public private(set) var items: [[ItemRepresentation]] = []
    public let onUpdate = EventSource<Void>()
    private var lastChangeCount = 0
    
    private init() {
        loadFromRealPasteboard()
    }
    
    public func reload() {
        if UIPasteboard.general.changeCount != lastChangeCount {
            loadFromRealPasteboard()
            onUpdate.fire(())
        }
    }
    
    private func loadFromRealPasteboard() {
        let pb = UIPasteboard.general
        lastChangeCount = pb.changeCount
        items = pb.items.map({ item in
            return item.map({ (key, value) in
                return ItemRepresentation(uti: key, data: loadValue(value))
            })
        })
    }
    
    private func loadValue(_ value: Any) -> Any {
        guard let data = value as? Data else { return value }
        
        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) {
            return plist
        } else {
            return data
        }
    }
}
