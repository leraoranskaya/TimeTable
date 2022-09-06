//
//  EmptyLessonsView.swift
//  project
//
//  Created by Лерочка on 15.07.22.
//

import UIKit

final class EmptyLessonsView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var emptyLessonLabel: UILabel!
    @IBOutlet weak var addLessonLabel: UILabel!
   
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
            contentView.backgroundColor = .clear
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addLessonLabel.layer.shadowColor = UIColor.black.cgColor
            addLessonLabel.layer.shadowOpacity = 0.5
            addLessonLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        }
    
    
}
