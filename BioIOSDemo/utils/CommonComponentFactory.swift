//
//  CommonComponentFactory.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 21/02/24.
//

import UIKit

class CommonComponentFactory {
    
    static func buildLogo() -> UIImageView {
        let image = UIImageView(image: UIImage(named: "logo"))
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.red.cgColor
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 75
        image.clipsToBounds = true
        return image
    }
    
    static func buildAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
