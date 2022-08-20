//
//  LessonCell.swift
//  Timetable
//
//  Created by Анна Гранёва on 16.02.22.
//

import UIKit

final class LessonCell: UITableViewCell {
    static let identifier = "kLessonCell"
    
    @IBOutlet private weak var lessonNameLabel: UILabel!
    @IBOutlet private weak var teacherLabel: UILabel!
    @IBOutlet private weak var audienceLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var lessonTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMainAppearance()
    }
    
    func setupWith(lesson: LessonModel){
        lessonNameLabel.text = lesson.lessonName
        teacherLabel.text = lesson.teacher
        audienceLabel.text = lesson.audience
        startTimeLabel.text = lesson.startTime
        endTimeLabel.text = lesson.endTime
        lessonTypeLabel.text = lesson.lessonType
    }
}
