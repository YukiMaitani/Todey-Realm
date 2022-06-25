//
//  Category.swift
//  Todoey-Realm
//
//  Created by 米谷裕輝 on 2022/06/25.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
