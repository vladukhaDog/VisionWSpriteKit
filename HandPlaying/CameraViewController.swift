//
//  CameraViewController.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation
import AVFoundation
import Vision
import UIKit

enum AppError: Error {
  case captureSessionSetup(reason: String)
}


final class CameraViewController: UIViewController {
    
    private var cameraFeedSession: AVCaptureSession?
    
    
    override func loadView() {
        view = CameraPreview()
    }
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    private var cameraView: CameraPreview { view as! CameraPreview }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            // 1
            if cameraFeedSession == nil {
                // 2
                try setupAVSession()
                // 3
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspect
            }
            
            // 4
            DispatchQueue.global(qos: .userInitiated).async {
                self.cameraFeedSession?.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 5
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupAVSession() throws {
      // 1
      guard let videoDevice = AVCaptureDevice.default(
        .builtInWideAngleCamera,
        for: .video,
        position: .front)
      else {
        throw AppError.captureSessionSetup(
          reason: "Could not find a front facing camera."
        )
      }

      // 2
      guard
        let deviceInput = try? AVCaptureDeviceInput(device: videoDevice)
      else {
        throw AppError.captureSessionSetup(
          reason: "Could not create video device input."
        )
      }

      // 3
      let session = AVCaptureSession()
      session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high

      // 4
      guard session.canAddInput(deviceInput) else {
        throw AppError.captureSessionSetup(
          reason: "Could not add video device input to the session"
        )
      }
      session.addInput(deviceInput)

      // 5
      let dataOutput = AVCaptureVideoDataOutput()
      if session.canAddOutput(dataOutput) {
        session.addOutput(dataOutput)
        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
      } else {
        throw AppError.captureSessionSetup(
          reason: "Could not add video data output to the session"
        )
      }
      
      // 6
      session.commitConfiguration()
      cameraFeedSession = session
    }
    
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
      // 1
      let request = VNDetectHumanHandPoseRequest()
      
      // 2
      request.maximumHandCount = 1
      return request
    }()
    
    var pointsProcessorHandler: ((CGPoint) -> Void)?
}


//MARK: AVCaptureOutputDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // 1
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .up,
            options: [:]
        )

        do {
            // 2
            try handler.perform([handPoseRequest])

            // 3
            guard
                let observation = handPoseRequest.results?.first
            else {
                return
            }
            // 1
              let fingers = try observation.recognizedPoints(.all)

              // 2
//              if let thumbTipPoint = fingers[.thumbTip] {
//                recognizedPoints.append(thumbTipPoint)
//              }
              if let indexTipPoint = fingers[.indexTip] {
//                recognizedPoints.append(indexTipPoint)
//                  print(indexTipPoint.confidence)
                  let point = CGPoint(x: indexTipPoint.location.x, y: 1 - indexTipPoint.location.y)
                  
                  DispatchQueue.main.async {
                      self.pointsProcessorHandler?(self.cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: point))
                  }
              }
//              if let middleTipPoint = fingers[.middleTip] {
//                recognizedPoints.append(middleTipPoint)
//              }
//              if let ringTipPoint = fingers[.ringTip] {
//                recognizedPoints.append(ringTipPoint)
//              }
//              if let littleTipPoint = fingers[.littleTip] {
//                recognizedPoints.append(littleTipPoint)
//              }


        } catch {
            // 4
            cameraFeedSession?.stopRunning()
        }
    }
}
