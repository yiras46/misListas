//
//  ViewController.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit
import Realm


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /*
        MARK: IBOUTlets & IBActions
    */
    
    var listasUsuario:RLMResults!
    let realm = RLMRealm.defaultRealm()
    
    @IBOutlet var addButton:UIButton!
    @IBOutlet var listaTabla:UITableView!
    
    var indiceSeleccionado=0
    
    /*
        MARK: UIViewControllerDelegate
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: "crearNuevaLista:", forControlEvents: .TouchUpInside);
        
        cargarListas();
        
        listaTabla.delegate = self;
        listaTabla.dataSource = self;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /* 
        MARK: UITableViewDelegate & UITableViewDataSource
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int(listasUsuario.count)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let celda:ListaHomeTableViewCell = tableView.dequeueReusableCellWithIdentifier("CeldaHome", forIndexPath: indexPath) as! ListaHomeTableViewCell
        
        let lista = listasUsuario.objectAtIndex(UInt(indexPath.row)) as! Lista
        celda.titulo.text = lista.nombre
        return celda
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        indiceSeleccionado = indexPath.row
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let celdaSeleccionada = tableView .cellForRowAtIndexPath(indexPath) as! ListaHomeTableViewCell
        celdaSeleccionada.setSelected(false, animated: true)
    }
    

    
    /*
        MARK: targets y eventos
    */
    
    func crearNuevaLista(sender:UIButton!){ //Se crea una nueva lista

        let alertaNuevaLista: UIAlertController = UIAlertController(title: "Nueva lista", message: nil, preferredStyle: .Alert)
        alertaNuevaLista.view.tintColor = Configuracion.verdeOscuro
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { action -> Void in
            
        }
        
        let addAction: UIAlertAction = UIAlertAction(title: "Aceptar", style: .Default) { action -> Void in
            
            let textField:UITextField = alertaNuevaLista.textFields![0] as UITextField;
            
            if(textField.text?.characters.count > 0){
            
                self.realm.beginWriteTransaction()
                
                let listaNueva:Lista = Lista()
                listaNueva.nombre = textField.text!
                listaNueva.usuario = Configuracion.UUID
                Lista.createInDefaultRealmWithValue(listaNueva)
                
                self.realm.commitWriteTransaction()
                
                self.cargarListas()
            }
            
        }
        
        alertaNuevaLista.addAction(cancelAction)
        alertaNuevaLista.addAction(addAction)
        alertaNuevaLista.addTextFieldWithConfigurationHandler { textField -> Void in
            
            textField.textColor = Configuracion.verdeOscuro
            textField.placeholder = "Nombre"
        }
        
        self.presentViewController(alertaNuevaLista, animated: true, completion: nil)
    }
    
    func cargarListas(){ //Se cargan las listas del usuario
        
        listasUsuario = Lista.objectsInRealm(realm, withPredicate: NSPredicate(format: "usuario = %@", Configuracion.UUID))
        listaTabla.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toDetalleLista"){
            
            let listaViewController = segue.destinationViewController as! ListaViewController
            listaViewController.lista = listasUsuario.objectAtIndex(UInt(indiceSeleccionado)) as! Lista;
        }
    }

}

