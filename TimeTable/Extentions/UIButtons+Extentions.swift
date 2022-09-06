//
//  UIButtons+Extentions.swift
//  project
//
//  Created by Лерочка on 23.07.22.
//

import UIKit

extension UIButton{
    func mainButton(){
        backgroundColor = UIColor.mainColor
        titleLabel?.textColor = .white
        layer.cornerRadius = 10
    }
}
