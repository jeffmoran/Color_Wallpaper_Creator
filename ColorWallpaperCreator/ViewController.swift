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
        let button = UIButton(type: .system)
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
            colorPickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colorPickerView.bottomAnchor.constraint(equalTo: saveColorButton.topAnchor, constant: -10),

            saveColorButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            saveColorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            saveColorButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveColorButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setUpNavBar() {
        title = "Color Wallpaper Creator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recent", style: .done, target: self, action: #selector(openRecentColors))
    }

    @objc func openRecentColors() {
        let navController = UINavigationController(rootViewController: RecentColorsCollectionViewController())

        present(navController, animated: true, completion: nil)
    }

    @objc func saveColorAsImage() {
        guard let image = colorPickerView.currentColor.saveColorAsImage() else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var alertController = UIAlertController()

        let title: String
        let message: String

        if error != nil {
            title = "Error!"
            message = "Check your Photos permissions and try again."
        } else {
            title = "Saved!"
            message = "Check your Photo Library to set this color as your wallpaper."

            RecentColor.save(colorPickerView.currentColor)
        }

        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        present(alertController, animated: true, completion: nil)
    }
}
