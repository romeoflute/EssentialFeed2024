//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit

extension UIControl {
	func simulate(event: UIControl.Event) {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: event)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}
