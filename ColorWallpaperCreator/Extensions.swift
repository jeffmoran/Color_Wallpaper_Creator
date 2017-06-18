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
		let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

		if let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) {
			context.translateBy(x: -point.x, y: -point.y)
			render(in: context)
		}

		let red: CGFloat = CGFloat(pixel[0]) / 255.0
		let green: CGFloat = CGFloat(pixel[1]) / 255.0
		let blue: CGFloat = CGFloat(pixel[2]) / 255.0
		let alpha: CGFloat = CGFloat(pixel[3]) / 255.0

		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}

extension UIColor {
	var hexString: String {
		guard let colorRef = cgColor.components else { return "" }

		let r: CGFloat = colorRef[0]
		let g: CGFloat = colorRef[1]
		let b: CGFloat = colorRef[2]

		return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
	}

	private func intensity() -> CGFloat {
		var red: CGFloat = 255.0, green: CGFloat = 255.0, blue: CGFloat = 255.0, alpha: CGFloat = 1.0

		getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		return (red * 0.299 + green * 0.587 + blue * 0.114)
	}

	func hexTextColor() -> UIColor {
		return intensity() > 0.50 ? .black : .white
	}
}
