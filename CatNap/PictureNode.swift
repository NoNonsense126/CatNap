//
//  PictureNode.swift
//  CatNap
//
//  Created by Wong You Jing on 25/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import SpriteKit

class PictureNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    func didMoveToScene() {
        userInteractionEnabled = true
        let pictureNode = SKSpriteNode(imageNamed: "picture")
        let maskNode = SKSpriteNode(imageNamed: "picture-frame-mask")
        let cropNode = SKCropNode()
        cropNode.addChild(pictureNode)
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }
    
    func interact() {
        userInteractionEnabled = false
        physicsBody!.dynamic = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        interact()
    }
}
