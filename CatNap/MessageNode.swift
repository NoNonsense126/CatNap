//
//  MessageNode.swift
//  CatNap
//
//  Created by Wong You Jing on 25/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode, SKPhysicsContactDelegate {
    
    var bounce = 0
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = SKColor.grayColor()
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.whiteColor()
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        physicsBody!.restitution = 0.7
    }
    
    func didBounce(){
        bounce++
        if bounce >= 4{
            removeFromParent()
        }
    }
}
