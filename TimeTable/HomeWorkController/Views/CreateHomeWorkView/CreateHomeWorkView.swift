//
//  CreateHomeWorkView.swift
//  project
//
//  Created by Лерочка on 14.08.22.
//

import UIKit

protocol CreateHomeWorkViewDelegate: AnyObject{
    func hideCreateHomeWorkView()
    func addHomeWorkToActiveHomeworks(homeWork: HomeWorkModel)
    func aditHomeWork(newHomeWork: HomeWorkModel)
    func changedUpHideConstraint()
    func changedDownHideConstraint()
}

class CreateHomeWorkView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var textFields: [UITextField]!
    @IBOutlet private weak var calendarView: CalendarView!
    
    weak var delegate: CreateHomeWorkViewDelegate?
    
    private enum TextFieldsType: Int{
        case deadline = 1
        case lessonName = 2
        case homeWork = 3
    }
    
    private var createHomeWorkViewType: CreateLessonViewType = .add
    private var selectedDeadline: Date?
    
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
            calendarView.delegate = self
        }
    
    private func clearAllTextFields(){
        textFields.compactMap({ $0.text = "" })
    }
    
    func changeCreateHomeWorkViewType(createHomeWorkViewType: CreateLessonViewType){
        self.createHomeWorkViewType = createHomeWorkViewType
    }
    
    func setToTextFields(homeWork: HomeWorkModel){
        textFields.first(where: { $0.tag == TextFieldsType.deadline.rawValue })?.text = homeWork.deadlineString
        textFields.first(where: { $0.tag == TextFieldsType.lessonName.rawValue })?.text = homeWork.lessonName
        textFields.first(where: { $0.tag == TextFieldsType.homeWork.rawValue
        })?.text = homeWork.homeWork
    }
    
    @IBAction func textFieldsAction(_ sender: UITextField) {
        if sender.tag == TextFieldsType.deadline.rawValue {
            calendarView.isHidden = false
            endEditing(true)
        } else {
            delegate?.changedUpHideConstraint()
        }
        sender.layer.borderWidth = 0
    }
    
    
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        guard let deadlineString = textFields.first(where: { $0.tag == TextFieldsType.deadline.rawValue })?.text,
              let lessonName = textFields.first(where: { $0.tag == TextFieldsType.lessonName.rawValue })?.text,
              let homeWork = textFields.first(where: { $0.tag == TextFieldsType.homeWork.rawValue })?.text
        else { return }
        
        guard !deadlineString.isEmpty, !lessonName.isEmpty, !homeWork.isEmpty else {
            if deadlineString.isEmpty{
                textFields.first(where: { $0.tag == TextFieldsType.deadline.rawValue })?.layer.borderWidth = 2
                textFields.first(where: { $0.tag == TextFieldsType.deadline.rawValue })?.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            }
            if lessonName.isEmpty{
                textFields.first(where: { $0.tag == TextFieldsType.lessonName.rawValue })?.layer.borderWidth = 2
                textFields.first(where: { $0.tag == TextFieldsType.lessonName.rawValue })?.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            }
            if homeWork.isEmpty{
                textFields.first(where: { $0.tag == TextFieldsType.homeWork.rawValue })?.layer.borderWidth = 2
                textFields.first(where: { $0.tag == TextFieldsType.homeWork.rawValue })?.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            }
            return
        }
        
//        let deadline = HomeWorkModel.convertStringToDate(deadlineString: deadlineString)
        print("1111", self.selectedDeadline)
        guard let selectedDeadline = selectedDeadline else { return }
        print("2222" ,selectedDeadline)

        let homeWorkModel = HomeWorkModel(deadline: selectedDeadline, lessonName: lessonName, homeWork: homeWork)
        print("3333" ,selectedDeadline)
        switch createHomeWorkViewType {
        case .add:
            delegate?.addHomeWorkToActiveHomeworks(homeWork: homeWorkModel)
        case .adit:
            delegate?.aditHomeWork(newHomeWork: homeWorkModel)
        }
        
        textFields.compactMap({ $0.layer.borderWidth = 0 })
        endEditing(true)
        delegate?.hideCreateHomeWorkView()
        clearAllTextFields()
        delegate?.changedDownHideConstraint()
    }
    
    @IBAction private func cancelButtonAction(_ sender: Any) {
        endEditing(true)
        textFields.compactMap({ $0.layer.borderWidth = 0 })
        delegate?.hideCreateHomeWorkView()
        clearAllTextFields()
        delegate?.changedDownHideConstraint()
    }
}

//MARK: - CalendarViewDelegate
extension CreateHomeWorkView: CalendarViewDelegate{
    func hideCalendarView() {
        calendarView.isHidden = true
    }
    
    func saveSelectedDate(date: Date) {
        selectedDeadline = date
        textFields.first(where: { $0.tag == TextFieldsType.deadline.rawValue })?.text = HomeWorkModel.convertDateToString(deadline: date)
    }
}
