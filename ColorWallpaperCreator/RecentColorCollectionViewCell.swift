//
//  RecentColorCollectionViewCell.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/19/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

class RecentColorCollectionViewCell: UICollectionViewCell {
	var recentColor: UIColor? {
		didSet {
			backgroundColor = recentColor ?? .white
			hexColorCodeLabel.text = recentColor?.hexString
			hexColorCodeLabel.textColor = recentColor?.hexTextColor
		}
	}

	private lazy var hexColorCodeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 18)

		return label
	}()

	convenience init() {
		self.init(frame: .zero)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubviews()
		setUpConstraints()
	}

    @available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func addSubviews() {
		addSubview(hexColorCodeLabel)
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			hexColorCodeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
			hexColorCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
			])
	}
}
