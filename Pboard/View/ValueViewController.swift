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

public class ValueViewController: UITableViewController {
    public var uti: String? = nil
    public var value: Any = ""
    
    private enum SectionType {
        case uti
        case value
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
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
            return 1    // TODO:
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
            cell = tableView.dequeueReusableCell(withIdentifier: "StringCell", for: indexPath)
            (cell as! StringCell).stringValue = uti
        
        case .value:
            switch value {
            case let image as UIImage:
                cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                (cell as! ImageCell).imageValue = image
                
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "StringCell", for: indexPath)
                let stringCell = cell as! StringCell
                if let descriptable = value as? CustomStringConvertible {
                    stringCell.stringValue = descriptable.description
                } else {
                    stringCell.stringValue = ""
                }
            }
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
