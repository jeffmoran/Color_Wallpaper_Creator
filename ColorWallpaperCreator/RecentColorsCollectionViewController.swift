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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

		super.init(collectionViewLayout: layout)

        layout.itemSize = CGSize(width: view.frame.width, height: 70)
	}

    @available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    var recentColors: [RecentColor]? {
        didSet {
            collectionView.reloadData()
        }
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

        updateRecentColors()
	}

	@objc func close() {
		dismiss(animated: true, completion: nil)
	}

    func updateRecentColors() {
        recentColors = RecentColor.recentColors
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let color = recentColors?[indexPath.item] else { return }

        let alertController = UIAlertController(title: "Delete recent color?", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            RecentColor.remove(color)
            self.updateRecentColors()
        })

        present(alertController, animated: true, completion: nil)
    }
}
