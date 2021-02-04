//
//  Repeat_TableViewController.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/12.
//

import UIKit

class RepeatTableViewController: UITableViewController {
    
    @IBOutlet weak var repeatTableView: UITableView!
    var delegate: RepeatToAdd!
    
    var days: [Day] = Day.allCases
    var isSelectedDay = Set<Day>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "重複"
        overrideUserInterfaceStyle = .dark
        repeatTableView.isScrollEnabled = false
        repeatTableView.tableFooterView = UIView(frame: CGRect.zero)
        repeatTableView.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.repeatToAddSet(repeatSet: isSelectedDay)
    }
    
    // MARK: - TableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        let day = days[indexPath.row]
        cell.textLabel?.text = day.text
        let isSelectedDayContained = isSelectedDay.contains(day)
        cell.accessoryType = isSelectedDayContained ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = days[indexPath.row]
        let isSelectedDayContained = isSelectedDay.contains(day)
        if isSelectedDayContained {
            isSelectedDay.remove(day)
        } else {
            isSelectedDay.insert(day)
        }
        tableView.reloadData()
    }
    
    //MARK: -設定Header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.black
        return header
    }
    
}

//        let cell = tableView.cellForRow(at: indexPath)
//
//        if alarm.selectDay.contains(Day(rawValue: indexPath.row)!) {
//            alarm.selectDay.remove(Day(rawValue: indexPath.row)!)
//        }else {
//            alarm.selectDay.insert(Day(rawValue: indexPath.row)!)
//        }
//        if alarm.selectDay.contains(Day(rawValue: indexPath.row)!) {
//            cell?.accessoryType = .checkmark
//        }else{
//            cell?.accessoryType = .none
//        }

//            tableView.deselectRow(at: indexPath, animated: true)
//        isSelected[indexPath.row].toggle()
//        tableView.reloadRows(at: indexPath, with: .none)
//        }

