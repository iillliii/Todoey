//
//  ToDo.swift
//  Todoey
//
//  Created by Home on 7/6/2562 BE.
//  Copyright © 2562 iilllii. All rights reserved.
//

import Foundation

class ToDo : Encodable, Decodable {
    
    var title : String = ""
    var check : Bool = false
    
    init(title : String){
        self.title = title
    }
    
}
