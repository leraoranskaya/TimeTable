//
//  HomeWorkCell.swift
//  project
//
//  Created by Лерочка on 02.08.22.
//

import UIKit

protocol HomeWorkCellDelegate: AnyObject{
    func changeIsDoneMeaning(id: Int)
}

final class HomeWorkCell: UITableViewCell {
    static let identifier = "kHomeWorkCell"
    
    @IBOutlet private weak var lessonNameLabel: UILabel!
    @IBOutlet private weak var homeWorkLabel: UILabel!
    @IBOutlet private weak var deadlineLabel: UILabel!
    @IBOutlet private weak var isDoneButton: UIButton!
    
    private var addButtonId: Int?
    
    weak var delegate: HomeWorkCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMainAppearance()
    }
    
    func setup(with homeWorkModel: HomeWorkModel, addButtonId: Int){
        lessonNameLabel.text = homeWorkModel.lessonName
        homeWorkLabel.text = homeWorkModel.homeWork
        deadlineLabel.text = homeWorkModel.deadlineString
        switch homeWorkModel.isDone {
        case true:
            isDoneButton.setImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
        case false:
            isDoneButton.setImage(UIImage(systemName: "rectangle.portrait"), for: .normal)
        }
        self.addButtonId = addButtonId
    }
    
    @IBAction private func isDoneButtonAction(_ sender: Any) {
        if let id = addButtonId {
            delegate?.changeIsDoneMeaning(id: id)
        }
    }
}
