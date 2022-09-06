//
//  SettingsHomeWorkView.swift
//  project
//
//  Created by Лерочка on 10.08.22.
//

import UIKit

protocol SettingsHomeWorkViewDelegate: AnyObject{
    func showDeleteAllHomeWorkAlert()
}

final class SettingsHomeWorkView: UIView{
    @IBOutlet private var contentView: UIView!
    
    weak var delegate: SettingsHomeWorkViewDelegate?

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
    
    @IBAction private func deleteAllButtonAction(_ sender: Any) {
        delegate?.showDeleteAllHomeWorkAlert()
    }
    
}
