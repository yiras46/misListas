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
    
    //MARK: campos
    
    dynamic var nombre = ""
    dynamic var usuario = ""

    dynamic var items:RLMArray = RLMArray(objectClassName: "Item")
    dynamic var checked_items:RLMArray = RLMArray (objectClassName: "Item")
    
    
    
    //MARK: funciones para manejo de la lista de items
    
    /** Devuelve todas las listas del usuario */
    
    static func cargaListas()->RLMArray{
        
        return Lista.objectsInRealm(RLMRealm.defaultRealm(), withPredicate: NSPredicate(format: "usuario = %@", Configuracion.UUID)).toArray()
    }
    
    
    
    /** Crea una lista y la guarda*/
    
    static func crearLista(nombre:String){
        RLMRealm.defaultRealm().beginWriteTransaction()
        
        let listaNueva:Lista = Lista()
        listaNueva.nombre = nombre
        listaNueva.usuario = Configuracion.UUID
        Lista.createInDefaultRealmWithValue(listaNueva)
        
        RLMRealm.defaultRealm().commitWriteTransaction()
    }
    
    
    
    /** Agrega un item en la posición correcta de forma que las listas se encuentre ordenado */
    
    func agregarItem(item:Item, isMarcado:Bool, transaccionActivada:Bool){
        
        if(transaccionActivada){
            RLMRealm.defaultRealm().beginWriteTransaction()
        }
        
        var listaItems:RLMArray
        if(isMarcado){
            listaItems = checked_items
        }else{
            listaItems = items
        }
        
        if(listaItems.count == 0){
            
            listaItems.addObject(item)
        
        }else{
        
            for(var indice:UInt = 0; indice < listaItems.count; indice++){
                
                let tituloNuevo:String = item.titulo
                let tituloIndice:String = (listaItems.objectAtIndex(indice) as! Item).titulo
                
                if(tituloIndice.lowercaseString > tituloNuevo.lowercaseString){
                    
                    listaItems.insertObject(item, atIndex: indice)
                    break
                }else if(indice == listaItems.count - 1){
                    
                    listaItems.addObject(item)
                    break
                }
            }
        }
        
        if(transaccionActivada){
            RLMRealm.defaultRealm().commitWriteTransaction()
        }
    }
    
    
    
    /** Borra un item de alguna de las dos listas (marcados y no marcados) */
    
    func borrarItem(posicion:UInt, isMarcado:Bool){
        
        RLMRealm.defaultRealm().beginWriteTransaction()
        
        if isMarcado {
            
            checked_items.removeObjectAtIndex(posicion)
            
        }else{
            
            items.removeObjectAtIndex(posicion)
        }
        
        RLMRealm.defaultRealm().commitWriteTransaction()
    }
    
    
    
    /** Marca o desmarca un determinado Item de la lista */
    
    func marcarItem(marcar:Bool, posicion:Int){
        
        let item:Item!
        
        RLMRealm.defaultRealm().beginWriteTransaction()
        
        if(marcar){
            
            item = items.objectAtIndex(UInt(posicion)) as! Item
            agregarItem(item, isMarcado: true, transaccionActivada:false)
            items.removeObjectAtIndex(UInt(posicion))
            
        }else{
            
            item = checked_items.objectAtIndex(UInt(posicion)) as! Item
            agregarItem(item, isMarcado:false, transaccionActivada:false)
            checked_items.removeObjectAtIndex(UInt(posicion))
        }
        
        RLMRealm.defaultRealm().commitWriteTransaction()
        
    }
    
}
