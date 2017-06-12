//
// ValueViewController.swift
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

private protocol ValueRowDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func prepare(for segue: UIStoryboardSegue, senderRowAt indexPath: IndexPath)
}

extension ValueRowDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do nothing
    }
    func prepare(for segue: UIStoryboardSegue, senderRowAt indexPath: IndexPath) {
        // Do nothing
    }
}

public class ValueViewController: UITableViewController {
    public var uti: String? = nil
    public var value: Any = "" {
        didSet {
            switch value {
            case let stringValue as String:
                valueRowDataSource = StringValueRowDataSource(value: stringValue)
            case let imageValue as UIImage:
                valueRowDataSource = ImageValueRowDataSource(value: imageValue)
            case let urlValue as URL:
                valueRowDataSource = URLValueRowDataSource(value: urlValue)
            case let dataValue as Data:
                valueRowDataSource = DataValueRowDataSource(viewController: self, value: dataValue)
            case let arrayValue as Array<Any>:
                valueRowDataSource = ArrayValueRowDataSource(value: arrayValue)
            case let dictValue as Dictionary<AnyHashable, Any>:
                valueRowDataSource = DictionaryValueRowDataSource(value: dictValue)
            default:
                valueRowDataSource = UnknownValueRowDataSource(value: value)
            }
        }
    }
    
    private var valueRowDataSource: ValueRowDataSource = StringValueRowDataSource(value: "")
    private var listenerStore: ListenerStore? = nil
    
    private enum SectionType {
        case uti
        case value
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        clearsSelectionOnViewWillAppear = true
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pbs = PasteboardStore.shared
        let listenerStore = ListenerStore()
        self.listenerStore = listenerStore
        pbs.onUpdate.listen { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        .addToStore(listenerStore)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        listenerStore = nil
        
        super.viewDidDisappear(animated)
    }
    
    private var sectionTypes: [SectionType] {
        if uti == nil {
            return [.value]
        } else {
            return [.uti, .value]
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTypes.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sectionTypes[section] {
        case .uti:
            return 1
        case .value:
            return valueRowDataSource.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sectionTypes[section] {
        case .uti:
            return ResourceUtils.getString(R.String.headerUti)
        case .value:
            return ResourceUtils.getString(format: R.String.headerValueFormat, dataTypeString(of: value))
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sectionTypes[indexPath.section] {
        case .uti:
            cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
            (cell as! StringCell).stringValue = uti
        
        case .value:
            cell = valueRowDataSource.tableView(tableView, cellForRowAt: indexPath)
        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionTypes[indexPath.section] {
        case .value:
            valueRowDataSource.tableView(tableView, didSelectRowAt: indexPath)
        default:
            break
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        switch sectionTypes[indexPath.section] {
        case .value:
            valueRowDataSource.prepare(for: segue, senderRowAt: indexPath)
        default:
            break
        }
    }
}

private class StringValueRowDataSource: ValueRowDataSource {
    private let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
        (cell as! StringCell).stringValue = value
        return cell
    }
}

private class ImageValueRowDataSource: ValueRowDataSource {
    private let value: UIImage
    
    public init(value: UIImage) {
        self.value = value
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.imageCell, for: indexPath)
        (cell as! ImageCell).imageValue = value
        return cell
    }
}

private class URLValueRowDataSource: ValueRowDataSource {
    private let value: URL
    
    public init(value: URL) {
        self.value = value
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
            (cell as! StringCell).stringValue = value.absoluteString
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.actionCell, for: indexPath)
            (cell as! ActionCell).title = ResourceUtils.getString(R.String.openThisURL)
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
            (cell as! StringCell).stringValue = ""
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            UIApplication.shared.openURL(value)
            
        default:
            break
        }
    }
}

private class DataValueRowDataSource: ValueRowDataSource {
    private let value: Data
    private weak var viewController: ValueViewController?
    
    public init(viewController: ValueViewController, value: Data) {
        self.viewController = viewController
        self.value = value
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
            (cell as! StringCell).stringValue = makeValueString()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.actionCell, for: indexPath)
            (cell as! ActionCell).title = ResourceUtils.getString(R.String.sendToITunes)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
            (cell as! StringCell).stringValue = ""
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let postfix = dateFormatter.string(from: Date())
            let fileName = ResourceUtils.getString(format: R.String.dataFileNameFormat, postfix)
            let fileURL = documentsURL.appendingPathComponent(fileName)
            do {
                try value.write(to: fileURL, options: .atomic)
            } catch let error {
                let ac = UIAlertController(title: ResourceUtils.getString(R.String.failedToSendToITunes),
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: ResourceUtils.getString(R.String.alert_OK),
                                           style: .default,
                                           handler: nil))
                viewController?.present(ac, animated: true, completion: nil)
                return
            }
            
            let ac = UIAlertController(title: ResourceUtils.getString(R.String.sentToITunes),
                                       message: fileName,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: ResourceUtils.getString(R.String.alert_OK),
                                       style: .default,
                                       handler: nil))
            viewController?.present(ac, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    private func makeValueString() -> String {
        let DISPLAY_SIZE = 64
        
        let data = (value.count <= DISPLAY_SIZE) ? value : value.subdata(in: Range<Data.Index>(0 ..< DISPLAY_SIZE))
        var str = ""
        for byte in data {
            str += String(format: "%02X ", byte)
        }
        if value.count > DISPLAY_SIZE {
            str += "…"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = NSLocale.current.groupingSeparator
        let sizeStr = formatter.string(for: value.count) ?? ""
        
        str += "\n\n" + ResourceUtils.getString(format: R.String.dataBytesFormat, sizeStr)
        return str
    }
}

private class ArrayValueRowDataSource: ValueRowDataSource {
    private let value: Array<Any>
    
    public init(value: Array<Any>) {
        self.value = value
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.keyValueCell, for: indexPath) as! KeyValueCell
        cell.key = ResourceUtils.getString(format: R.String.arrayIndexFormat, indexPath.row)
        cell.value = dataTypeString(of: value[indexPath.row])
        return cell
    }
    
    public func prepare(for segue: UIStoryboardSegue, senderRowAt indexPath: IndexPath) {
        guard let valueViewCotnroller = segue.destination as? ValueViewController else { return }
        valueViewCotnroller.title = ResourceUtils.getString(format: R.String.arrayIndexFormat, indexPath.row)
        valueViewCotnroller.value = value[indexPath.row]
    }
}

private class DictionaryValueRowDataSource: ValueRowDataSource {
    private let value: Array<(AnyHashable, Any)>
    
    public init(value: Dictionary<AnyHashable, Any>) {
        self.value = value.map { ($0, $1) }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.keyValueCell, for: indexPath) as! KeyValueCell
        
        let pair = value[indexPath.row]
        cell.key = pair.0.description
        cell.value = dataTypeString(of: pair.1)
        return cell
    }
    
    public func prepare(for segue: UIStoryboardSegue, senderRowAt indexPath: IndexPath) {
        guard let valueViewCotnroller = segue.destination as? ValueViewController else { return }
        let pair = value[indexPath.row]
        valueViewCotnroller.title = pair.0.description
        valueViewCotnroller.value = pair.1
    }
}

private class UnknownValueRowDataSource: ValueRowDataSource {
    private let value: Any
    
    public init(value: Any) {
        self.value = value
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Id.stringCell, for: indexPath)
        let stringCell = cell as! StringCell
        if let descriptable = value as? CustomStringConvertible {
            let LIMIT = 128
            var description = descriptable.description
            if description.characters.count > LIMIT {
                let index = description.index(description.startIndex, offsetBy: LIMIT)
                description = description.substring(to: index) + "…"
            }
            stringCell.stringValue = description
        } else {
            stringCell.stringValue = ""
        }
        return cell
    }
}

public class StringCell: UITableViewCell {
    @IBOutlet private weak var stringLabel: UILabel!
    
    public var stringValue: String? {
        get {
            return stringLabel.text
        }
        set {
            stringLabel.text = newValue
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(StringCell.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    public func preferredContentSizeChanged(_ notification: Notification) {
        stringLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
}

public class ImageCell: UITableViewCell {
    @IBOutlet private weak var mainImageView: UIImageView!
    
    private var aspectRatioConstraint: NSLayoutConstraint?
    
    public var imageValue: UIImage {
        get {
            return mainImageView.image ?? UIImage()
        }
        set {
            mainImageView.image = newValue

            if let prevConstraint = aspectRatioConstraint {
                prevConstraint.isActive = false
            }
            let constraint = NSLayoutConstraint(
                item: mainImageView,
                attribute:NSLayoutAttribute.height,
                relatedBy:NSLayoutRelation.equal,
                toItem: mainImageView,
                attribute: NSLayoutAttribute.width,
                multiplier: newValue.size.height / newValue.size.width,
                constant:0)
            constraint.priority = UILayoutPriorityRequired - 1  // to avoids constraints error caused with 'UIView-Encapsulated-Layout-Height'
            constraint.isActive = true
            aspectRatioConstraint = constraint
        }
    }
}

public class ActionCell: UITableViewCell {
    @IBOutlet private weak var actionLabel: UILabel!

    public var title: String? {
        get {
            return self.actionLabel.text
        }
        set {
            self.actionLabel.text = newValue
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.actionLabel.textColor = self.tintColor
        NotificationCenter.default.addObserver(self, selector: #selector(ActionCell.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    public func preferredContentSizeChanged(_ notification: Notification) {
        actionLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
}

public class KeyValueCell: UITableViewCell {
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    public var key: String? {
        get {
            return keyLabel.text
        }
        set {
            keyLabel.text = newValue
        }
    }
    
    public var value: String? {
        get {
            return valueLabel.text
        }
        set {
            valueLabel.text = newValue
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(KeyValueCell.preferredContentSizeChanged(_:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    public func preferredContentSizeChanged(_ notification: Notification) {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        keyLabel.font = bodyFont
        valueLabel.font = bodyFont
    }
}
