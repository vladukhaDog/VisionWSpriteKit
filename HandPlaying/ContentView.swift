//
//  ContentView.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import SwiftUI
import SpriteKit


struct ContentView: View {
    @State private var points: [CGPoint] = []
    var scene: GameScene
    init(){
        self.scene = GameScene()
        self.scene.scaleMode = .aspectFit
        self.scene.particle = WaterParticle()
        
    }
    var body: some View {
        cameraView
        .overlay(
            SpriteView(scene: scene, options: [.allowsTransparency])
                .background(GeometryReader{geo in
                    Color.clear
                        .onAppear{
                            scene.size = geo.size
                        }
                })
        )
        .overlay(ZStack{
            ForEach(points, id: \.y){point in
//                FingerOverlay(with: [point])
                EmptyView()
            }
        })
    }
    
    private var cameraView: some View{
        CameraView(pointsProcessorHandler: { points in
            guard points.allSatisfy({ point in
                return point.x >= 0 && point.y >= 0
            }) else {return}
            for point in points {
                scene.create(point)
            }
            DispatchQueue.main.async {
                
                self.points = points
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct FingerOverlay: Shape {
    let points: [CGPoint]
    private let pointsPath = UIBezierPath()
    
    init(with points: [CGPoint]) {
        self.points = points
    }
    
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point)
            pointsPath.addArc(withCenter: point, radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        
        return Path(pointsPath.cgPath)
    }
}
