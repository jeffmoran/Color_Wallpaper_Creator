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

	class func saveRecentColor(_ color: UIColor) {
		let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

		let recentColor = RecentColor(color: color)

		let path = url.appendingPathComponent("recentColors").path

		if var recentColors = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [RecentColor] {
			recentColors.append(recentColor)

			NSKeyedArchiver.archiveRootObject(recentColors, toFile: path)
		} else {
			NSKeyedArchiver.archiveRootObject([recentColor], toFile: path)
		}
	}
}
