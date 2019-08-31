//
//  UIColor+Palette.swift
//  RedditReader
//
//  Created by Javier Loucim on 25/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var unread: UIColor {
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    static var mainBackground: UIColor {
        return #colorLiteral(red: 0.1652766466, green: 0.1640888453, blue: 0.1661905348, alpha: 1)
    }
    static var mainText: UIColor {
        return white
    }
    static var selectedRow: UIColor {
        return #colorLiteral(red: 0.3628226519, green: 0.3963068128, blue: 0.4355934262, alpha: 1)
    }
    static var highLightedText: UIColor {
        return #colorLiteral(red: 1, green: 0.6764208078, blue: 0.3389216065, alpha: 1)
    }
}
