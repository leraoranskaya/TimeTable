//
//  SettingView.swift
//  project
//
//  Created by Лерочка on 15.07.22.
//

import UIKit

protocol SettingViewDelegate: AnyObject{
    func showDeleteAllAlert()
    func editTableView()
}

final class SettingView: UIView{
    @IBOutlet private var contentView: UIView!
    weak var delegate: SettingViewDelegate?
    
    static var editFlag = false

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
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = .settingBackgroundColor
        }
    
    @IBAction private func editButtonAction(_ sender: Any) {
        SettingView.editFlag = true
        delegate?.editTableView()
    }
    
    @IBAction private func deleteAllButtonAction(_ sender: Any) {
        delegate?.showDeleteAllAlert()
    }
}
