//
//  SceneKitLayer.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation

import SpriteKit
///Игровая сцена, которая рисует партиклы на экране по нажатию
class GameScene: SKScene {
    ///каким партиклом рисовать
    var particle: Particle?
    ///Партикл был нарисован и пропал с экрана
    var addedParticleCompletionHandler: ((Particle) -> ())?
    
    
    ///начальная настройка сцены
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        physicsBody = SKPhysicsBody()
    }
    
//    //MARK: - обработка нажатий
//    ///нажатие двигается
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        create(touches)
//    }
//    ///нажатие началось
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        create(touches)
//    }
    
    //MARK: - Логика рисовки
    ///рисует партикл на экране на месте первого нажатия
    func create(_ location: CGPoint){
        ///проверяем, что у нас всё есть для дальнейшей работы
        guard let particle else {return }
        ///рисуем столько партиклов за один раз, сколько указано в настройках
        for _ in 0..<particle.maxAmount{
            
            ///Создаем спрайт
            let box = SKSpriteNode(imageNamed: particle.sprite)
            ///ставим ему отображаемый размер
            box.size = particle.size
            
            ///Распределяем точку спавна вокруг точки нажатия
            var loc = location
            loc.y = (scene?.size.height ?? 0) - loc.y
            loc.x += CGFloat(((particle.spreadRange).randomElement() ?? 0) * particle.spreadMultiplier)
            loc.y += CGFloat(((particle.spreadRange).randomElement() ?? 0) * particle.spreadMultiplier)
            box.position = loc
            
            ///Создаем физические свойства
            
            ///Назначаем размер физического тела
            var physSize = box.size
            ///В зависимости от настроек, уменьшаем или увеличиваем размер физического тела по сравнению с отображаемым
            physSize.height = physSize.height * particle.physicsSizeMultiplier
            physSize.width = physSize.width * particle.physicsSizeMultiplier
            box.physicsBody = SKPhysicsBody(rectangleOf: physSize)
            
            ///В зависимости от настроек ставим прыгучесть
            box.physicsBody?.restitution = particle.restitution
            
            box.physicsBody?.isDynamic =  false
            
            ///Если в настройках указано, то делаем задержку, перед тем, как объекту присваиваем физические свойства
            DispatchQueue.main.asyncAfter(deadline: .now() + particle.delayBeforePhysics) {[box] in
                ///В зависимости от настроек, имеет ли партикл физические свойства
                box.physicsBody?.isDynamic = particle.hasPhysics
                
                ///В зависимости от настроек указываем, имеет ли объект коллизию
                if !particle.collidesWithOtherParticles{
                    box.physicsBody?.collisionBitMask = 0
                }
                ///В зависимости от настроек, задаем объекту начальную силу в ту сторону, в которую двигался палец
//                if particle.shouldMoveWithFingerVector{
//                    let prev = touch.previousLocation(in: self)
//                    let moveX = location.x - prev.x
//                    let moveY = location.y - prev.y
//
//                    box.physicsBody?.applyForce(.init(dx: moveX * 5, dy: moveY * 5))
//                }
            }
            
            ///Добавляем объект в сцену
//            DispatchQueue.main.async {[weak self] in
                addChild(box)
//            }
            ///В зависимости от настроек, вызываем пропадание объекта из сцены
            DispatchQueue.main.asyncAfter(deadline: .now() + particle.secondsToDissapear) {[box] in
                box.run(.fadeOut(withDuration: 0.2)) {
                    box.removeFromParent()
                    ///Когда обхект пропал, вызываем completion, что данный партикл был использован
                    (self.addedParticleCompletionHandler ?? {_ in})(particle)
                }
            }
        }
    }
    
    
}
