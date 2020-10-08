//
//  RecentColorsCollectionViewController.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/19/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

class RecentColorsCollectionViewController: UICollectionViewController {
	private let reuseIdentifier: String = "recentlySavedColorCell"

	init() {
		let layout = UICollectionViewFlowLayout()

		let bounds = UIScreen.main.bounds

		layout.itemSize = CGSize(width: bounds.width, height: 70)

		super.init(collectionViewLayout: layout)
	}

    @available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var recentColors: [RecentColor]? {
		let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL

		guard let path = url.appendingPathComponent("recentColors")?.path else { return nil }

		if let recentColors = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [RecentColor] {
			return recentColors.reversed()
		}

		return nil
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Recently Saved Colors"

		collectionView?.register(RecentColorCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView?.alwaysBounceVertical = true
		collectionView?.backgroundColor = .clear

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))

		let blurEffect = UIBlurEffect(style: .prominent)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = view.bounds

		view.insertSubview(blurEffectView, at: 0)
	}

	@objc func close() {
		dismiss(animated: true, completion: nil)
	}

	// MARK: - UICollectionViewDataSource

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recentColors?.count ?? 0
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

		if let cell = cell as? RecentColorCollectionViewCell {
			cell.recentColor = recentColors?[indexPath.row].color
		}

		return cell
	}
}
