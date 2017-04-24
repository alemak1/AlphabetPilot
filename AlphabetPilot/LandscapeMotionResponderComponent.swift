//
//  LandscapeMotionResponderComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import CoreMotion

class LandscapeMotionResponderComponent: GKComponent{
    
    var motionManager: CMMotionManager!
    
    /** The physicsBody is a computed property, which means that is assumed that (1) the MotionResponder component has already been added to an entity, and (2) the entity to which it has been added already has physics component that can be accessed indirectly via the entity property of the component; this component is tightly coupled to the physics component, and its functionality is added as a component for readability and semantic consistency
     
     
     **/
    var physicsBody: SKPhysicsBody{
        get{
            guard let parentEntity = self.entity, let physicsComponent = parentEntity.component(ofType: PhysicsComponent.self) else {
                fatalError("Error: an entity must have a physics component in order for a motion responder component to be enabled")
            
            }
            
            return physicsComponent.physicsBody
            
            
        }
    }
    
    var appliedForceDeltaX: CGFloat = 0.00
    var appliedForceDeltaY: CGFloat = 0.00
    
    
    init(motionManager: CMMotionManager){
        super.init()
        
        self.motionManager = motionManager
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        
    }
    
    
    func setAppliedForceDeltaY(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let horizontalAttitude = -motionData.attitude.roll
            let horizontalRotationRate = -motionData.rotationRate.y
            
            /**
            if((horizontalAttitude > 0.00 && horizontalRotationRate > 0.00) || (horizontalAttitude < 0.00 && horizontalRotationRate < 0.00)){
                appliedForceDeltaY = CGFloat(horizontalRotationRate)*150.00
            }
            **/
            print(horizontalAttitude)
            appliedForceDeltaY = CGFloat(horizontalAttitude*500)
            print("The appliedForceDeltaY is \(appliedForceDeltaY)")
        }
    }
    
    
    func setAppliedForceDeltaX(){
        
        if motionManager.isDeviceMotionAvailable && motionManager.isGyroAvailable,let motionData = motionManager.deviceMotion{
            let verticalAttitude = -motionData.attitude.pitch
            let verticalRotationRate = -motionData.rotationRate.x
            
            /**
            if((verticalAttitude < 0.00 && verticalRotationRate < 0.00) || (verticalAttitude > 0.00 && verticalRotationRate > 0.00)){
                appliedForceDeltaX = CGFloat(verticalRotationRate)*150.00
            }
            **/
            
            print(verticalAttitude)
            appliedForceDeltaX = CGFloat(verticalAttitude*500)
            print("The appliedForceDeltaX is \(appliedForceDeltaX)")
            
        }
    }
    
    
    
    
    
    
    func applyPhysicsBodyForceFromRotationInput(){
        let appliedImpulseVector = CGVector(dx: appliedForceDeltaX, dy: appliedForceDeltaY)
        physicsBody.applyForce(appliedImpulseVector)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
}


class LandscapeMotionResponderComponentY: LandscapeMotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class LandscapeMotionResponderComponentX: LandscapeMotionResponderComponent{
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        setAppliedForceDeltaX()
        applyPhysicsBodyForceFromRotationInput()
    }
}


class LandscapeMotionResponderComponentXY: LandscapeMotionResponderComponent{
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setAppliedForceDeltaX()
        setAppliedForceDeltaY()
        applyPhysicsBodyForceFromRotationInput()
    }
}
