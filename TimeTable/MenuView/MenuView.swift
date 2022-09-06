//
//  SettingView.swift
//  project
//
//  Created by Лерочка on 05.08.22.
//

import UIKit

protocol MenuViewDelegate: AnyObject{
    func presentTimetableVC()
    func presentHomeWorkVC()
}


class MenuView: UIView{
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var homeworkLabel: UIButton!
    @IBOutlet weak var timetableLabel: UIButton!
    weak var delegate: MenuViewDelegate?
    
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
        contentView.backgroundColor = UIColor(named: "mainViewColorThree")
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        homeworkLabel.layer.shadowColor = UIColor.black.cgColor
        homeworkLabel.layer.shadowOpacity = 0.5
        homeworkLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        timetableLabel.layer.shadowColor = UIColor.black.cgColor
        timetableLabel.layer.shadowOpacity = 0.5
        timetableLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    
    @IBAction private func timetableOfLessonsButtonAction(_ sender: Any) {
        delegate?.presentTimetableVC()
    }
    
    @IBAction private func homeWorkButtonAction(_ sender: Any) {
        delegate?.presentHomeWorkVC()
    }
}
