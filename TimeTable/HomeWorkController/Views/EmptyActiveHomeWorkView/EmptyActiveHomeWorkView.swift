//
//  EmptyActiveHomeWorkView.swift
//  project
//
//  Created by Лерочка on 18.08.22.
//

import UIKit

final class EmptyActiveHomeWorkView: UIView{
    @IBOutlet weak var addHomeWorkLabel: UILabel!
    @IBOutlet private var contentView: UIView!

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
            addHomeWorkLabel.layer.shadowColor = UIColor.black.cgColor
            addHomeWorkLabel.layer.shadowOpacity = 0.5
            addHomeWorkLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        }
}
