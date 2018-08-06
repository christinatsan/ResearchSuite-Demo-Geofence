//
//  UIColor+Hex.swift
//  Alamofire
//
//  Created by James Kizer on 5/12/18.
//

import UIKit

public extension UIColor {
    // Assumes input like "#00FF00" (#RRGGBB).
    public convenience init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1
        var x: UInt32 = 0
        scanner.scanHexInt32(&x)
        let red: CGFloat = CGFloat((x & 0xFF0000) >> 16)/255.0
        let green: CGFloat = CGFloat((x & 0xFF00) >> 8)/255.0
        let blue: CGFloat = CGFloat(x & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha:1.0)
    }
    
    //output: #RRGGBB
    var hexString: String {
        
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let red = String(Int(fRed * 255.0), radix: 16)
            let green = String(Int(fGreen * 255.0), radix: 16)
            let blue = String(Int(fBlue * 255.0), radix: 16)
            
            return "#\(red)\(green)\(blue)"
        }
        else {
            assertionFailure()
            return "conversion failed"
        }
    }
}
