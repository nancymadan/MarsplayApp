//
//  Extensions.swift
//  Tul
//
//  Created by dev on 27/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    
    class func loadFromNibNamedWithViewIndex(_ nibNamed: String, bundle : Bundle? = nil, index:Int) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[index] as? UIView
    }
    
}

