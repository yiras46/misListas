//
//  Item.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit
import Realm

class Item: RLMObject {

    dynamic var titulo:String = ""
    dynamic var category:String = ""
    dynamic var foto:NSData = NSData()
}
