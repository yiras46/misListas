//
//  Lista.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import Realm
import UIKit

class Lista: RLMObject {
    
    dynamic var nombre = ""
    dynamic var usuario = ""
    //dynamic var items:[Item] = [Item]()
    dynamic var items:RLMArray = RLMArray(objectClassName: "Item")
}
