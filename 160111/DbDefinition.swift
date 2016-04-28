//
//  DbDefinition.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 ******. All rights reserved.
//

//格納用DBの選択enum
enum DbDefinition: Int {
    
    //セグメント番号の名称
    case RealmUse
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}
