//
//  AddFieldsCell.swift
//  REST Tester
//
//  Created by Kenny Speer on 10/22/16.
//  Copyright © 2016 Kenny Speer. All rights reserved.
//

import UIKit

class AddFieldsCell: UITableViewCell {
    
    @IBOutlet weak var key: UILabel!
    @IBOutlet var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // init code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
