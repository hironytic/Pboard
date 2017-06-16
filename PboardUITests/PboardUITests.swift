//
// PboardUITests.swift
// PboardUITests
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

import XCTest
import MobileCoreServices

class PboardUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: type(of: self))
        let item0: [String: Any] = [
            (kUTTypeUTF8PlainText as String): "Stella",
            (kUTTypeJPEG as String): UIImage(named: "LovelyDog.jpg", in: testBundle, compatibleWith: nil)!,
        ]
        let item1: [String: Any] = [
            "com.hironytic.Pboard.nativeData": Data(bytes: [
                0x43, 0x6F, 0x70, 0x79, 0x72, 0x69, 0x67, 0x68,
                0x74, 0x20, 0x28, 0x63, 0x29, 0x20, 0x32, 0x30,
                0x31, 0x37, 0x20, 0x48, 0x69, 0x72, 0x6F, 0x6E,
                0x6F, 0x72, 0x69, 0x20, 0x49, 0x63, 0x68, 0x69,
                0x6D, 0x69, 0x79, 0x61, 0x20, 0x3C, 0x68, 0x69,
                0x72, 0x6F, 0x6E, 0x40, 0x68, 0x69, 0x72, 0x6F,
                0x6E, 0x79, 0x74, 0x69, 0x63, 0x2E, 0x63, 0x6F,
                0x6D, 0x3E, 0x00, 0x00, 0x50, 0x65, 0x72, 0x6D,
                0x69, 0x73, 0x73, 0x69, 0x6F, 0x6E, 0x20, 0x69,
                0x73, 0x20, 0x68, 0x65, 0x72, 0x65, 0x62, 0x79,
                0x20, 0x67, 0x72, 0x61, 0x6E, 0x74, 0x65, 0x64,
                0x2C, 0x20, 0x66, 0x72, 0x65, 0x65, 0x20, 0x6F,
                0x66, 0x20, 0x63, 0x68, 0x61, 0x72, 0x67, 0x65,
            ])
        ]
        UIPasteboard.general.items = [
            item0,
            item1,
        ]
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshot() {
        snapshot("00")
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["public.utf8-plain-text"].tap()
        snapshot("10")
        
        let backButton = app.navigationBars["Item 0"].buttons["Pasteboard"]
        backButton.tap()
        
        tablesQuery.staticTexts["public.jpeg"].tap()
        snapshot("20")
        
        backButton.tap()
        
        tablesQuery.staticTexts["com.hironytic.Pboard.nativeData"].tap()
        snapshot("30")
    }
}
