//
//  DayOfTheWeekModel.swift
//  project
//
//  Created by Лерочка on 23.07.22.
//

import UIKit

struct DayOfTheWeekModel{
    let dayName: String
    var isSelect: Bool
    
    init(dayName: String){
        self.dayName = dayName
        self.isSelect = false
    }
}
