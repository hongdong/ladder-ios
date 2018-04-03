//
//  TableViewCell.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import SnapKit

class TableViewCell: UITableViewCell {
	enum Style: Int {
		case `default`
		case value1
		case value2
		case subtitle
		case textField
		case button
	}

	var rowHeight: CGFloat?

	private(set) lazy var textField: UITextField? = {
		var textField = UITextField()
		textField.clearButtonMode = .whileEditing
		textField.returnKeyType = .done
		self.contentView.addSubview(textField)
		textField.snp.makeConstraints { make in
			make.right.equalToSuperview().offset(-15)
			make.width.equalToSuperview().offset(-180)
			make.height.equalToSuperview()
		}
		return textField
	}()

	var isDisabled: Bool? {
		willSet {
			if let newValue = newValue {
				if newValue {
					textLabel?.textColor = textLabel?.textColor.withAlphaComponent(0.5)
					selectionStyle = .none
				} else {
					textLabel?.textColor = textLabel?.textColor.withAlphaComponent(1)
					selectionStyle = .default
				}
			}
		}
	}

	var didSelect: (() -> Void)? {
		willSet {
			if isDisabled == nil {
				selectionStyle = newValue == nil ? .none : .default
			}
		}
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		selectionStyle = .none
	}

	convenience init() {
		self.init(style: .default, reuseIdentifier: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		rowHeight = aDecoder.decodeObject(forKey: "rowHeight") as? CGFloat
		textField = aDecoder.decodeObject(forKey: "textField") as? UITextField
		isDisabled = aDecoder.decodeObject(forKey: "isDisabled") as? Bool
	}

	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)

		aCoder.encode(rowHeight, forKey: "rowHeight")
		aCoder.encode(textField, forKey: "textField")
		aCoder.encode(isDisabled, forKey: "isDisabled")
	}

	convenience init(style: Style) {
		switch style {
		case .default, .value1, .value2, .subtitle:
			self.init(style: UITableViewCellStyle(rawValue: style.rawValue)!, reuseIdentifier: nil)
		case .textField:
			self.init()
			addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldBecomeFirstResponder)))
			selectionStyle = .none
		case .button:
			self.init()
			rowHeight = 50
			textLabel?.textAlignment = .center
			separatorInset.left = 0
		}
	}

	@objc func textFieldBecomeFirstResponder() {
		textField?.becomeFirstResponder()
	}
}
