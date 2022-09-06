//
//  ViewController.swift
//  project
//
//  Created by Лерочка on 06.07.22.
//

import UIKit

final class TimetableViewController: UIViewController {
    
    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var daysOfTheWeekCollectionView: UICollectionView!
    @IBOutlet private weak var daysView: DaysView!
    @IBOutlet private weak var createLessonView: CreateLessonView!
    @IBOutlet private weak var selectedLessonView: SelectedLessonView!
    @IBOutlet private weak var settingView: SettingView!
    @IBOutlet private weak var menuView: MenuView!
    
    @IBOutlet weak var blurView: BlurView!
    @IBOutlet private weak var hideConstraintCreateLessonView: NSLayoutConstraint!
    private var daysOfTheWeekDataSourse: [DayOfTheWeekModel] = [DayOfTheWeekModel(dayName: "Пн"), DayOfTheWeekModel(dayName: "Вт"), DayOfTheWeekModel(dayName: "Ср"), DayOfTheWeekModel(dayName: "Чт"), DayOfTheWeekModel(dayName: "Пт"), DayOfTheWeekModel(dayName: "Сб"), DayOfTheWeekModel(dayName: "Вс")]
    
    private var pressedAddButtonId: Int?
    private var currentSelectedDayIndex: Int?
    private var currentSelectedLessonIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionSettings()
        setupGradient()
        daysView.delegate = self
        createLessonView.delegate = self
        selectedLessonView.delegate = self
        headerView.delegate = self
        settingView.delegate = self
        menuView.delegate = self
        daysOfTheWeekDataSourse[getCurrentDayIndex()].isSelect = true
        // mainView = UIView(frame: CGRect(x: 300, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        // mainView.backgroundColor = .clear
        blurView.alpha = 0
        
        //mainView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        daysView.scrollTo(day: getCurrentDayIndex())
    }
    
    private func setupCollectionSettings(){
        daysOfTheWeekCollectionView.delegate = self
        daysOfTheWeekCollectionView.dataSource = self
        daysOfTheWeekCollectionView.register(UINib(nibName: "DaysOfTheWeekCell", bundle: nil), forCellWithReuseIdentifier: DaysOfTheWeekCell.identifier)
    }
    
    func getCurrentDayIndex() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 1{
            return 6
        } else{
            return weekday - 2
        }
    }
    func setupGradient() {
        // градиент
        let color1 = UIColor(named: "mainViewColorOne")?.cgColor
        let color2 = UIColor(named: "mainViewColorTwo")?.cgColor
        let color3 = UIColor(named: "mainViewColorThree")?.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [color1 ?? UIColor.systemPink,
                           color2 ?? UIColor.purple,
                           color3 ?? UIColor.cyan]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !selectedLessonView.isHidden{
            selectedLessonView.isHidden = true
            enabledViews()
        }
        
        if !settingView.isHidden{
            menuView.isHidden = true
            //settingView.isHidden = true
            UIView.animate(withDuration: 0.4) {
                self.settingView.alpha = 0
            }
            enabledViews()
        }
        
        if !menuView.isHidden{
            menuView.alpha = 1
            self.blurView.alpha = 1
            
            //self.mainView.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.menuView.alpha = 0
                // self.blurEffectView.alpha = 0.1
                self.blurView.alpha = 0
                
            }
            //menuView.isHidden = true
            enabledViews()
        }
    }
    
    private func enabledViews(){
        headerView.enabledHeaderView()
        daysOfTheWeekCollectionView.isUserInteractionEnabled = true
        daysView.enabledDaysCollectionView()
    }
    
    private func disableViews(){
        headerView.disableHeaderView()
        daysOfTheWeekCollectionView.isUserInteractionEnabled = false
        daysView.disableDaysCollectionView()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension TimetableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfTheWeekDataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = daysOfTheWeekCollectionView.dequeueReusableCell(withReuseIdentifier: DaysOfTheWeekCell.identifier, for: indexPath) as! DaysOfTheWeekCell
        cell.setupWith(day: daysOfTheWeekDataSourse[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(view.frame.width / 8.2), height: CGFloat(40))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0...daysOfTheWeekDataSourse.count - 1{
            daysOfTheWeekDataSourse[i].isSelect = false
        }
        daysOfTheWeekDataSourse[indexPath.row].isSelect = true
        daysOfTheWeekCollectionView.reloadData()
        
        daysView.scrollTo(day: indexPath.row)
    }
}

//MARK: - DaysViewScrollDelegate
extension TimetableViewController: DaysViewScrollDelegate {
    func didScrollto(indexPath: IndexPath) {
        
        for i in 0...daysOfTheWeekDataSourse.count - 1{
            daysOfTheWeekDataSourse[i].isSelect = false
        }
        daysOfTheWeekDataSourse[indexPath.row].isSelect = true
        daysOfTheWeekCollectionView.reloadData()
    }
}

//MARK: - DaysCellDelegate
extension TimetableViewController: DaysCellDelegate{
    func moveLesson(moveRowAt: Int, destinationIndex: Int, dayIndex: Int) {
    }
    
    func showCreateLessonView(id: Int) {
        //createLessonView.isHidden = false
        createLessonView.alpha = 0
        
        //        blurEffectView.alpha = 0.1
        //        blurEffectView.frame = self.mainView.bounds
        self.blurView.alpha = 0
        // self.mainView.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.4) {
            self.createLessonView.alpha = 1
            self.createLessonView.isHidden = false
            //self.blurEffectView.alpha = 0.7
            self.blurView.alpha = 1
        }
        pressedAddButtonId = id
        createLessonView.changeCreateLessonViewType(createLessonViewType: .add)
        
        disableViews()
    }
    
    func showSelectedLessonView(lessonIndex: Int, dayIndex: Int) {
        currentSelectedLessonIndex = lessonIndex
        currentSelectedDayIndex = dayIndex
        selectedLessonView.isHidden = false
        
        disableViews()
    }
}

//MARK: - CreateLessonViewDelegate
extension TimetableViewController: CreateLessonViewDelegate{
    func aditCurrentLesson(lesson: LessonModel) {
        guard let dayIndex = currentSelectedDayIndex, let lessonIndex = currentSelectedLessonIndex else { return }
        daysView.aditLessonToDataSource(lesson: lesson, dayIndex: dayIndex, lessonIndex: lessonIndex)
    }
    
    func addCurrentLesson(lesson: LessonModel) {
        guard let id = pressedAddButtonId else { return }
        daysView.addLessonToDataSource(lesson: lesson, dayIndex: id)
    }
    
    func changedDownHideConstraint() {
        hideConstraintCreateLessonView.constant = 60
    }
    
    func changedUpHideConstraint() {
        hideConstraintCreateLessonView.constant = -5
    }
    
    func hideCreateLessonView(){
        // createLessonView.isHidden = true
        //        blurEffectView.alpha = 0.7
        //        self.blurEffectView.frame = self.mainView.bounds
        self.blurView.alpha = 1
        //self.mainView.addSubview(blurEffectView)
        //self.mainView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.createLessonView.alpha = 0
            //self.blurEffectView.alpha = 0.1
            self.blurView.alpha = 0
            
        }
        createLessonView.isHidden = true
        enabledViews()
    }
}


//MARK: - SelectedLessonViewDelegate
extension TimetableViewController: SelectedLessonViewDelegate{
    func editSelectedLesson() {
        if let dayIndex = currentSelectedDayIndex, let lessonIndex = currentSelectedLessonIndex{
            let lessonModel = daysView.getLessonModelFromDataSource(dayIndex: dayIndex, lessonIndex: lessonIndex)
            createLessonView.setToTextFields(with: lessonModel)
        }
        createLessonView.isHidden = false
        createLessonView.alpha = 0
        self.blurView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.createLessonView.alpha = 1
            self.createLessonView.isHidden = false
            self.blurView.alpha = 1
        }
        createLessonView.changeCreateLessonViewType(createLessonViewType: .adit)
    }
    
    func deleteSelectedLesson() {
        showDeleteLessonAlert()
    }
    
    func hideSelectedLessonView() {
        selectedLessonView.isHidden = true
    }
    
    private func showDeleteLessonAlert(){
        let alertController = UIAlertController(title: "", message: "Вы точно хотите удалить занятие?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] ok in
            if let dayIndex = self?.currentSelectedDayIndex, let lessonIndex = self?.currentSelectedLessonIndex{
                self?.daysView.removeFromDataSource(dayIndex: dayIndex, lessonIndex: lessonIndex)
            }
            self?.daysView.updateDaysCollectionView()
            self?.enabledViews()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default, handler: { [weak self] cancel in
            self?.enabledViews()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - HeaderViewDelegate
extension TimetableViewController: HeaderViewDelegate{
    func showMenuView() {
        menuView.alpha = 0
        
        //        blurEffectView.alpha = 0.1
        //       blurEffectView.frame = self.mainView.bounds
        self.blurView.alpha = 0
        // self.mainView.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.4) {
            self.menuView.alpha = 1
            self.menuView.isHidden = false
            //self.blurEffectView.alpha = 0.7
            self.blurView.alpha = 1
            //self.view.layoutIfNeeded()
        }
        disableViews()
    }
    
    func showSettingView() {
        // settingView.isHidden = false
        settingView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.settingView.alpha = 1
            self.settingView.isHidden = false
        }
        disableViews()
    }
}

//MARK: - SettingViewDelegate
extension TimetableViewController: SettingViewDelegate{
    func editTableView() {
        //settingView.isHidden = true
        settingView.alpha = 0
        daysView.updateDaysCollectionView()
        enabledViews()
    }
    
    func showDeleteAllAlert() {
        //settingView.isHidden = true
        settingView.alpha = 0
        let alertController = UIAlertController(title: "", message: "Вы точно хотите очистить расписание?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] ok in
            self?.daysView.removeAllFromDataSource()
            self?.enabledViews()
        }))
        alertController.addAction(UIAlertAction(title: "Нет", style: .default, handler: { [weak self] cancel in
            self?.enabledViews()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension TimetableViewController: MenuViewDelegate{
    func presentTimetableVC() {
        //        blurEffectView.alpha = 0.7
        //        blurEffectView.frame = self.mainView.bounds
        self.blurView.alpha = 1
        //self.mainView.addSubview(blurEffectView)
        //self.mainView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.menuView.alpha = 0
            // self.blurEffectView.alpha = 0.1
            self.blurView.alpha = 0
        }
        enabledViews()
        
    }
    
    func presentHomeWorkVC() {
        let homeWorkVC = HomeWorkViewController()
        homeWorkVC.modalPresentationStyle = .fullScreen
        homeWorkVC.modalTransitionStyle = .crossDissolve
        present(homeWorkVC, animated: true, completion: nil)
        menuView.isHidden = true
    }
}
