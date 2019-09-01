//
//  Alertable.swift
//  RedditReader
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable {
    
}

extension Alertable where Self: UIViewController {

    func showMessage(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true, completion: nil)
        
    }

    func showQuestion(title:String, message:String, okBlock: @escaping (UIAlertAction)->(), cancelAction:((UIAlertAction)->())? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okBlock))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction))
        
        present(alert, animated: true, completion: nil)
        
    }
}
