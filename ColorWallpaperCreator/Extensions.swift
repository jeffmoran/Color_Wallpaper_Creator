//
//  Extensions.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/16/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

extension CALayer {
	func colorFromPoint(at point: CGPoint) -> UIColor {
		var pixel: [CUnsignedChar] = [0, 0, 0, 0]

		let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

		if let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
			context.translateBy(x: -point.x, y: -point.y)
			render(in: context)
		}

		let red = CGFloat(pixel[0]) / 255.0
		let green = CGFloat(pixel[1]) / 255.0
		let blue = CGFloat(pixel[2]) / 255.0

		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}
}

extension UIColor {
	var hexString: String {
		guard let colorRef: [CGFloat] = cgColor.components else { return "" }

		let red: CGFloat = colorRef[0]
		let green: CGFloat = colorRef[1]
		let blue: CGFloat = colorRef[2]

		return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
	}

    private var intensity: CGFloat {
		var red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0

		getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		return (red * 0.299 + green * 0.587 + blue * 0.114)
	}

    var hexTextColor: UIColor {
		return intensity > 0.50 ? .black : .white
	}

	func saveColorAsImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0.0)

		let context: CGContext? = UIGraphicsGetCurrentContext()
		context?.setFillColor(cgColor)
		context?.fill(UIScreen.main.bounds)

		guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }

		UIGraphicsEndImageContext()

		return image
	}
}
