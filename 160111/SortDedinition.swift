//
//  SortDedinition.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

//ソートの選択enum
enum SortDefinition: Int {
    
    //セグメント番号の名称
    case SortScore, SortId
    
    //enumの値を返す
    func returnValue() -> Int {
        return self.rawValue
    }
    
}
