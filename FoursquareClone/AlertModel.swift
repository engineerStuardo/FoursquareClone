//
//  AlertModel.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 21/4/23.
//

import Foundation
import UIKit

class AlertModel {
    static let shared = AlertModel()
    
    private init() { }
    
    func alert(title: String, message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        view.present(alert, animated: true)
    }
}
