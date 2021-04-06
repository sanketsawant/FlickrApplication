//
//  UIViewController+Extension.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 05/04/2021.
//

import UIKit

extension UIViewController {
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) in }
            alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
