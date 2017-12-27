//
//  TableViewCell.swift
//  Calculator
//
//  Created by YC X on 2017/12/27.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var recordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
