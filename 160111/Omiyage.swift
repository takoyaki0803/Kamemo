//
//  Omiyage.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

import UIKit

//Realmクラスのインポート
import RealmSwift

class Omiyage: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()
    
    //id
    dynamic var id = 0
    
    //タイトル
    dynamic var title = ""
    
    
    //その時の写真
    /**
    * 下記記事で紹介されている実装を元に作成
    *
    * JFYI：(Qiita) Realm × Swift2 でシームレスに画像を保存する
    * http://qiita.com/_ha1f/items/593ca4f9c97ae697fc75
    *
    */
    //
    dynamic private var _image: UIImage? = nil
    
    dynamic var image: UIImage? {
        
        //画像のセッター
        set {
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }
        
        //画像のゲッター
        get {
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }
    
    dynamic private var imageData: NSData? = nil
    
    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //保存しないプロパティの一覧
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    //新規追加用のインスタンス生成メソッド
    static func create() -> Omiyage {
        let omiyage = Omiyage()
        omiyage.id = self.getLastId()
        return omiyage
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let omiyage = realm.objects(Omiyage).last {
            return omiyage.id + 1
        } else {
            return 1
        }
    }
    
    //インスタンス保存用メソッド
    func save() {
        try! Omiyage.realm.write {
            Omiyage.realm.add(self)
        }
    }
    
    //インスタンス削除用メソッド
    func delete() {
        try! Omiyage.realm.write {
            Omiyage.realm.delete(self)
        
}
}
    //ソートをかけた順のデータの全件取得をする
    static func fetchAllOmiyageList(sortOrder: String, containsParameter: String) -> [Omiyage] {
        
        var omiyages: Results<Omiyage>
        
        if containsParameter.isEmpty {
            omiyages = realm.objects(Omiyage).sorted("\(sortOrder)", ascending: false)
        } else {
            let predicate = NSPredicate(format: "title CONTAINS %@", containsParameter, containsParameter)
            omiyages = realm.objects(Omiyage).sorted("\(sortOrder)", ascending: false).filter(predicate)
        }
        
        var omiyageList: [Omiyage] = []
        for omiyage in omiyages {
            omiyageList.append(omiyage)
        }
        return omiyageList
        
    }
}
