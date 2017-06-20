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
		view.isExclusiveTouch = true

		return view
	}()

	private lazy var saveColorButton: UIButton = {
		let button = UIButton(type: UIButtonType.system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Save as Wallpaper", for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		button.tintColor = .white
		button.backgroundColor = .lightGray
		button.layer.cornerRadius = 15.0
		button.addTarget(self, action: #selector(saveColorAsImage), for: .touchUpInside)
		button.isExclusiveTouch = true

		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		addSubviews()
		setUpConstraints()
		setUpNavBar()
	}

	private func addSubviews() {
		view.addSubview(colorPickerView)
		view.addSubview(saveColorButton)
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			colorPickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
			colorPickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
			colorPickerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
			colorPickerView.bottomAnchor.constraint(equalTo: saveColorButton.topAnchor, constant: -10),

			saveColorButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
			saveColorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
			saveColorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
			saveColorButton.heightAnchor.constraint(equalToConstant: 50)
			])
	}

	private func setUpNavBar() {
		title = "Color Wallpaper Creator"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recent", style: .done, target: self, action: #selector(openRecentColors))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func openRecentColors() {
		let navController = UINavigationController(rootViewController: RecentColorsCollectionViewController())
		navController.modalPresentationStyle = .overCurrentContext
		present(navController, animated: true, completion: nil)
	}

	func saveColorAsImage() {
		UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0.0)

		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(colorPickerView.currentColor.cgColor)
		context?.fill(UIScreen.main.bounds)

		guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }

		UIGraphicsEndImageContext()

		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}

	private func saveRecentColor() {
		let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL

		let recentColor = RecentColor(color: colorPickerView.currentColor)

		guard let path = url.appendingPathComponent("recentColors")?.path else { return }

		if var recentColors = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [RecentColor] {
			recentColors.append(recentColor)

			NSKeyedArchiver.archiveRootObject(recentColors, toFile: path)
		} else {
			NSKeyedArchiver.archiveRootObject([recentColor], toFile: path)
		}
	}

	func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		var alertController = UIAlertController()

		if let error = error {
			alertController = UIAlertController(title: "Error :(", message: error.localizedDescription, preferredStyle: .alert)
		} else {
			alertController = UIAlertController(title: "Saved!", message: "Check your Photo Library to set this color as your wallpaper.", preferredStyle: .alert)
			saveRecentColor()
		}

		alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

		present(alertController, animated: true, completion: nil)
	}
}
