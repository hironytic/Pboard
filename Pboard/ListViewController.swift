//
// ListViewController.swift
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

public class ListViewController: UITableViewController {
    private var items: [[ItemRepresentation]] = []
    private var listenerStore: ListenerStore? = nil
    
    public override func viewWillAppear(_ animated: Bool) {
        handleUpdateItems()

        let pbs = PasteboardStore.shared
        let listenerStore = ListenerStore()
        self.listenerStore = listenerStore
        pbs.onUpdate.listen {
            [weak self] in self?.handleUpdateItems()
        }
        .addToStore(listenerStore)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        self.listenerStore = nil
    }
    
    private func handleUpdateItems() {
        items = PasteboardStore.shared.items
        tableView.reloadData()
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Item \(section)"
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let representation = items[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = representation.uti
        let type: String
        switch representation.data {
        case is String:
            type = "String"
        case is NSNumber:
            type = "Number"
        case is UIImage:
            type = "Image"
        case is UIColor:
            type = "Color"
        case is URL:
            type = "URL"
        case is Data:
            type = "Data"
        default:
            type = "Unknown"
        }
        cell.detailTextLabel?.text = type
        
        return cell
    }
}

