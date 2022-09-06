//
//  HomeWorkModel.swift
//  project
//
//  Created by Лерочка on 12.08.22.
//

import UIKit

struct HomeWorkModel: Codable {
    var lessonName: String
    var homeWork: String
    var deadline: Date
    var isDone: Bool
    var isActive: Bool {
        let currentDate = Date()
        if deadline < currentDate {
            return false
        } else {
            return true
        }
    }
    
    init(deadline: Date, lessonName: String, homeWork: String){
        self.lessonName = lessonName
        self.homeWork = homeWork
        self.deadline = deadline
        self.isDone = false
//        self.isActive = true
    }
    
    var deadlineString: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd.MM.YYYY"
        return formatter.string(from: deadline)
    }
    
//    static func convertStringToDate(deadlineString: String) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE, dd.MM.YYYY"
//        let dateFormatter = formatter
//        return dateFormatter.date(from: deadlineString)!
//    }
    
    static func convertDateToString(deadline: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd.MM.YYYY"
        return formatter.string(from: deadline)
    }
}
