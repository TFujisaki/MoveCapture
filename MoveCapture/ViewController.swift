//
//  ViewController.swift
//  MoveCapture
//
//  Created by 藤崎 達也 on 2019/12/24.
//  Copyright © 2019年 藤崎 達也. All rights reserved.
//

/*
import UIKit
import AVFoundation
import AssetsLibrary

class ViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 }*/
    
    
import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    let fileOutput = AVCaptureMovieFileOutput()

    var recordButton: UIButton!
    var isRecording = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreview()
    }

    func setUpPreview() {
        
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)

        do {
            if videoDevice == nil || audioDevice == nil {
                throw NSError(domain: "device error", code: -1, userInfo: nil)
            }
        let captureSession = AVCaptureSession()

        // video inputを capture sessionに追加
        let videoInput = try AVCaptureDeviceInput(device: videoDevice!)
        captureSession.addInput(videoInput)

        // audio inputを capture sessionに追加
        let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
        captureSession.addInput(audioInput)

        // max 30sec
        self.fileOutput.maxRecordedDuration = CMTimeMake(value: 30, timescale: 1)
        captureSession.addOutput(fileOutput)

        // プレビュー
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)

        captureSession.startRunning()

        setUpButton()
        } catch {
                // エラー処理
        }
    }

    
    func setUpButton() {
        recordButton = UIButton(frame: CGRect(x: 0,y: 0,width: 120,height: 50))
        recordButton.backgroundColor = UIColor.gray
        recordButton.layer.masksToBounds = true
        recordButton.setTitle("録画開始", for: UIControl.State.normal)
        recordButton.layer.cornerRadius = 20.0
        recordButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        recordButton.addTarget(self, action: #selector(ViewController.onClickRecordButton(sender:)), for: .touchUpInside)

        self.view.addSubview(recordButton)
    } 

    @objc func onClickRecordButton(sender: UIButton) {
        if !isRecording {
            // 録画開始
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String? = "\(documentsDirectory)/temp.mp4"
            let fileURL : NSURL = NSURL(fileURLWithPath: filePath!)
            fileOutput.startRecording(to: fileURL as URL, recordingDelegate: self)

            isRecording = true
            changeButtonColor(target: recordButton, color: UIColor.red)
            recordButton.setTitle("録画中", for: .normal)
        } else {
            // 録画終了
            fileOutput.stopRecording()

            isRecording = false
            changeButtonColor(target: recordButton, color: UIColor.gray)
            recordButton.setTitle("録画開始", for: .normal)
        }
    }

    func changeButtonColor(target: UIButton, color: UIColor) {
        target.backgroundColor = color
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // ライブラリへ保存
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { completed, error in
            if completed {
                print("Video is saved!")
            }
        }
    }
    
}


