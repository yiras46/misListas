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
        nuevoItemBoton.action = "lanzarDialogoCrearItem:";
        
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
        
        lista.marcarItem(marcar, posicion: indexPath.row)
        listaTabla.reloadData()
        marcadosTabla.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if(tableView == listaTabla){
                lista.borrarItem(UInt(indexPath.row), isMarcado: false)
            }else{
                lista.borrarItem(UInt(indexPath.row), isMarcado: true)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    
    /*
        MARK: funciones auxiliares
    */
    
    
    /** Lanza un diálogo para crear un nuevo item en la lista */
    
    func lanzarDialogoCrearItem(sender:UIButton!){
        
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
                
                let nuevoItem:Item = Item()
                nuevoItem.titulo = textField.text!
                nuevoItem.category = "Default"
                
                self.lista.agregarItem(nuevoItem, isMarcado: false, transaccionActivada:true)
                
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

}
