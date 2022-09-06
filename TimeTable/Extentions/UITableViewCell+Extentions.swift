//
//  UITableViewCell+Extentions.swift
//  project
//
//  Created by Лерочка on 02.08.22.
//

import UIKit

extension UITableViewCell{
    func setupMainAppearance(){
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.mainColor.cgColor
//        self.backgroundColor = UIColor(named: "backgroundColor")
    }
}
