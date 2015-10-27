//
//  Configuracion.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit




class Configuracion: NSObject {
    
//MARK: colores
    
    static var verdeOscuro = UIColor(netHex:0x779e79) //verde oscuro
    
    static var UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    static var objetosLista = ["Objeto 1", "Objeto 2", "Objeto 3", "Objeto 4"]
    static var objetosMarcados = ["Marcado 1", "Marcado 2", "Marcado 3", "Marcado 4", "Marcado 5"]
}
