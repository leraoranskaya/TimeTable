//
//  HeaderHomeWorkView.swift
//  project
//
//  Created by Лерочка on 02.08.22.
//

import UIKit

protocol HeaderHomeWorkViewDelegate: AnyObject{
    func showMenuView()
    func showSettingView()
}

final class HeaderHomeWorkView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var menuButton: UIButton!
    
    weak var delegate: HeaderHomeWorkViewDelegate?

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
        }
    
    func disableHeaderView(){
        settingButton.isEnabled = false
        menuButton.isEnabled = false
    }
    
    func enabledHeaderView(){
        settingButton.isEnabled = true
        menuButton.isEnabled = true
    }
    
    @IBAction private func menuButtonAction(_ sender: Any) {
        delegate?.showMenuView()
    }
    
    @IBAction private func settingButtonAction(_ sender: Any) {
        delegate?.showSettingView()
    }
}
