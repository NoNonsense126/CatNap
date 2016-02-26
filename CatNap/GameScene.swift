//
//  GameScene.swift
//  CatNap
//
//  Created by Wong You Jing on 22/02/2016.
//  Copyright (c) 2016 NoNonsense. All rights reserved.
//

import SpriteKit

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None:    UInt32 = 0 //0
    static let Cat:     UInt32 = 0b1 //1
    static let Block:   UInt32 = 0b10 //2
    static let Bed:     UInt32 = 0b100  //4
    static let Edge:    UInt32 = 0b1000 //8
    static let Label:   UInt32 = 0b10000 //16
    static let Spring:  UInt32 = 0b100000 //32
    static let Hook:    UInt32 = 0b1000000 //64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var currentLevel: Int = 0
    var playable = true
    var bedNode: BedNode!
    var catNode: CatNode!
    var hookNode: HookNode?
    
    override func didMoveToView(view: SKView) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        enumerateChildNodesWithName("//*") { (node, _) -> Void in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        }
        
        bedNode = childNodeWithName("bed") as! BedNode
        catNode = childNodeWithName("//cat_body") as! CatNode

        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
//        let rotationConstraint = SKConstraint.zRotation(
//            SKRange(lowerLimit: -π/4, upperLimit: π/4)
//        )
        
//        catNode.parent!.constraints = [rotationConstraint]
        hookNode = childNodeWithName("hookBase") as? HookNode
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Label | PhysicsCategory.Edge{
            let labelNode = (contact.bodyA.categoryBitMask ==
                PhysicsCategory.Label) ? contact.bodyA.node as! MessageNode: contact.bodyB.node as! MessageNode
            labelNode.didBounce()
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookNode?.isHooked == false {
            hookNode!.hookCat(catNode)
        }
        
        if !playable {
            return
        }
        
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            win()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            lose()
        }
    }
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(
            x: CGRectGetMidX(frame),
            y: CGRectGetMidY(frame)
        )
        addChild(message)
    }
    
    func newGame() {
        let scene = GameScene.level(currentLevel)
        scene!.scaleMode = scaleMode
        view!.presentScene(scene)
    }
    
    func lose() {
        if currentLevel > 1 {
            currentLevel--
        }
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))
        
        inGameMessage("Try again...")
        catNode.wakeUp()
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    func win() {
        if currentLevel < 6 {
            currentLevel++
        }
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
        
        inGameMessage("Nice job!")
        
        catNode.curlAt(bedNode.position)
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    override func didSimulatePhysics() {
        if playable && hookNode?.isHooked != true {
            if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .AspectFill
        return scene
    }
}
