//
//  ViewController.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/12.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    var alarms = [Alarm]() {
        didSet{
            save()
        }
    }
    var addMode: ModeSelection = .add
    var editMode: ModeSelection = .edit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        EditNavigtion()
        alarmTableView.tableFooterView = UIView(frame: CGRect.zero)
        alarmTableView.backgroundColor = UIColor.black
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        EditNavigtion()
    }
    
    //MARK: 儲存資料
    func save() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alarms),forKey: "alarm")
    }
    func loadData() {
        if let data = UserDefaults.standard.value(forKey:  "alarm")as? Data{
            if let alarmsLoad = try?PropertyListDecoder().decode(Array<Alarm>.self, from: data){
                alarms = alarmsLoad
            }
        }
    }
    
    //MARK: 編輯navigation
    func EditNavigtion(){
        navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "編輯"
    }
    
    //MARK: 新增鬧鐘
    @IBAction func addNewAlarm(_ sender: UIBarButtonItem) {
        let nvc = storyboard?.instantiateViewController(withIdentifier: "AddNavigationController") as! UINavigationController
        let vc = nvc.viewControllers.first as! AddViewController
        vc.delegate = self
        present(nvc, animated: true, completion: nil)
        setEditing(false, animated: false)
    }
    
    //MARK: 刪除tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    //MARK: 編輯模式
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        alarmTableView.setEditing(editing, animated: true)
        if alarmTableView.isEditing {
            self.navigationItem.leftBarButtonItem?.title  = "完成"
            alarmTableView.allowsSelectionDuringEditing = true
            
        }else{
            self.navigationItem.leftBarButtonItem?.title = "編輯"
            alarmTableView.allowsSelectionDuringEditing = false
            
        }
    }
    
    //MARK: 向右滑動時,『編輯』Title改變
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.navigationItem.leftBarButtonItem?.title  = "完成"
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.navigationItem.leftBarButtonItem?.title  = "編輯"
    }
    
    //MARK: 可否編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    //MARK: navigationTitle 顯示
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
                navigationItem.title = "鬧鐘"
            }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            navigationItem.title = ""
        }
    }
}

    // MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        default: return alarms.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            cell.textLabel?.text = "鬧鐘"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
            alarmTableView.rowHeight = 60
            cell.selectionStyle = .none //cell無法被點選
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlarmTableViewCell
        let alarmIndex = alarms[indexPath.row]
        cell.timeLabel.text = alarmIndex.appearTime()
        cell.selectAmPm.text = alarmIndex.appearTimeAmPm()
        #warning("用一個label寫看看")
        cell.detailLabel.text = alarms[indexPath.row].label + alarms[indexPath.row].alarmAppearString
        let myswitch = UISwitch(frame: .zero)
        myswitch.isOn = alarms[indexPath.row].isOn
        cell.accessoryView = myswitch
        cell.editingAccessoryType = .disclosureIndicator
        alarmTableView.rowHeight = 100
        cell.selectionStyle = .none
        return cell
    }
}

    // MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if alarmTableView.allowsSelectionDuringEditing {
                let nvc = storyboard?.instantiateViewController(withIdentifier: "AddNavigationController") as! UINavigationController
//                performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
                let vc = nvc.viewControllers.first as! AddViewController
                vc.tempAlarm = alarms[indexPath.row]
                vc.cellIndexPath = indexPath.row
                vc.delegate = self
                present(nvc, animated: true, completion: nil)
                setEditing(false, animated: false)
            }
        }
    }
}

    //MARK: - 新增/編輯/刪除鬧鐘 delegate
extension ViewController: AlarmSetDelegate {
    
    func setAlarm(alarm: Alarm) {
        alarms.append(alarm)
        alarmsSort()
    }
    
    func valueChanged(alarm: Alarm, index: Int) {
        alarms[index] = alarm
        alarmsSort()
    }
    
    func deleteAlarm(index: Int) {
        alarms.remove(at: index)
        alarmsSort()
    }
    
    //MARK: alarms 排序
    func alarmsSort() {
        alarms.sort{(alarm1,alarm2) in
            return alarm1.date < alarm2.date}
        alarmTableView.reloadData()
    }
}

