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
        request.maximumHandCount = 2
        return request
    }()
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
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
            var allPoints: [CGPoint] = []
            try handler.perform([handPoseRequest])
            
            
            for observation in (handPoseRequest.results ?? []){
                //                guard
                //                let observation = handPoseRequest.results?.first
                //            else {
                //                return
                //            }
                
                let fingers = try observation.recognizedPoints(.all)
                
                let jointsToFindCenter: [VNHumanHandPoseObservation.JointName] = [
                    .thumbTip,
//                    .thumbCMC,
                    .wrist,
                    .indexTip,
//                    .middleTip,
//                    .ringTip,
                    .littleTip
                ]
                var pointsToFindCenterOf: [CGPoint] = []
                
                for joint in jointsToFindCenter{
                    if let point = fingers[joint], point.confidence > 0.8{
                        pointsToFindCenterOf.append(CGPoint(x: point.location.x, y: 1 - point.location.y))
                    }
                }
                let sum = pointsToFindCenterOf.reduce(CGPoint(x: 0, y: 0), { partialResult, point in
                    var p = partialResult
                    p.x += point.x
                    p.y += point.y
                    return p
                })
                let middlePoint = CGPoint(x: sum.x / Double(pointsToFindCenterOf.count),
                                          y: sum.y / Double(pointsToFindCenterOf.count))
                allPoints.append(middlePoint)
//                if let first = fingers[.wrist], first.confidence >= 0.80,
//                   let second = fingers[.middleTip], second.confidence >= 0.8
//                {
//
//                    let Middle = CGPoint(x: (wrist.location.x + middleBase.location.x)/2,
//                                         y: (wrist.location.y + middleBase.location.y)/2)
//                    let point = CGPoint(x: Middle.x, y: 1 - Middle.y)
//                    allPoints.append(point)
//
//                }
            }
            
            DispatchQueue.main.async {
                let proccessed = allPoints.map { point in
                    return self.cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
                }
                self.pointsProcessorHandler?(proccessed)
            }
        } catch {
            // 4
            cameraFeedSession?.stopRunning()
        }
    }
}
