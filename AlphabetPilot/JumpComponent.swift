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
    var jumpToggleQueue = DispatchQueue(label: "jumpToggleQueue")
    
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
        
        
        if physicsBody.velocity.dy == 0{
            let impulseVector = CGVector(dx: 0.00, dy: 500.00)
            physicsBody.applyImpulse(impulseVector)

        }
        
        
    }
    
    func toggleJumpingOn(){
        print("Player can now jump")
        
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else {
            print("Player must have a physics body in order to enable jumping functionality")
            return
        }
        
        
            canJump = true
        
        

        
    }
    
    func toggleJumpingOff(){
        print("Player cannot jump")
        
        guard let physicsBody = entity?.component(ofType: PhysicsComponent.self)?.physicsBody else {
            print("Player must have a physics body in order to enable jumping functionality")
            return
        }
        
        
        canJump = false
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
