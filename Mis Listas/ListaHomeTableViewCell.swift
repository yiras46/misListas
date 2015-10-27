//
//  ListaHomeTableViewCell.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit

class ListaHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo:UILabel!
    @IBOutlet weak var detalle:UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

}
