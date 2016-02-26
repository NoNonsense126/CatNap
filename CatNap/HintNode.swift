//
//  HintNode.swift
//  CatNap
//
//  Created by Wong You Jing on 25/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import SpriteKit

class HintNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    
    var arrowPath: CGPath {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0.5, y: 65.69))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 1.5))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 38.66))
        bezierPath.addLineToPoint(CGPoint(x: 257.5, y: 38.66))
        bezierPath.addLineToPoint(CGPoint(x: 257.5, y: 92.72))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 92.72))
        bezierPath.addLineToPoint(CGPoint(x: 74.99, y: 126.5))
        bezierPath.addLineToPoint(CGPoint(x: 0.5, y: 65.69))
        bezierPath.closePath()
        return bezierPath.CGPath
    }
    
    func didMoveToScene() {
        userInteractionEnabled = true
        color = SKColor.clearColor()
        
        let shape = SKShapeNode(path: arrowPath)
        shape.strokeColor = SKColor.grayColor()
        shape.lineWidth = 4
        shape.glowWidth = 5
        shape.fillColor = SKColor.whiteColor()
        shape.fillTexture = SKTexture(imageNamed: "wood_tinted")
        shape.name = "hintArrow"
        shape.alpha = 0.8
        addChild(shape)
            
        let move = SKAction.moveByX(-40, y: 0, duration: 1.0)
        let bounce = SKAction.sequence([
            move, move.reversedAction()
        ])
        let bounceAction = SKAction.repeatAction(bounce, count: 3)
        shape.runAction(bounceAction, completion: {
            self.removeFromParent()
        })
    }
    
    func interact() {
        let randomColorArray = [SKColor.redColor(), SKColor.yellowColor(), SKColor.orangeColor()]
        let randomIndex = Int(arc4random_uniform(UInt32(randomColorArray.count)))
        if let shape = childNodeWithName("hintArrow") as? SKShapeNode {
            shape.fillColor = randomColorArray[randomIndex]
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        interact()
    }
}
