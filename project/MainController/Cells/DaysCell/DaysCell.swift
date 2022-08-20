//
//  DaysCell.swift
//  Timetable
//
//  Created by Анна Гранёва on 16.02.22.
//

import UIKit

protocol DaysCellDelegate: AnyObject{
    func showCreateLessonView(id: Int)
    func showSelectedLessonView(lessonIndex: Int, dayIndex: Int)
    func moveLesson(moveRowAt: Int, destinationIndex: Int, dayIndex: Int)
}

final class DaysCell: UICollectionViewCell {
    static let identifier = "kDaysCell"
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyLessonsView: EmptyLessonsView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var addLessonButton: UIButton!
    
    
    private var lessons: [LessonModel] = []
    weak var delegate: DaysCellDelegate?
    
    private var addButtonId: Int?
    private var dayIdForSelectedLesson: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableSettings()
        designAddLessonButton()
    }
    
    private func setupTableSettings(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LessonCell", bundle: nil), forCellReuseIdentifier: LessonCell.identifier)
    }
    
    func setup(with lessons: [LessonModel], addButtonId: Int, dayIndex: Int) {
        self.lessons = lessons
        self.addButtonId = addButtonId
        dayIdForSelectedLesson = dayIndex
        if lessons.isEmpty {
            showEmptyLessonsView()
        } else {
            showTableWithLessons()
        }
        saveButton.mainButton()
        tableView.reloadData()
    }
    
    private func showEmptyLessonsView(){
        emptyLessonsView.isHidden = false
        tableView.isHidden = true
    }
    
    private func showTableWithLessons(){
        emptyLessonsView.isHidden = true
        tableView.isHidden = false
    }
    
    func editingTableView(){
        tableView.isEditing = true
    }
    
    func showSaveButton(){
        saveButton.isHidden = false
        addLessonButton.isHidden = true
        
    }
    
    func showAddLessonButton(){
        saveButton.isHidden = true
        addLessonButton.isHidden = false
        
    }
    
    func designAddLessonButton(){
        addLessonButton.backgroundColor = .mainColor
        addLessonButton.layer.cornerRadius = 15
        addLessonButton.layer.masksToBounds = true
    }
    
    @IBAction private func addLessonButtonAction(_ sender: Any) {
        if let id = addButtonId {
            delegate?.showCreateLessonView(id: id)
        }
    }
    
    @IBAction private func saveButtonAction(_ sender: Any) {
        tableView.isEditing = false
        showAddLessonButton()
        SettingView.editFlag = false
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension DaysCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonCell.identifier, for: indexPath) as! LessonCell
        cell.setupWith(lesson: lessons[indexPath.row])
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "clickCellColor")
        bgColorView.layer.cornerRadius = 15
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dayId = dayIdForSelectedLesson{
            delegate?.showSelectedLessonView(lessonIndex: indexPath.row, dayIndex: dayId)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let dayId = dayIdForSelectedLesson{
            delegate?.moveLesson(moveRowAt: sourceIndexPath.row, destinationIndex: destinationIndexPath.row, dayIndex: dayId)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
