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
        MARK: variables & IBOUTlets & IBActions
    */
    
    var listasUsuario:RLMArray!
    var indiceSeleccionado=0
    //let realm = RLMRealm.defaultRealm()
    
    @IBOutlet var addButton:UIButton!
    @IBOutlet var listaTabla:UITableView!
    
    
    
    /*
        MARK: UIViewControllerDelegate
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.addTarget(self, action: "lanzarDialogoCrearNuevaLista:", forControlEvents: .TouchUpInside);
        
        listasUsuario = Lista.cargaListas()
        
        listaTabla.delegate = self;
        listaTabla.dataSource = self;
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    /* 
        MARK: UITableViewDelegate & UITableViewDataSource
    */
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    
    
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

    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            tableView.beginUpdates()
            
            listasUsuario.borrarObjeto(UInt(indexPath.row))
            listasUsuario = Lista.cargaListas()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }

    
    
    /*
        MARK: funciones auxiliares
    */
    
    
    /** Se crea una nueva lista*/
    
    func lanzarDialogoCrearNuevaLista(sender:UIButton!){

        let titulo:NSAttributedString! = NSAttributedString(string: Configuracion.nueva_lista, attributes: [NSForegroundColorAttributeName : UIColor.verdeOscuro(),
            NSFontAttributeName : UIFont.boldSystemFontOfSize(20)])
        
        let alertaNuevaLista: UIAlertController = UIAlertController(title:nil, message: nil, preferredStyle: .Alert)
        alertaNuevaLista.view.tintColor = UIColor.verdeOscuro()
        alertaNuevaLista.setValue(titulo, forKey: "attributedTitle")
        
        let addAction: UIAlertAction = UIAlertAction(title: Configuracion.aceptar, style: .Cancel) { action -> Void in
            
            let textField:UITextField = alertaNuevaLista.textFields![0] as UITextField;
            
            if(textField.text?.characters.count > 0){
            
                Lista.crearLista(textField.text!)
                self.listasUsuario = Lista.cargaListas()
                self.listaTabla.reloadData()
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: Configuracion.cancelar, style: .Default) { action -> Void in
            
        }
        
        alertaNuevaLista.addAction(addAction)
        alertaNuevaLista.addAction(cancelAction)
        alertaNuevaLista.addTextFieldWithConfigurationHandler { textField -> Void in
            
            textField.textColor = UIColor.verdeOscuro()
            textField.placeholder = Configuracion.nombre
        }
        
        self.presentViewController(alertaNuevaLista, animated: true, completion: nil)
    }
    
    
    
    /*
        MARK: Segues
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toDetalleLista"){
            
            let listaViewController = segue.destinationViewController as! ListaViewController
            listaViewController.lista = listasUsuario.objectAtIndex(UInt(indiceSeleccionado)) as! Lista;
        }
    }

}

