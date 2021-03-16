//
//  Item.swift
//  Notepad
//
//  Created by Elmira on 13.03.21.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var note: String = ""
   @objc dynamic var date: Date?
    
}
