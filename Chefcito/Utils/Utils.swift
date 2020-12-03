//
//  Utils.swift
//  Chefcito
//
//  Created by Martin Nava Pe&a on 03/12/20.
//

import Foundation

struct Utils {
    
    public static func parseInt (value: String) -> Int {
        guard let num = Int(value) else {
            return 0
        }
        
        return num
    }
}
