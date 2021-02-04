//
//  Protocol.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/12.
//

import Foundation

protocol RepeatToAdd {
    func repeatToAddSet(repeatSet:Set<Day>)
}

protocol AddToAlarm {
    func addToAlarm()
}

protocol LabelToAdd {
    func labelToAdd(label:String)
}

protocol AlarmSetDelegate {
    func setAlarm(alarm:Alarm)
    func valueChanged(alarm: Alarm,index: Int)
    func deleteAlarm(index: Int)
}

