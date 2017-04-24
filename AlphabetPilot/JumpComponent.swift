//
//  JumpComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class JumpComponent: GKComponent{
    
    var canJump: Bool = true
    
    override init() {
        super.init()
        
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector: #selector(JumpComponent.toggleJumpingOn), name: Notification.Name.PlayerStartedBarrierContactNotification, object: nil)
        
        nc.addObserver(self, selector: #selector(JumpComponent.toggleJumpingOff), name: Notification.Name.PlayerStoppedBarrierContactNotification, object: nil)
        
        nc.addObserver(self, selector: #selector(JumpComponent.applyJumpImpulse), name: Notification.Name.DidTouchPlayerNodeNotification, object: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
      
    }
    
    func applyJumpImpulse(){
        
        if(!canJump){
            print("Player cannot jump while not touching the ground")
            return }
        
        print("Applying jump impulse to player...")
        
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else { return }
        
        let impulseVector = CGVector(dx: 0.00, dy: 400.00)
        physicsBody.applyImpulse(impulseVector)
        
        
    }
    
    func toggleJumpingOn(){
        canJump = true
    }
    
    func toggleJumpingOff(){
        canJump = false 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
