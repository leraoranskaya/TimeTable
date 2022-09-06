//
//  SelectedHomeWorkView.swift
//  project
//
//  Created by Лерочка on 16.08.22.
//

import UIKit

protocol SelectedHomeWorkViewDelegate: AnyObject{

    func hideSelectedHomeWorkView()
    func deleteSelectedHomeWork()
    func editSelectedHomeWork()
   
    
   // func hideBlurView()
}

final class SelectedHomeWorkView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var editHomeWorkButton: UIButton!
    @IBOutlet private weak var deleteHomeWorkButton: UIButton!
    
    weak var delegate: SelectedHomeWorkViewDelegate?

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
    
    
    @IBAction private func aditHomeWorkButtonAction(_ sender: Any) {
        delegate?.editSelectedHomeWork()
        delegate?.hideSelectedHomeWorkView()
       
    }
    
    @IBAction private func deleteHomeWorkButonAction(_ sender: Any) {
        delegate?.deleteSelectedHomeWork()
        delegate?.hideSelectedHomeWorkView()
    }
}
