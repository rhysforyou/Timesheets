//
//  UIViewController+Alert.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit

extension UIViewController {
    func modalAlert(title: String, message: String? = nil, dismiss: String = .ok, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismiss, style: .default) { _ in
            alert.dismiss(animated: true, completion: completion)
        })
        present(alert, animated: true)
    }
}

fileprivate extension String {
    static let ok = NSLocalizedString("OK", comment: "")
}
