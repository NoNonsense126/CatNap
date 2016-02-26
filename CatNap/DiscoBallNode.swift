//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by Wong You Jing on 25/02/2016.
//  Copyright © 2016 NoNonsense. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    private var player: AVPlayer!
    private var video: SKVideoNode!
    static private(set) var isDiscoTime = false
    private var isDiscoTime: Bool = false {
        didSet {
            video.hidden = !isDiscoTime
            if isDiscoTime {
                video.play()
                runAction(spinAction)
                video.runAction(SKAction.waitForDuration(5.0), completion: {
                    self.isDiscoTime = false
                })
            } else {
                video.pause()
                removeAllActions()
            }
            DiscoBallNode.isDiscoTime = isDiscoTime
        }
    }
    private let spinAction = SKAction.repeatActionForever(
        SKAction.animateWithTextures([
            SKTexture(imageNamed: "discoball1"),
            SKTexture(imageNamed: "discoball2"),
            SKTexture(imageNamed: "discoball3")
            ], timePerFrame: 0.2)
    )
    
    func didMoveToScene() {
        userInteractionEnabled = true
        
        let fileUrl = NSBundle.mainBundle().URLForResource("discolights-loop", withExtension: "mov")!
        player = AVPlayer(URL: fileUrl)
        video = SKVideoNode(AVPlayer: player)
        video.hidden = true
        video.pause()
        video.size = scene!.size
        video.position = CGPoint(
            x: CGRectGetMidX(scene!.frame),
            y: CGRectGetMidY(scene!.frame)
        )
        video.zPosition = -1
        video.alpha = 0.75
        scene!.addChild(video)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReachEndOfVideo", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    func interact() {
        if !isDiscoTime {
            isDiscoTime = true
            runAction(spinAction)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        interact()
    }
    
    func didReachEndOfVideo() {
        print("rewind!")
        player.currentItem!.seekToTime(kCMTimeZero)
    }
    
}
