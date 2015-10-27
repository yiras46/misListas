//
//  ListaViewController.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit
import Realm

class ListaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var barraNavegacion:UINavigationItem!
    @IBOutlet weak var nuevoItemBoton:UIBarButtonItem!
    @IBOutlet var listaTabla:UITableView!
    @IBOutlet var marcadosTabla:UITableView!
    
    let realm = RLMRealm.defaultRealm()
    var lista:Lista!
    
    
    
    /*
        MARK: UIViewControllerDelegate
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barraNavegacion.title = lista.nombre
        
        nuevoItemBoton.target = self;
        nuevoItemBoton.action = "crearItem:";
        
        listaTabla.delegate = self;
        listaTabla.dataSource = self;
        
        marcadosTabla.delegate = self;
        marcadosTabla.dataSource = self;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        barraNavegacion.title = lista.nombre
    }
    
    
    
    /*
        MARK: UITableViewDelegate & UITableViewDataSource
    */
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == marcadosTabla){
            
            return Int(lista.checked_items.count)
            
        }else if(tableView == listaTabla){
        
            return Int(lista.items.count)
            
        }else{
            
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == listaTabla){
        
            let celda:ListaTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListaCell", forIndexPath: indexPath) as! ListaTableViewCell
        
            celda.titulo.text = (lista.items.objectAtIndex(UInt(indexPath.row)) as! Item).titulo
            return celda
        
        }else{
            
            let celda:MarcadosTableViewCell = tableView.dequeueReusableCellWithIdentifier("CheckedCell", forIndexPath: indexPath) as! MarcadosTableViewCell
            
            let titulo:String = (lista.checked_items.objectAtIndex(UInt(indexPath.row)) as! Item).titulo
            celda.titulo.attributedText = titulo.tachar()
            return celda
        }
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return indexPath
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let celdaSeleccionada = tableView .cellForRowAtIndexPath(indexPath)
        celdaSeleccionada!.setSelected(false, animated: true)
        
        var marcar:Bool!
        
        if(tableView == listaTabla){
            marcar = true;
        }else{
            marcar = false;
        }
        
        marcarItem(marcar, posicion: indexPath.row)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            borrarItem(tableView, indexPath: indexPath)
        }
    }
    
    
    
    /*
    MARK: targets y eventos
    */
    
    func crearItem(sender:UIButton!){ //Se crea una nueva lista
        
        let titulo:NSAttributedString! = NSAttributedString(string: "Nuevo elemento", attributes: [NSForegroundColorAttributeName : UIColor.verdeOscuro(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(20)])
    
        let alertaNuevoItem: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        alertaNuevoItem.view.tintColor = UIColor.verdeOscuro()
        alertaNuevoItem.setValue(titulo, forKey: "attributedTitle")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Default) { action -> Void in
            
        }
        
        let addAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: .Cancel) { action -> Void in
            
            let textField:UITextField = alertaNuevoItem.textFields![0] as UITextField;
            
            if(textField.text?.characters.count > 0){
                
                self.realm.beginWriteTransaction()
                
                let nuevoItem:Item = Item()
                nuevoItem.titulo = textField.text!
                nuevoItem.category = "Default"
                self.lista.items.addObject(nuevoItem)
                
                self.realm.commitWriteTransaction()
                
                self.listaTabla .reloadData()
            }
        }
        
        alertaNuevoItem.addAction(cancelAction)
        alertaNuevoItem.addAction(addAction)
        alertaNuevoItem.addTextFieldWithConfigurationHandler { textField -> Void in
            
            textField.textColor = UIColor.verdeOscuro()
            textField.placeholder = "Nombre"
        }
        
        self.presentViewController(alertaNuevoItem, animated: true, completion: nil)
    }

    
    func marcarItem(marcar:Bool, posicion:Int){
        
        let item:Item!
        
        self.realm.beginWriteTransaction()
        
        if(marcar){
            
            item = lista.items.objectAtIndex(UInt(posicion)) as! Item
            lista.checked_items.addObject(item)
            lista.items.removeObjectAtIndex(UInt(posicion))
            
        }else{
            
            item = lista.checked_items.objectAtIndex(UInt(posicion)) as! Item
            lista.items.addObject(item)
            lista.checked_items.removeObjectAtIndex(UInt(posicion))
        }
        
        self.realm.commitWriteTransaction()
        
        listaTabla.reloadData()
        marcadosTabla.reloadData()
    }
    
    
    func borrarItem(tabla:UITableView, indexPath:NSIndexPath){
        
        self.realm.beginWriteTransaction()
        
        if tabla == listaTabla {
            
            lista.items.removeObjectAtIndex(UInt(indexPath.row))
            
        }else if tabla == marcadosTabla {
            
            lista.checked_items.removeObjectAtIndex(UInt(indexPath.row))
        }
        
        self.realm.commitWriteTransaction()
        
        tabla.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

}
