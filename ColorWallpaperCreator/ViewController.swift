//
//  ViewController.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/16/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	private lazy var colorPickerView: ColorPickerView = {
		let view = ColorPickerView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	private lazy var saveColorButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Save as Wallpaper", for: .normal)
		button.backgroundColor = .lightGray
		button.layer.cornerRadius = 15.0
		button.addTarget(self, action: #selector(saveColorAsImage), for: .touchUpInside)

		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = .white

		addSubviews()
		setUpConstraints()
	}

	func addSubviews() {
		view.addSubview(colorPickerView)
		view.addSubview(saveColorButton)
	}

	func setUpConstraints() {
		NSLayoutConstraint.activate([
			colorPickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
			colorPickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
			colorPickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
			colorPickerView.bottomAnchor.constraint(equalTo: saveColorButton.topAnchor, constant: -10),

			saveColorButton.leftAnchor.constraint(equalTo: colorPickerView.leftAnchor),
			saveColorButton.rightAnchor.constraint(equalTo: colorPickerView.rightAnchor),
			saveColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
			saveColorButton.heightAnchor.constraint(equalToConstant: 50)
			])
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func saveColorAsImage() {
		UIGraphicsBeginImageContext(UIScreen.main.bounds.size)

		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(colorPickerView.currentColor.cgColor)
		context?.fill(UIScreen.main.bounds)

		guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }

		UIGraphicsEndImageContext()

		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}

	func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			let ac = UIAlertController(title: "Error :(", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Check your Photo Library to set this color as your wallpaper.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
			present(ac, animated: true)
		}
	}
}
