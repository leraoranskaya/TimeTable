//
//  UIColors+Extentions.swift
//  project
//
//  Created by Лерочка on 06.07.22.
//

import UIKit

extension UIColor{
    @nonobjc class var mainColor: UIColor {
        return UIColor(named: "mainColor") ?? UIColor(cgColor: CGColor(red: 0.38, green: 0.85, blue: 0.59, alpha: 1))
    }
    
    @nonobjc class var settingBackgroundColor: UIColor {
        return UIColor(named: "backgroundForViews") ?? UIColor(cgColor: CGColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))
    }
}
