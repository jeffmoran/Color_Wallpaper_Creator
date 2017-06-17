//
//  ColorPickerView.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/16/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
	private lazy var colorImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = #imageLiteral(resourceName: "allColors")
		imageView.clipsToBounds = true

		return imageView
	}()

	private lazy var colorSliderNub: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1.0
		view.layer.cornerRadius = 25 / 2

		return view
	}()

	private lazy var currentColorView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 15.0

		return view
	}()

	private lazy var currentColorHexCodeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	var currentColor: UIColor {
		return currentColorView.backgroundColor ?? .white
	}

	init() {
		super.init(frame: .zero)

		addSubviews()
		setUpConstraints()
		setUpGestures()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func addSubviews() {
		addSubview(colorImageView)
		colorImageView.addSubview(colorSliderNub)
		addSubview(currentColorView)
		addSubview(currentColorHexCodeLabel)
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			colorImageView.leftAnchor.constraint(equalTo: leftAnchor),
			colorImageView.topAnchor.constraint(equalTo: topAnchor),
			colorImageView.rightAnchor.constraint(equalTo: rightAnchor),

			colorSliderNub.heightAnchor.constraint(equalToConstant: 25),
			colorSliderNub.widthAnchor.constraint(equalTo: colorSliderNub.heightAnchor),

			currentColorView.leftAnchor.constraint(equalTo: colorImageView.leftAnchor),
			currentColorView.topAnchor.constraint(equalTo: colorImageView.bottomAnchor, constant: 10),
			currentColorView.heightAnchor.constraint(equalToConstant: 80),
			currentColorView.widthAnchor.constraint(equalTo: currentColorView.heightAnchor),

			currentColorHexCodeLabel.leftAnchor.constraint(equalTo: currentColorView.rightAnchor, constant: 10),
			currentColorHexCodeLabel.topAnchor.constraint(equalTo: currentColorView.topAnchor),

			currentColorView.bottomAnchor.constraint(equalTo: bottomAnchor)
			])
	}

	private func setUpGestures() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
		addGestureRecognizer(panGesture)
	}

	func panGestureHandler(sender: UIPanGestureRecognizer) {
		let point = sender.location(in: self)

		switch sender.state {
		case .changed:
			let color = colorImageView.layer.colorFromPoint(at: point)

			if color.cgColor.alpha <= 0 { return }

			currentColorView.backgroundColor = color
			currentColorHexCodeLabel.text = color.hexString
		case .ended:
			colorSliderNub.center = point
		default: break
		}
	}
}
