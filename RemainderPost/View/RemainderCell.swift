//
//  RemainderCell.swift
//  RemainderPost
//
//  Created by bennoui ihab on 5/16/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class RemainderCell: UITableViewCell {
    
    @IBOutlet weak var RemainderTitle : UILabel!
    @IBOutlet weak var RemainderDate : UILabel!
    @IBOutlet weak var CompletionValue : UILabel!
    @IBOutlet weak var RemainderType : UILabel!

    
    
    func configureCell(goal : Goal){
//make the formatter for the date :
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd,YYYY"
        
        RemainderTitle.text = goal.theGoal
        RemainderDate.text = formatter.string(from : goal.date!)
        CompletionValue.text = String(describing: goal.goalProgress)
        RemainderType.text = goal.type
        
        if goal.type == "Goal"{
            RemainderDate.isHidden = true 
        }
        if goal.goalCompleteValue == 0 {
            CompletionValue.isHidden = true
        }else {
            CompletionValue.isHidden = false
        }
    }

}
