//
//  CommentAddController.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

import UIKit
import RealmSwift

class CommentAddController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Outlet接続するもの
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var starSegmentControl: UISegmentedControl!
    @IBOutlet weak var commentImageView: UIImageView!
    
    //変数＆定数
    var selectedDb: Int!
    var detailId: Int!
    
    var omiyageCommentStar: Int = 1
    var omiyageCommentDetail: String!
    var omiyageCommentImage: UIImage!
    var currentDate: NSDate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        self.commentImageView.contentMode = UIViewContentMode.ScaleToFill
        self.omiyageCommentImage = UIImage(named: "noimage_omiyage_comment.jpg")
        self.commentImageView.image = self.omiyageCommentImage
        
        //UITextFieldのデリゲート設定
        self.commentTextField.delegate = self
        self.commentTextField.placeholder = "Comment"
    }
    
    
    //ボタンアクション
    @IBAction func hideKeyboardAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func changeStarAction(sender: UISegmentedControl) {
        self.omiyageCommentStar = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func omiyageCommentImageAction(sender: UIButton) {
        
        //UIActionSheetを起動して選択させて、カメラ・フォトライブラリを起動
        let alertActionSheet = UIAlertController(
            title: "Photo",
            message: "Select a photo",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "Camera Roll",
                style: UIAlertActionStyle.Default,
                handler: handlerActionSheet
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: handlerActionSheet
            )
        )
        presentViewController(alertActionSheet, animated: true, completion: nil)
        
    }
    
    
    //アクションシートの結果に応じて処理を変更
    func handlerActionSheet(ac: UIAlertAction) -> Void {
        
        switch ac.title! {
        case "Camera Roll":
            self.selectAndDisplayFromPhotoLibrary()
            break
        case "Cancel":
            break
        default:
            break
        }
    }
    
    
    //ライブラリから写真を選択してimageに書き出す
    func selectAndDisplayFromPhotoLibrary() {
        
        //フォトアルバムを表示
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    
    //画像を選択した時のイベント
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //画像をセットして戻る
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //リサイズして表示する
        let resizedImage = CGRectMake(
            image.size.width / 4.0,
            image.size.height / 4.0,
            image.size.width / 2.0,
            image.size.height / 2.0
        )
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, resizedImage)
        self.commentImageView.image = UIImage(CGImage: cgImage!)
    }
    
    
    @IBAction func addOmiyageCommentDataAction(sender: UIButton) {
        
        //UIImageデータを取得する
        self.omiyageCommentImage = self.commentImageView.image
        
        //バリデーションを通す前の準備
        self.omiyageCommentDetail = self.commentTextField.text
        self.currentDate = NSDate()
        
        //Error:UIAlertControllerでエラーメッセージ表示
        if (self.omiyageCommentDetail.isEmpty) {
            
            //エラーのアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "Error",
                message: "Please check the input and resend.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
            
        //OK:データを1件セーブする
        } else {
            
            if self.selectedDb == DbDefinition.RealmUse.rawValue {
            
                //Realmにデータを1件登録する
                let omiyageCommentObject = OmiyageComment.create()
                omiyageCommentObject.comment = self.omiyageCommentDetail
                omiyageCommentObject.star = self.omiyageCommentStar
                omiyageCommentObject.image = self.omiyageCommentImage
                omiyageCommentObject.omiyage_id = self.detailId
                omiyageCommentObject.createDate = self.currentDate
                
                //登録処理
                omiyageCommentObject.save()
                
}
            
            //全部テキストフィールドを元に戻す
            self.commentImageView.contentMode = UIViewContentMode.ScaleToFill
            self.omiyageCommentImage = UIImage(named: "noimage_omiyage_comment.jpg")
            self.commentImageView.image = self.omiyageCommentImage
            self.commentTextField.text = ""
            
            //登録されたアラートを表示してOKを押すと戻る
            let errorAlert = UIAlertController(
                title: "Done",
                message: "Completion of registration",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: saveComplete
                )
            )
            presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
    
    
    //登録が完了した際のアクション
    func saveComplete(ac: UIAlertAction) -> Void {
        self.navigationController?.popViewControllerAnimated(true)
}

    
      override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
    }
}


