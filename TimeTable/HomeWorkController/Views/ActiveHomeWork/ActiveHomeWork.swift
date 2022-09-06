
import UIKit

protocol ActiveHomeWorkDelegate: AnyObject{
    func enabledViews()
    func disableViews()
    func showDeleteHomeWorkAlert(at index: Int)
    func newArchiveHomeWorks(newArchiveHomeWorks: [HomeWorkModel])
    func showBlurView()
    func hideBlurView()
}

final class ActiveHomeWork: UIView{
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var createHomeWorkView: CreateHomeWorkView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var hideConstraintCreateHomeWorkView: NSLayoutConstraint!
    @IBOutlet weak var blurView: BlurView!
    @IBOutlet private(set) weak var selectedHomeWorkView: SelectedHomeWorkView!
    @IBOutlet private weak var emptyActiveHomeWorkView: EmptyActiveHomeWorkView!
    let currentDate = NSDate()
    
    
    private var activeHomeWorks: [HomeWorkModel] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "kToDoHomeWorkDataSource")
                UserDefaults.standard.synchronize()
            }
        }
        
        get {
            if let data = UserDefaults.standard.value(forKey: "kToDoHomeWorkDataSource") as? Data,
               let array = try? JSONDecoder().decode([HomeWorkModel].self, from: data) {
                return array.sorted(by: { $0.deadline < $1.deadline })
            } else {
                return []
            }
        }
    }
    
    weak var delegate: ActiveHomeWorkDelegate?
    private var selectedHomeWorkIndex: Int?
    //    private var currentDate = Date()
    
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
        sortActiveAndArchiveHomeWorks()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeWorkCell", bundle: nil), forCellReuseIdentifier: HomeWorkCell.identifier)
        createHomeWorkView.delegate = self
        selectedHomeWorkView.delegate = self
        
        activeHomeWorks.isEmpty ? showEmptyActiveHomeWorkView() : showActiveHomeWorks()
        designAddButton()
    }
    
    //    func setActiveHomeWork(activeHomeWorks: [HomeWorkModel]){
    //        self.activeHomeWorks = activeHomeWorks
    //    }
    
//        func sortActiveAndArchiveHomeWorks(){
//            print(currentDate)
//            var active: [HomeWorkModel] = []
//            var archive: [HomeWorkModel] = []
//            for i in 0...activeHomeWorks.count - 1 {
//                if activeHomeWorks[i].deadline > currentDate as Date {
//                    archive.append(activeHomeWorks[i])
//                } else {
//                    active.append(activeHomeWorks[i])
//                }
//            }
//            print(archive, "arh")
//            activeHomeWorks = active
//            delegate?.newArchiveHomeWorks(newArchiveHomeWorks: archive)
//        }
    
    func sortActiveAndArchiveHomeWorks(){
        var active: [HomeWorkModel] = activeHomeWorks.filter({ $0.isActive == true })
        var archive: [HomeWorkModel] = activeHomeWorks.filter({ $0.isActive == false })
        print(active, "act")
        print(archive, "arh")
        activeHomeWorks = active
        delegate?.newArchiveHomeWorks(newArchiveHomeWorks: archive)
    }
    
    func designAddButton(){
        addButton.backgroundColor = .mainColor
        addButton.layer.cornerRadius = 15
        addButton.layer.masksToBounds = true
    }
    
    func disableTableView(){
        tableView.isUserInteractionEnabled = false
        addButton.isEnabled = false
    }
    
    func enabledTableView(){
        tableView.isUserInteractionEnabled = true
        addButton.isEnabled = true
    }
    
    func showCreateHomeWorkView(){
        // createHomeWorkView.isHidden = false
        createHomeWorkView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.createHomeWorkView.alpha = 1
            self.createHomeWorkView.isHidden = false
        }
        delegate?.showBlurView()
        delegate?.disableViews()
    }
    
    func removeFromActiveHomeWorks(at index: Int){
        activeHomeWorks.remove(at: index)
    }
    
    func updateTableView(){
        tableView.reloadData()
    }
    
    func showEmptyActiveHomeWorkView(){
        tableView.isHidden = true
        emptyActiveHomeWorkView.isHidden = false
    }
    
    func showActiveHomeWorks(){
        tableView.isHidden = false
        emptyActiveHomeWorkView.isHidden = true
    }
    
    func countOfActiveHomeWorks() -> Int{
        return activeHomeWorks.count
    }
    
    func removeAllFromActiveHomeWorks(){
        activeHomeWorks.removeAll()
        tableView.reloadData()
        showEmptyActiveHomeWorkView()
    }
    
    @IBAction private func addButtonAction(_ sender: Any) {
        showCreateHomeWorkView()
        delegate?.disableViews()
        delegate?.showBlurView()
        createHomeWorkView.changeCreateHomeWorkViewType(createHomeWorkViewType: .add)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ActiveHomeWork: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeHomeWorks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeWorkCell.identifier, for: indexPath) as! HomeWorkCell
        cell.setup(with: activeHomeWorks[indexPath.row], addButtonId: indexPath.row)
        cell.delegate = self
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "clickCellColor")
        bgColorView.layer.cornerRadius = 15
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHomeWorkIndex = indexPath.row
        selectedHomeWorkView.isHidden = false
        delegate?.disableViews()
        createHomeWorkView.changeCreateHomeWorkViewType(createHomeWorkViewType: .adit)
    }
}

//MARK: - HomeWorkCellDelegate
extension ActiveHomeWork: HomeWorkCellDelegate{
    func changeIsDoneMeaning(id: Int) {
        activeHomeWorks[id].isDone.toggle()
        tableView.reloadData()
    }
}

//MARK: - CreateHomeWorkViewDelegate
extension ActiveHomeWork: CreateHomeWorkViewDelegate{
    func aditHomeWork(newHomeWork: HomeWorkModel) {
        guard let selectedIndex = selectedHomeWorkIndex else { return}
        activeHomeWorks[selectedIndex] = newHomeWork
        tableView.reloadData()
    }
    
    func changedUpHideConstraint() {
        hideConstraintCreateHomeWorkView.constant = -30
    }
    
    func changedDownHideConstraint() {
        hideConstraintCreateHomeWorkView.constant = 60
    }
    
    func addHomeWorkToActiveHomeworks(homeWork: HomeWorkModel) {
        activeHomeWorks.append(homeWork)
        activeHomeWorks = activeHomeWorks.sorted(by: { $0.deadline < $1.deadline })
        tableView.reloadData()
        showActiveHomeWorks()
    }
    
    func hideCreateHomeWorkView() {
        createHomeWorkView.isHidden = true
        createHomeWorkView.alpha = 0
        delegate?.enabledViews()
        delegate?.hideBlurView()
    }
}

//MARK: - SelectedHomeWorkViewDelegate
extension ActiveHomeWork: SelectedHomeWorkViewDelegate{
    func showBlurView() {
        blurView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 1
        }
    }
    func deleteSelectedHomeWork() {
        guard let selectedIndex = selectedHomeWorkIndex else { return }
        delegate?.showDeleteHomeWorkAlert(at: selectedIndex)
    }
    
    func editSelectedHomeWork() {
        guard let selectedIndex = selectedHomeWorkIndex else { return }
        hideSelectedHomeWorkView()
        createHomeWorkView.setToTextFields(homeWork: activeHomeWorks[selectedIndex])
        showCreateHomeWorkView()
    }
    
    func hideSelectedHomeWorkView(){
        selectedHomeWorkView.isHidden = true
    }
    
}

