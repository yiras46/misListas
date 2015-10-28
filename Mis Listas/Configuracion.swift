//
//  Configuracion.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit




class Configuracion: NSObject {
    
    static var UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    static var nueva_lista:String    = NSLocalizedString("Nueva-lista",comment:"Nueva lista")
    static var aceptar:String        = NSLocalizedString("Aceptar",comment:"Aceptar")
    static var cancelar:String       = NSLocalizedString("Cancelar",comment:"Cancelar")
    static var nombre:String         = NSLocalizedString("Nombre",comment:"Nombre")
    static var nuevo_elemento:String = NSLocalizedString("Nuevo-elemento",comment:"Nuevo elemento")
}
