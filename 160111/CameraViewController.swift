//
//  CameraViewController.swift
//  160111
//
//  Created by 20150301 on 2/11/16.
//  Copyright © 2016 ******. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    
    //設定保存
    let CameraData = NSUserDefaults.standardUserDefaults()
    
    var input:AVCaptureDeviceInput!
    var output:AVCaptureStillImageOutput!
    var session:AVCaptureSession!
    var preView:UIView!
    var camera:AVCaptureDevice!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションのデリゲート設定
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        
        //画面タップでシャッターを切るための設定
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        //デリゲートをセット
        tapGesture.delegate = self;
        //Viewに追加
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    //メモリ管理のため
    override func viewWillAppear(animated: Bool) {
        
        //NavigationBar透明
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        //スクリーン設定
        setupDisplay()
        //カメラの設定
        setupCamera()
    }
    
    //メモリ管理のため
    override func viewDidDisappear(animated: Bool) {
        //camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            session.removeOutput(output as? AVCaptureOutput)
        }
        
        for input in session.inputs {
            session.removeInput(input as? AVCaptureInput)
        }
            session = nil
            camera = nil
    }
    
    
        func setupDisplay(){
            //スクリーンの幅
            let screenWidth = UIScreen.mainScreen().bounds.size.width;
            //スクリーンの高さ
            let screenHeight = UIScreen.mainScreen().bounds.size.height;
            
            //プレビュー用のビューを生成
            preView = UIView(frame:CGRectMake(0.0, 0.0, screenWidth, screenHeight))
        }
    
    
        func setupCamera(){
            
            //セッション
            session = AVCaptureSession()
            
            for caputureDevice: AnyObject in AVCaptureDevice.devices() {
                //背面カメラを取得
                if caputureDevice.position == AVCaptureDevicePosition.Back {
                    camera = caputureDevice as? AVCaptureDevice
                }
                
                //前面カメラ取得
                //if caputureDevice.position == AVCaptureDevicePosition.Front {
                //    camera = caputureDevice as? AVCaptureDevice
                // }
            }
            
            
            //カメラからの入力データ
            do {
                input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
            } catch let error as NSError {
                print(error)
            }
            
            //入力をセッションに追加
            if(session.canAddInput(input)) {
                session.addInput(input)
            }
            
            //静止画出力のインスタンス生成
            output = AVCaptureStillImageOutput()
            //出力をセッションに追加
            if(session.canAddOutput(output)) {
                session.addOutput(output)
            }
            
            //セッションからプレビュー表示を
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = preView.frame
            
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            //レイヤーをViewに設定
            //これを外すとプレビューが無くなる、けれど撮影はできる
            self.view.layer.addSublayer(previewLayer)
            session.startRunning()
        }
    
        
        //タップイベント
        func tapped(sender: UITapGestureRecognizer) {
            print("Tap")
            takeStillPicture()
        }
    
    
        func takeStillPicture() {
            
            //ビデオ出力に接続
            if let connection:AVCaptureConnection? = output.connectionWithMediaType(AVMediaTypeVideo){
                //ビデオ出力から画像と非同期で取得
                output.captureStillImageAsynchronouslyFromConnection(connection,completionHandler: { (imageDataBuffer,error) -> Void in
            
                    
                    // 取得したImageのDataBufferをJpegに変換 
                    let myImageData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                    
                    //UIImage作成
                    var myImage:UIImage = UIImage(data:myImageData)!
                    
                    //写真固定（撮影した写真が90度左に回転してしまうのを阻止）
                    UIGraphicsBeginImageContextWithOptions(myImage.size, true, 0)
                    myImage.drawInRect(CGRectMake(0, 0, myImage.size.width, myImage.size.height))
                    myImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    
                    //画像保存
                    let imageData = UIImagePNGRepresentation(myImage)
                    self.CameraData.setObject(imageData, forKey: "Photo")
                    
                    //EditPhotoViewControllerへ
                    self.performSegueWithIdentifier("goEdit", sender: nil)
                })
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
}
