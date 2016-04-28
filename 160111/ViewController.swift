//
//  ViewController.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    //Outlet接続したもの
    @IBOutlet weak var memoDataSearchBar: UISearchBar!
    @IBOutlet weak var memoDataTableView: UITableView!
    
    //変数＆定数
    var dbDefinitionValue : Int! = DbDefinition.RealmUse.rawValue
    var sortDefinitionValue : Int! = SortDefinition.SortId.rawValue
    
    var sortOrder: String! = ""
    var containsParameter: String! = ""
    
    var searchResultRealm: NSMutableArray = []
    
    var commentCount: Int = 0
    
    var searchActive: Bool = false
    
    var cellCount: Int!
    var cellSectionCount: Int = 1
    
    
    //出現中の処理
    override func viewWillAppear(animated: Bool) {
        self.fetchAndReloadData()
    }
    
    
    //出現後の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        //検索バーのデリゲート設定
        self.memoDataSearchBar?.delegate = self
        self.memoDataSearchBar?.showsCancelButton = true
        self.memoDataSearchBar?.placeholder = "Search"
        
        //テーブルビューのデリゲート設定
        self.memoDataTableView?.delegate = self
        self.memoDataTableView?.dataSource = self
        self.memoDataTableView?.allowsSelection = true
        
        //Xibのクラスを読み込む
        let nibDefault:UINib = UINib(nibName: "ListCell", bundle: nil)
        self.memoDataTableView?.registerNib(nibDefault, forCellReuseIdentifier: "ListCell")
    };
    

    //各データのfetchとテーブルビューのリロードを行う
    func fetchAndReloadData() {
        
        //Realmのとき
        if self.dbDefinitionValue == DbDefinition.RealmUse.rawValue {
            
            self.fetchObjectFromRealm()
            
        }
    }
    
    
    //SearchBarに関する設定一覧
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.containsParameter = searchText
        self.changeFetchTargetDb(self.dbDefinitionValue)
        
        self.view.endEditing(true)
        
        if self.cellCount == 0 {
            self.searchActive = false
        } else {
            self.searchActive = true
        }
    }
    
    //TableViewに関する設定一覧
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellSectionCount
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as? ListCell
        
        //Realmのとき
        if self.dbDefinitionValue == DbDefinition.RealmUse.rawValue {
            
            //テキスト・画像等の表示(Realm)
            let omiyageData: Omiyage = self.searchResultRealm[indexPath.row] as! Omiyage
            
            cell!.listTitle.text = omiyageData.title
            cell!.listImage.image = omiyageData.image
            
        }
        
        cell!.listImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell!.listImage.userInteractionEnabled = false
        
        
        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Realmのとき
        if self.dbDefinitionValue == DbDefinition.RealmUse.rawValue {
            
            //テキスト・画像等の表示(Realm)
            let omiyageData: Omiyage = self.searchResultRealm[indexPath.row] as! Omiyage
            
            let dict: NSDictionary = [
                "id" : omiyageData.id,
                "title" : omiyageData.title
            ]
            performSegueWithIdentifier("goDetail", sender: dict)
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(160.0)
    }
    
    
    func reloadData(){
        self.memoDataTableView?.reloadData()
    }
    
    
    //segueを呼び出したときに呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goAdd" {
            
            let addController = segue.destinationViewController as! AddController
            addController.selectedDb = self.dbDefinitionValue
            
        } else if segue.identifier == "goDetail" {
            
            let detailController = segue.destinationViewController as! DetailController
            let detailDataBean = sender as? NSDictionary
            
            detailController.selectedDb = self.dbDefinitionValue
            detailController.detailId = detailDataBean!["id"] as? Int
        }
    }
    
    
    //ボタンアクション
    @IBAction func memoDataAdd(sender: UIButton) {
        performSegueWithIdentifier("goAdd", sender: nil)
    }
    
    
    @IBAction func cameraViewCtr(sender: UIBarButtonItem) {
        performSegueWithIdentifier("goCamera", sender: nil)
    }
    
    
    //値によって読み込むDbを変更する
    func changeFetchTargetDb(dbDefinitionValue: Int) {
        
        if dbDefinitionValue == DbDefinition.RealmUse.rawValue {
            self.fetchObjectFromRealm()
        }
    }
    
    //Realmでのデータ取得時の処理
    // ----- ↓↓↓Realm処理：ここから↓↓↓ -----
    func fetchObjectFromRealm() {
        
        self.searchResultRealm.removeAllObjects()
        
        if self.sortDefinitionValue == SortDefinition.SortId.rawValue {
            self.sortOrder = "id"
        }
        
        let omiyages = Omiyage.fetchAllOmiyageList("\(self.sortOrder)", containsParameter: self.containsParameter)
        
        self.cellCount = omiyages.count
        
        if self.cellCount != 0 {
            for omiyage in omiyages {
                self.searchResultRealm.addObject(omiyage)
            }
        }
        
        //Debug.
        //print(self.searchResultRealm)
        
        self.reloadData()
        
        // ----- ↑↑↑Realm処理：ここまで↑↑↑ -----
    }
}

