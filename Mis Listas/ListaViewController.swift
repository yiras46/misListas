//
//  ListaViewController.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit

class ListaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var barraNavegacion:UINavigationItem!
    @IBOutlet var listaTabla:UITableView!
    @IBOutlet var marcadosTabla:UITableView!
    
    var tituloLista:String!

    
    
    /*
        MARK: UIViewControllerDelegate
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barraNavegacion.title = tituloLista
        
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
        barraNavegacion.title = tituloLista
    }
    
    
    
    /*
        MARK: UITableViewDelegate & UITableViewDataSource
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == marcadosTabla){
            
            return Configuracion.objetosMarcados.count
            
        }else if(tableView == listaTabla){
        
            return Configuracion.objetosLista.count
            
        }else{
            
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == listaTabla){
        
            let celda:ListaTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListaCell", forIndexPath: indexPath) as! ListaTableViewCell
        
            celda.titulo.text = Configuracion.objetosLista[indexPath.row]
            return celda
        
        }else{
            
            let celda:MarcadosTableViewCell = tableView.dequeueReusableCellWithIdentifier("CheckedCell", forIndexPath: indexPath) as! MarcadosTableViewCell
            
            celda.titulo.text = Configuracion.objetosMarcados[indexPath.row]
            return celda
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let celdaSeleccionada = tableView .cellForRowAtIndexPath(indexPath) //as! ListaTableViewCell
        celdaSeleccionada!.setSelected(false, animated: true)
    }

}
