//  PickerInputRow.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
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

import Foundation

// MARK: PickerInputCell

open class PickerInputCell<T>: Cell<T>, CellType, UIPickerViewDataSource, UIPickerViewDelegate where T: Equatable, T: InputTypeInitiable {
	public lazy var picker: UIPickerView = {
		let picker = UIPickerView()
		picker.translatesAutoresizingMaskIntoConstraints = false
		return picker
	}()

	private var pickerInputRow: _PickerInputRow<T>? { return row as? _PickerInputRow<T> }

	public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override func setup() {
		super.setup()
		accessoryType = .none
		editingAccessoryType = .none
		picker.delegate = self
		picker.dataSource = self
	}

	deinit {
		picker.delegate = nil
		picker.dataSource = nil
	}

	open override func update() {
		super.update()
		selectionStyle = row.isDisabled ? .none : .default

		if row.title?.isEmpty == false {
			detailTextLabel?.text = row.displayValueFor?(row.value) ?? (row as? NoValueDisplayTextConformance)?.noValueDisplayText
		} else {
			textLabel?.text = row.displayValueFor?(row.value) ?? (row as? NoValueDisplayTextConformance)?.noValueDisplayText
			detailTextLabel?.text = nil
		}

		textLabel?.textColor = row.isDisabled ? .gray : .black
		if row.isHighlighted {
			textLabel?.textColor = tintColor
		}

		picker.reloadAllComponents()
		if let selectedValue = pickerInputRow?.value, let index = pickerInputRow?.options.index(of: selectedValue) {
			picker.selectRow(index, inComponent: 0, animated: true)
		}
	}

	open override func didSelect() {
		super.didSelect()
		row.deselect()
	}

	open override var inputView: UIView? {
		return picker
	}

	open override func cellCanBecomeFirstResponder() -> Bool {
		return canBecomeFirstResponder
	}

	open override var canBecomeFirstResponder: Bool {
		return !row.isDisabled
	}

	open func numberOfComponents(in _: UIPickerView) -> Int {
		return 1
	}

	open func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
		return pickerInputRow?.options.count ?? 0
	}

	open func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
		return pickerInputRow?.displayValueFor?(pickerInputRow?.options[row])
	}

	open func pickerView(_: UIPickerView, didSelectRow rowNumber: Int, inComponent _: Int) {
		if let picker = pickerInputRow, picker.options.count > rowNumber {
			picker.value = picker.options[rowNumber]
			update()
		}
	}
}

// MARK: PickerInputRow

open class _PickerInputRow<T>: Row<PickerInputCell<T>>, NoValueDisplayTextConformance where T: Equatable, T: InputTypeInitiable {
	open var noValueDisplayText: String?

	open var options = [T]()

	public required init(tag: String?) {
		super.init(tag: tag)
	}
}

/// A generic row where the user can pick an option from a picker view displayed in the keyboard area
public final class PickerInputRow<T>: _PickerInputRow<T>, RowType where T: Equatable, T: InputTypeInitiable {
	public required init(tag: String?) {
		super.init(tag: tag)
	}
}
