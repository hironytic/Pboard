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
        noItemsLabel.text = R.String.noItemsFound.localized()
        noItemsLabel.textColor = UIColor.lightGray
        noItemsLabel.sizeToFit()
        noItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        noItemsLabelParent.addSubview(noItemsLabel)
        let horizontalConstraint = NSLayoutConstraint(item: noItemsLabel, attribute: .centerX, relatedBy: .equal, toItem: noItemsLabelParent, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verticalConstraint = NSLayoutConstraint(item: noItemsLabel, attribute: .centerY, relatedBy: .equal, toItem: noItemsLabelParent, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        noItemsLabelParent.addConstraints([horizontalConstraint, verticalConstraint])
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        clearsSelectionOnViewWillAppear = true
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        handleUpdateItems()
        
        let pbs = PasteboardStore.shared
        let listenerStore = ListenerStore()
        self.listenerStore = listenerStore
        pbs.onUpdate.listen { [weak self] in
            self?.handleUpdateItems()
        }
        .addToStore(listenerStore)
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
        return R.String.itemHeader.localized(section)
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
        valueViewCotnroller.title = R.String.itemHeader.localized(indexPath.section)
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

public extension NSNumber {
    var isBoolean: Bool {
        return objCType[0] == 99 /* 'c' */
    }
}

public func dataTypeString(of data: Any) -> String {
    switch data {
    case is String:
        return R.String.valueTypeString.localized()
    case let numData as NSNumber where numData.isBoolean:
        return R.String.valueTypeBoolean.localized()
    case is NSNumber:
        return R.String.valueTypeNumber.localized()
    case is UIImage:
        return R.String.valueTypeImage.localized()
    case is UIColor:
        return R.String.valueTypeColor.localized()
    case is URL:
        return R.String.valueTypeURL.localized()
    case is Data:
        return R.String.valueTypeData.localized()
    case is Date:
        return R.String.valueTypeDate.localized()
    case is Dictionary<AnyHashable, Any>:
        return R.String.valueTypeDictionary.localized()
    case is Array<Any>:
        return R.String.valueTypeArray.localized()
    default:
        return R.String.valueTypeUnknown.localized()
    }
}
