//
//  BedNode.swift
//  CatNap
//
//  Created by Wong You Jing on 25/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import SpriteKit

protocol CustomNodeEvents {
    func didMoveToScene()
}

class BedNode: SKSpriteNode, CustomNodeEvents {
    func didMoveToScene() {
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOfSize: bedBodySize)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}
