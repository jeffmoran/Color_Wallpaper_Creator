//
//  RecentColor.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/19/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import Foundation
import UIKit

class RecentColor: NSObject, NSCoding {
	var color: UIColor

	init(color: UIColor?) {
		self.color = color ?? .white
	}

	required convenience init?(coder aDecoder: NSCoder) {
		let color = aDecoder.decodeObject(forKey: "color") as? UIColor

		self.init(color: color)
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.color, forKey: "color")
	}
}
