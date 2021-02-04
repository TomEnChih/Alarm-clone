//
//  Add_ViewController.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/12.
//

import UIKit

class AddViewController: UIViewController {

// MARK: Properties
    var addCells: [AddCell] = AddCell.allCases
    var snooze: [Snooze] = Snooze.allCases
    var tempAlarm: Alarm?
    #warning("model初始化注意")
    var delegate:AlarmSetDelegate?
    var addMode: ModeSelection = .add
    var editMode: ModeSelection = .edit
    var cellIndexPath: Int?
// MARK: IBOutlets
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateByAlarm()
        overrideUserInterfaceStyle = .dark
        myDatePicker.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        addTableView.isScrollEnabled = false
        addTableView.tableFooterView = UIView(frame: CGRect.zero)
        addTableView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        navigationItem.title = tempAlarm!.modelSelection.title
    }
    
//MARK: Methods
    @IBAction func saveAlarm(_ sender: UIBarButtonItem) {
        if tempAlarm!.modelSelection == .add {
            delegate?.setAlarm(alarm: tempAlarm!)
        }else{
            delegate?.valueChanged(alarm: tempAlarm!, index: cellIndexPath!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAlarm(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateByAlarm() {
        // 判斷模式
        // 判斷有沒有 tempAlarm 是否有值後，再看是否要給預設值
        if tempAlarm != nil {
            tempAlarm?.modelSelection = .edit
            transformTime()
        } else {
            tempAlarm = Alarm(date: Date(), label: "鬧鐘", isOn: true, selectDay: [], modelSelection: .add)
            selectTime()
        }
        addTableView.reloadData()
    }
    
//MARK: - DatePicker設定
    @IBAction func timeChangePicker(_ sender: UIDatePicker) {
        selectTime()
    }
    
    func selectTime() {
        tempAlarm?.date = myDatePicker.date
    }
    
    func transformTime() {
        myDatePicker.date = tempAlarm!.date
    }
    
//MARK: - 設定Header
    #warning("style可以做到")
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return ""
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 30
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        return header
    }
}

// MARK: - UITableViewDataSource
extension AddViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tempAlarm!.modelSelection{
        case .edit : return 3
        case .add  : return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tempAlarm!.modelSelection{
        case .edit :
            switch section {
            case 0: return addCells.count
            case 1: return snooze.count
            default: return 1
            }
        case .add :
        switch section {
        case 0: return addCells.count
        default: return snooze.count
        }
    }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            cell.textLabel?.text = addCells[indexPath.row].rawValue
            
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = tempAlarm?.repeatString
            }
            if indexPath.row == 1 {
                cell.detailTextLabel?.text = tempAlarm?.label
            }
            if indexPath.row == 2 {
                cell.detailTextLabel?.text = "無"
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Snooze", for: indexPath)
        cell.textLabel?.text = snooze[indexPath.row].rawValue
        
        
        if tempAlarm!.modelSelection == .edit{
            if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "刪除鬧鐘"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .red
                return cell
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "RepeatTableViewController") as! RepeatTableViewController
                vc.delegate = self
                vc.isSelectedDay = tempAlarm!.selectDay
                show(vc, sender: self)
            }
            if indexPath.row == 1 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LabelViewController") as! LabelViewController
                vc.delegate = self
                vc.alarmLabel = tempAlarm!.label
//                show(vc, sender: self)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 2{
            delegate?.deleteAlarm(index: cellIndexPath!)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - RepeatToAdd
extension AddViewController: RepeatToAdd {
    
    func repeatToAddSet(repeatSet: Set<Day>) {
        tempAlarm?.selectDay = repeatSet
        addTableView.reloadData()
    }
}

// MARK: - LabelToAdd
extension AddViewController: LabelToAdd {
    
    func labelToAdd(label: String) {
        tempAlarm?.label = label
        addTableView.reloadData()
    }
}


