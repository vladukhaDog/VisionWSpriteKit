//
//  CameraView.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation
import SwiftUI

///bridge from UIKit view to SUi View
struct CameraView: UIViewControllerRepresentable {
  
    var pointsProcessorHandler: ((CGPoint) -> Void)?
  func makeUIViewController(context: Context) -> CameraViewController {
    let cvc = CameraViewController()
      cvc.pointsProcessorHandler = pointsProcessorHandler
    return cvc
  }

  
  func updateUIViewController(
    _ uiViewController: CameraViewController,
    context: Context
  ) {
  }
}
