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
    var identifier: UUID

    private init(color: UIColor?, identifier: UUID?) {
        self.color = color ?? .white
        self.identifier = identifier ?? UUID()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let color = aDecoder.decodeObject(forKey: "color") as? UIColor
        let identifier = aDecoder.decodeObject(forKey: "identifier") as? UUID

        self.init(color: color, identifier: identifier)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(color, forKey: "color")
        aCoder.encode(identifier, forKey: "identifier")
    }

    static func save(_ color: UIColor) {
        let recentColor = RecentColor(color: color, identifier: UUID())

        if var recentColors = recentColors {
            recentColors.append(recentColor)
            writeData(recentColors)
        } else {
            writeData([recentColor])
        }
    }

    static func remove(_ color: RecentColor) {
        if var recentColors = recentColors {
            recentColors.removeAll { $0.identifier == color.identifier }
            writeData(recentColors)
        }
    }

    private static func writeData(_ data: Any) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try data.write(to: recentColorsUrl)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private static var recentColorsUrl: URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newUrl = url.appendingPathComponent("recentColors")
        return newUrl
    }

    static var recentColors: [RecentColor]? {
        if let data = FileManager.default.contents(atPath: recentColorsUrl.path) {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [RecentColor]
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
