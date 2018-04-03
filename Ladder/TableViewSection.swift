//
//  TableViewSection.swift
//  Ladder
//
//  Created by Aofei Sheng on 2018/3/23.
//  Copyright © 2018 Beijing Corestate Technology Co., Ltd. All rights reserved.
//

import UIKit

class TableViewSection: NSObject, NSCoding {
	var headerHeight: CGFloat?
	var headerTitle: String?
	var headerTitleColor: UIColor?
	var headerBackgroundColor: UIColor?
	var cells = [TableViewCell]()

	override init() {}

	required init?(coder aDecoder: NSCoder) {
		headerHeight = aDecoder.decodeObject(forKey: "headerHeight") as? CGFloat
		headerTitle = aDecoder.decodeObject(forKey: "headerTitle") as? String
		headerTitleColor = aDecoder.decodeObject(forKey: "headerTitleColor") as? UIColor
		headerBackgroundColor = aDecoder.decodeObject(forKey: "headerBackgroundColor") as? UIColor
		cells = aDecoder.decodeObject(forKey: "cells") as! [TableViewCell]
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(headerHeight, forKey: "headerHeight")
		aCoder.encode(headerTitle, forKey: "headerTitle")
		aCoder.encode(headerTitleColor, forKey: "headerTitleColor")
		aCoder.encode(headerBackgroundColor, forKey: "headerBackgroundColor")
		aCoder.encode(cells, forKey: "cells")
	}
}
