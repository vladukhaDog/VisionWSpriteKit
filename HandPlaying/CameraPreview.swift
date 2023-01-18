//
//  CameraPreview.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation
import AVFoundation
import UIKit

///Layer to show camera output
final class CameraPreview: UIView {
  // 2
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }
  
  // 3
  var previewLayer: AVCaptureVideoPreviewLayer {
    layer as! AVCaptureVideoPreviewLayer
  }
}
