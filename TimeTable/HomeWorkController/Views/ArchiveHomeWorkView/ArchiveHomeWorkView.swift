//
//  ArchiveHomeWorkView.swift
//  project
//
//  Created by Лерочка on 02.08.22.
//

import UIKit

final class ArchiveHomeWorkView: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyArchiveHomeWorkView: EmptyArchiveHomeWorkView!
    
    weak var delegate: HeaderViewDelegate?
    
    private var archiveHomeWorks: [HomeWorkModel] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "kToDoArchiveHomeWorkDataSource")
                UserDefaults.standard.synchronize()
            }
        }
        
        get {
            if let data = UserDefaults.standard.value(forKey: "kToDoArchiveHomeWorkDataSource") as? Data,
               let array = try? JSONDecoder().decode([HomeWorkModel].self, from: data) {
                return array.sorted(by: { $0.deadline < $1.deadline })
            } else {
                return []
            }
        }
    }

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
            tableView.delegate = self
            tableView.dataSource = self
            archiveHomeWorks.isEmpty ? showEmptyArchiveHomeWorkView() : showArchiveHomeWorks()
            
            print(archiveHomeWorks)
            
        }
    
    func appendArchiveHomeWorks(newArchiveHomeWorks: [HomeWorkModel]){
        for i in 0...newArchiveHomeWorks.count-1 {
            archiveHomeWorks.append(newArchiveHomeWorks[i])
        }
        tableView.reloadData()
    }
    
    private func showEmptyArchiveHomeWorkView(){
        tableView.isHidden = true
        emptyArchiveHomeWorkView.isHidden = false
    }
    
    private func showArchiveHomeWorks(){
        tableView.isHidden = false
        emptyArchiveHomeWorkView.isHidden = true
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ArchiveHomeWorkView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveHomeWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeWorkCell.identifier, for: indexPath) as! HomeWorkCell
        cell.setup(with: archiveHomeWorks[indexPath.row], addButtonId: indexPath.row)
//        cell.delegate = self
        return cell
    }
    
    
}
