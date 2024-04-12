//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Romeo Flauta on 4/12/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
