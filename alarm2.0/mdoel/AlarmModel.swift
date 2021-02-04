//
//  AlarmModel.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/14.
//

import Foundation


struct Alarm: Codable {
    
    var date: Date
    var label: String
    var isOn: Bool
    //model 只是藍圖,不要在這做任何初始化
    var selectDay: Set<Day> = []
    var modelSelection: ModeSelection
    
    var repeatString: String {
        switch selectDay {
        case [.mon,.tue,.wed,.thu,.fri]:
            return "平日"
        case [.sat,.sun]:
            return "週末"
        case [.sun,.mon,.tue,.wed,.thu,.fri,.sat]:
            return "每天"
        case []:
            return "永不"
        default :
            return selectDay
                .sorted(by: {$0.rawValue < $1.rawValue})
                .map({$0.detail})
                .joined(separator: " ")
        }
    }
    var alarmAppearString: String {
        switch selectDay {
        case [.mon,.tue,.wed,.thu,.fri]:
            return "，平日"
        case [.sat,.sun]:
            return "，週末"
        case [.sun,.mon,.tue,.wed,.thu,.fri,.sat]:
            return "，每天"
        case []:
            return ""
        default :
            if selectDay.count > 1 {
                return "，" + selectDay.sorted(by: {$0.rawValue < $1.rawValue}).map{$0.detail}.joined(separator: " ")
            }
            return selectDay.sorted(by: {$0.rawValue < $1.rawValue}).map({"，每\($0.detail)"}).joined(separator: " ")
            #warning("用map改")
        }
    }
    #warning("用join改")
    func appearTime()->(String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let alarmTime = formatter.string(from: date)
        return alarmTime
    }
    func appearTimeAmPm()->(String) {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "a"
        let alarmAmPm = Formatter.string(from: date)
        if alarmAmPm == "AM" {
            return "上午"
        }else{
            return "下午"
        }
    }
}

enum Day: Int, CaseIterable, Codable {
    case sun = 0,mon,tue,wed,thu,fri,sat
    
    var text: String {
        switch self {
        case .sun:
            return "星期日"
        case .mon:
            return "星期一"
        case .tue:
            return "星期二"
        case .wed:
            return "星期三"
        case .thu:
            return "星期四"
        case .fri:
            return "星期五"
        case .sat:
            return "星期六"
        }
    }
    var detail: String {
        switch self {
        case .sun:
            return "週日"
        case .mon:
            return "週一"
        case .tue:
            return "週二"
        case .wed:
            return "週三"
        case .thu:
            return "週四"
        case .fri:
            return "週五"
        case .sat:
            return "週六"
        }
    }

}

enum AddCell:String,CaseIterable {
    case 重複,標籤,鈴聲
}

enum Snooze:String,CaseIterable {
    case 稍後提醒
}

enum ModeSelection: String,Codable {
    case add,edit
    
    var title:String {
        switch self {
        case .add:
            return "加入鬧鐘"
        case .edit:
            return "編輯鬧鐘"
        }
    }
}


