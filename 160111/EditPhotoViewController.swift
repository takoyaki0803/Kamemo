//
//  EditPhotoViewController.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 YasuhiroSugisawa. All rights reserved.
//

import AVFoundation
import UIKit


class EditPhotoViewController: UIViewController,UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    //設定保存　呼び出し
    let CameraData = NSUserDefaults.standardUserDefaults()
    
    //ImageView
    var myInputImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //同期処理
        self.CameraData.synchronize()
        
        //撮影した画像呼び出し
        let myInputImage = UIImage(data: CameraData.objectForKey("Photo")as! NSData)
        
        
        let adobeViewCtr = AdobeUXImageEditorViewController(image: myInputImage!)
        adobeViewCtr.delegate = self
        self.presentViewController(adobeViewCtr, animated: true) { () -> Void in
            
            
            //編集に使える項目
            AdobeImageEditorCustomization.setToolOrder([
                
                kAdobeImageEditorEnhance,        /* Enhance */
                kAdobeImageEditorEffects,        /* Effects */
                kAdobeImageEditorStickers,       /* Stickers */
                kAdobeImageEditorOrientation,    /* Orientation */
                kAdobeImageEditorCrop,           /* Crop */
                kAdobeImageEditorColorAdjust,    /* Color */
                kAdobeImageEditorLightingAdjust, /* Lighting */
                kAdobeImageEditorSharpness,      /* Sharpness */
                kAdobeImageEditorDraw,           /* Draw */
                kAdobeImageEditorText,           /* Text */
                kAdobeImageEditorRedeye,         /* Redeye */
                kAdobeImageEditorWhiten,         /* Whiten */
                kAdobeImageEditorBlemish,        /* Blemish */
                kAdobeImageEditorBlur,           /* Blur */
                kAdobeImageEditorMeme,           /* Meme */
                kAdobeImageEditorFrames,         /* Frames */
                kAdobeImageEditorFocus,          /* TiltShift */
                kAdobeImageEditorSplash,         /* ColorSplash */
                kAdobeImageEditorOverlay,        /* Overlay */
                kAdobeImageEditorVignette,       /* Vignette */
                ])
        }
    }
    
    
    func photoEditor(editor: AdobeUXImageEditorViewController, finishedWithImage image: UIImage?) {
        self.myInputImage = (image)!
        
        //撮影編集した写真をiPhoneカメラロールに保存
        UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
        
        //AdobeCreativeSDKモーダル画面閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
        
        //NavigationController経由でViewControllerに戻る
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    func photoEditorCanceled(editor: AdobeUXImageEditorViewController) {
        
        //AdobeCreativeSDKモーダル画面閉じる
        editor.dismissViewControllerAnimated(true, completion: nil)
        
        //NavigationController経由でViewControllerに戻る
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
}