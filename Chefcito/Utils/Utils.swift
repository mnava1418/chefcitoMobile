//
//  Utils.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 03/12/20.
//

import Foundation
import UIKit

struct Utils {
    
    public static func parseInt (value: String) -> Int {
        guard let num = Int(value) else {
            return 0
        }
        
        return num
    }
    
    public static func loadImage(url: URL, completion: @escaping(UIImage) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
