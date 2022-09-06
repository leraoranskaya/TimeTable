//
//  BlurView.swift
//  project
//
//  Created by Лерочка on 06.07.22.
//

import UIKit

//protocol BlurView: AnyObject{
//    func showMenuView()
//    func showSettingView()
//}

final class BlurView: UIView{
    @IBOutlet private var contentView: UIView!
    let blurEffect = UIBlurEffect(style: .dark)
    var blurEffectView = UIVisualEffectView()
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
        contentView.backgroundColor = .clear
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.7
        blurEffectView.frame = contentView.bounds
        contentView.addSubview(blurEffectView)
    }
    
}
