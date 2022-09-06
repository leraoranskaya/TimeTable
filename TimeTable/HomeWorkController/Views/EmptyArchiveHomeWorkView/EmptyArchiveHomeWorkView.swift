//
//  EmptyArchiveHomeWorkView.swift
//  project
//
//  Created by Лерочка on 19.08.22.
//

import UIKit

final class EmptyArchiveHomeWorkView: UIView{
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
        }
}
