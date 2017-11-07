//
//  ScannerViewController.swift
//  SuperApi
//
//  Created by George Davies on 07/11/2017.
//  Copyright © 2017 George. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var barcodeFrameView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            // Initialize QR Code Frame to highlight the QR code
            barcodeFrameView = UIView()
            
            if let barcodeFrameView = barcodeFrameView {
                barcodeFrameView.layer.borderColor = UIColor.green.cgColor
                barcodeFrameView.layer.borderWidth = 2
                view.addSubview(barcodeFrameView)
                view.bringSubview(toFront: barcodeFrameView)
            }
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.ean13 {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            barcodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                DataService.shared.searchAPI(gtin: metadataObj.stringValue!)
                print(metadataObj.stringValue)
            }
        }
    }
}
