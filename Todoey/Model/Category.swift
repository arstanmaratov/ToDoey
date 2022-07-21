//
//  Category.swift
//  Todoey
//
//  Created by Арстан on 8/7/22.

//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
}
