//
//  Extensiones.swift
//  Mis Listas
//
//  Created by José Luis Fernández Mazaira on 8/10/15.
//  Copyright © 2015 JL Company. All rights reserved.
//

import UIKit
import Realm

/*
    MARK: UIColor
*/

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func verdeOscuro() ->UIColor{
        return UIColor(netHex:0x779e79)
    }
}

/*
    MARK: String
*/

extension String{
    
    func tachar() ->NSAttributedString{
    
        let strokeString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont.italicSystemFontOfSize(16.0)])
        strokeString.addAttribute(NSStrokeColorAttributeName, value: UIColor.blackColor(), range:  NSRange(location: 0, length: self.characters.count))
        strokeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSRange(location: 0, length: self.characters.count))
        
        return strokeString
    }
}

/*
    MARK: Realm
*/

extension RLMResults{
    
    func toArray()->RLMArray{
        
        let array:RLMArray = RLMArray(objectClassName: self.objectClassName)
        array .addObjects(self)
        return array;
    }
}

extension RLMArray{
    
    func borrarObjeto(posicion:UInt){
        
        let realm = RLMRealm.defaultRealm()
        
        realm.beginWriteTransaction()
        realm.deleteObject(self.objectAtIndex(posicion))
        realm.commitWriteTransaction()
    }
}

