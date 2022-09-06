//
//  DaysView.swift
//  project
//
//  Created by Лерочка on 06.07.22.
//

import UIKit

protocol DaysViewScrollDelegate: DaysCellDelegate {
    func didScrollto(indexPath: IndexPath)
}

final class DaysView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var daysCollectionView: UICollectionView!

    private var dataSource: [[LessonModel]] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "kToDoDataSource")
                UserDefaults.standard.synchronize()
            }
        }
        
        get {
            if let data = UserDefaults.standard.value(forKey: "kToDoDataSource") as? Data,
               let array = try? JSONDecoder().decode([[LessonModel]].self, from: data) {
                print(array)
                return array
            } else {
                return [[], [], [], [], [], [], []]
            }
        }
    }
    
    weak var delegate: DaysViewScrollDelegate?
    
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
            setupCollectionSettings()
            print(dataSource)
        }
    
    private func setupCollectionSettings(){
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.register(UINib(nibName: "DaysCell", bundle: nil), forCellWithReuseIdentifier: DaysCell.identifier)
    }
    
    func addLessonToDataSource(lesson: LessonModel, dayIndex: Int){
        dataSource[dayIndex].append(lesson)
        daysCollectionView.reloadData()
    }
    
    func aditLessonToDataSource(lesson: LessonModel, dayIndex: Int, lessonIndex: Int){
        dataSource[dayIndex][lessonIndex] = lesson
        daysCollectionView.reloadData()
    }
    
    
    func removeFromDataSource(dayIndex: Int, lessonIndex: Int){
        dataSource[dayIndex].remove(at: lessonIndex)
    }
    
    func removeAllFromDataSource(){
        for i in 0...dataSource.count - 1 {
            dataSource[i].removeAll()
        }
        daysCollectionView.reloadData()
    }
    
    func updateDaysCollectionView() {
        daysCollectionView.reloadData()
    }
    
    func scrollTo(day: Int) {
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(row: day, section: 0)
            self?.daysCollectionView.scrollToItem(at: indexPath,
                                                  at: .centeredHorizontally,
                                                  animated: false)
        }
    }
    
    func getLessonModelFromDataSource(dayIndex: Int, lessonIndex: Int) -> LessonModel{
        return dataSource[dayIndex][lessonIndex]
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DaysView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: DaysCell.identifier, for: indexPath) as! DaysCell
        cell.setup(with: dataSource[indexPath.row], addButtonId: indexPath.row, dayIndex: indexPath.row)
        if SettingView.editFlag{
            cell.editingTableView()
            cell.showSaveButton()
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(contentView.frame.width), height: CGFloat(contentView.frame.height))
    }
    
    func disableDaysCollectionView(){
        daysCollectionView.isUserInteractionEnabled = false
    }
    
    func enabledDaysCollectionView(){
        daysCollectionView.isUserInteractionEnabled = true
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        delegate?.didScrollto(indexPath: indexPath)
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        delegate?.didScrollto(indexPath: indexPath)

    }
}


//MARK: - DaysCellDelegate
extension DaysView: DaysCellDelegate{
    func moveLesson(moveRowAt: Int, destinationIndex: Int, dayIndex: Int) {
        let movedLesson = dataSource[dayIndex].remove(at: moveRowAt)
        dataSource[dayIndex].insert(movedLesson, at: destinationIndex)
        daysCollectionView.reloadData()
    }
    
    func showSelectedLessonView(lessonIndex: Int, dayIndex: Int) {
        delegate?.showSelectedLessonView(lessonIndex: lessonIndex, dayIndex: dayIndex)
    }
    
    func showCreateLessonView(id: Int) {
        delegate?.showCreateLessonView(id: id)
    }
}
