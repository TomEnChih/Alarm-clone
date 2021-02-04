//
//  AlarmTableViewCell.swift
//  alarm2.0
//
//  Created by 董恩志 on 2021/1/19.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var selectAmPm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
