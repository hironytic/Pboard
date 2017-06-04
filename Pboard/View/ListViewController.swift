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
    private var noItemsLabel: UILabel!
    
    private var items: [[ItemRepresentation]] = []
    private var listenerStore: ListenerStore? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let noItemsLabelParent = UIView()
        tableView.backgroundView = noItemsLabelParent
        noItemsLabel = UILabel()
        noItemsLabel.text = ResourceUtils.getString(R.String.noItemsFound)
        noItemsLabel.textColor = UIColor.lightGray
        noItemsLabel.sizeToFit()
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemsLabelParent.addSubview(noItemsLabel)
        let horizontalConstraint = NSLayoutConstraint(item: noItemsLabel, attribute: .centerX, relatedBy: .equal, toItem: noItemsLabelParent, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verticalConstraint = NSLayoutConstraint(item: noItemsLabel, attribute: .centerY, relatedBy: .equal, toItem: noItemsLabelParent, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        noItemsLabelParent.addConstraints([horizontalConstraint, verticalConstraint])
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.clearsSelectionOnViewWillAppear = false
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
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
        noItemsLabel.isHidden = !items.isEmpty
        tableView.reloadData()
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ResourceUtils.getString(format: R.String.itemHeaderFormat, section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let representation = items[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.cell, for: indexPath) as! RepresentationCell
        cell.typeIDLabel.text = representation.uti
        cell.dataTypeLabel.text = dataTypeString(of: representation.data)
        
        return cell
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let valueViewCotnroller = segue.destination as? ValueViewController else { return }
        guard let cell = sender as? UITableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let representation = items[indexPath.section][indexPath.row]
        valueViewCotnroller.uti = representation.uti
        valueViewCotnroller.value = representation.data
    }
}

public class RepresentationCell: UITableViewCell {
    @IBOutlet weak var typeIDLabel: UILabel!
    @IBOutlet weak var dataTypeLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(RepresentationCell.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    public func preferredContentSizeChanged(_ notification: Notification) {
        typeIDLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        dataTypeLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
}

public func dataTypeString(of data: Any) -> String {
    switch data {
    case is String:
        return ResourceUtils.getString(R.String.valueType_string)
    case is NSNumber:
        return ResourceUtils.getString(R.String.valueType_number)
    case is UIImage:
        return ResourceUtils.getString(R.String.valueType_image)
    case is UIColor:
        return ResourceUtils.getString(R.String.valueType_color)
    case is URL:
        return ResourceUtils.getString(R.String.valueType_URL)
    case is Data:
        return ResourceUtils.getString(R.String.valueType_data)
    case is Dictionary<AnyHashable, Any>:
        return ResourceUtils.getString(R.String.valueType_dictionary)
    case is Array<Any>:
        return ResourceUtils.getString(R.String.valueType_array)
    default:
        return ResourceUtils.getString(R.String.valueType_unknown)
    }
}
