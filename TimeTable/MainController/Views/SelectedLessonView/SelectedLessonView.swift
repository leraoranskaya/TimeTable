//
//  SelectedLessonView.swift
//  project
//
//  Created by Лерочка on 13.07.22.
//

import UIKit

protocol SelectedLessonViewDelegate: AnyObject{
    func hideSelectedLessonView()
    func deleteSelectedLesson()
    func editSelectedLesson()
}

final class SelectedLessonView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteLessonButton: UIButton!
    weak var delegate: SelectedLessonViewDelegate?

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        private func commonInit() {
            Bundle.main.loadNibNamed("\(type(of: self))", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            contentView.layer.cornerRadius = 20
            contentView.backgroundColor = .settingBackgroundColor
        }
    
    
    @IBAction private func aditLessonButtonAction(_ sender: Any) {
        delegate?.editSelectedLesson()
        delegate?.hideSelectedLessonView()
    }
    
    @IBAction private func deleteLessonButonAction(_ sender: Any) {
        delegate?.deleteSelectedLesson()
        delegate?.hideSelectedLessonView()
    }
}
