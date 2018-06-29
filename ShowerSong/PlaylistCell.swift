//
//  PlaylistCell.swift
//  ShowerSong
//
//  Created by Alexandre Ménielle on 29/06/2018.
//  Copyright © 2018 Alexandre Ménielle. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {
    
    let backgroundColor1 = #colorLiteral(red: 0.1622036099, green: 0.1622084081, blue: 0.1622058451, alpha: 1)
    let backgroundColor2 = #colorLiteral(red: 0.1336126328, green: 0.1336126328, blue: 0.1336126328, alpha: 1)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
