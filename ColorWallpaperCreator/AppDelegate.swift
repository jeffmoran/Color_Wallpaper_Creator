//
//  AppDelegate.swift
//  ColorWallpaperCreator
//
//  Created by Jeff Moran on 6/16/17.
//  Copyright © 2017 Jeff Moran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UINavigationController(rootViewController: ViewController())
		window?.makeKeyAndVisible()

		return true
	}
}
