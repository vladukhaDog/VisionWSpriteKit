//
//  ParticleProtocol.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation
import SwiftUI

///Протокол для объекта, которым можно рисовать на сцене
protocol Particle{
    ///айди объекта
    var id: String {get set}
    ///**String** название картинки из ассетов, которую использовать в качестве текстуры
    var sprite: String {get set}
    ///Сколько объект будет терять энергии после удара об другой объект,
    ///Стандартное значение **0.2**
    var restitution: CGFloat {get set}
    ///Параметр указывающий, имеел ли объект физические свойства
    var hasPhysics: Bool {get set}
    ///Модификатор распределения спавна объекта от точки нажатия
    var spreadMultiplier: Int {get set}
    ///**Range** значений, на сколько сместить спавн объекта от точки нажатия
    ///стандартное значение **-5...4**
    ///Будет выбрано рандомно число из Range и умножено на модификатор распределения **spreadMultiplier**
    var spreadRange: ClosedRange<Int> {get set}
    ///Множитель физического тела в зависимости от отображаемого
    var physicsSizeMultiplier: Double {get set}
    ///Количество партиклов, которые появятся на одно нажатие
    var maxAmount: Int {get set}
    ///Через сколько секунд партикл исчезнет
    var secondsToDissapear: Double {get set}
    ///Задержка в секундах, через сколько партиклу применятся физические свойства
    var delayBeforePhysics: Double {get set}
    ///Есть ли у объекта коллизия
    var collidesWithOtherParticles: Bool {get set}
    ///Размер Партикла
    var size: CGSize {get set}
    ///Задавать ли объекту ускорение в сторону движения пальца
    var shouldMoveWithFingerVector: Bool {get set}
    ///Цвет строки заполнения в статистике
    var barColor: Color {get set}
    ///Сколько процентов в статус добавляет один партикл
    var percentToAddPerParticle: Double {get set}
    ///Сколько процентов в статусе в секунду уходит
    var percentToRemovePerSecond: Double {get set}
}

extension Particle{
    var physicsSizeMultiplier: Double{
        get{
            return 0.7
        }
        set {}
    }
    var shouldMoveWithFingerVector: Bool{
        get{
            return false
        }
        set {}
    }
    var spreadMultiplier: Int{
        get{
            return 5
        }
        set{ }
    }
    var restitution: CGFloat{
        get{
            return 0.2
        }
        set{ }
    }
    var spreadRange: ClosedRange<Int>{
        get{
            return (-5...4)
        }
        set {}
    }
    var maxAmount: Int{
        get{
            return (2...4).randomElement() ?? 2
        }
        set {}
    }
    var collidesWithOtherParticles: Bool{
        get{
            return true
        }
        set {}
    }
}

