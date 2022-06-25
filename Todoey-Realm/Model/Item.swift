//
//  Item.swift
//  Todoey-Realm
//
//  Created by 米谷裕輝 on 2022/06/25.
//

import Foundation
import RealmSwift

class Item:Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
