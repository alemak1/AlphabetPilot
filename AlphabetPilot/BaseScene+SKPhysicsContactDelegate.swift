//
//  BaseScene+SKPhysicsContactDelegate.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

//MARK: Conformance to SKPhysicsContactDelegate Method

extension BaseScene{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryBitMaskA: UInt32 = contact.bodyA.categoryBitMask
        let collisionBitMaskA: UInt32 = contact.bodyA.collisionBitMask
        let contactBitMaskA: UInt32 = contact.bodyA.contactTestBitMask
        let nodeNameA: String = contact.bodyA.node?.name ?? "None"
        
        let categoryBitMaskB: UInt32 = contact.bodyB.categoryBitMask
        let collisionBitMaskB: UInt32 = contact.bodyB.collisionBitMask
        let contactBitMaskB: UInt32 = contact.bodyB.contactTestBitMask
        let nodeNameB: String = contact.bodyB.node?.name ?? "None"
        
        let contactInfoDict: [String: Any] = [
            
            ContactInfoKeys.PhysicsBodyACategoryBitmaskKey: categoryBitMaskA,
            ContactInfoKeys.PhysicsBodyACollisionBitmaskKey: collisionBitMaskA,
            ContactInfoKeys.PhysicsBodyAContactBitmaskKey: contactBitMaskA,
            ContactInfoKeys.PhysicsBodyANodeNameKey: nodeNameA,
            ContactInfoKeys.PhysicsBodyBCategoryBitmaskKey: categoryBitMaskB,
            ContactInfoKeys.PhysicsBodyBCollisionBitmaskKey: collisionBitMaskB,
            ContactInfoKeys.PhysicsBodyBContactBitmaskKey: contactBitMaskB,
            ContactInfoKeys.PhysicsBodyBNodeNameKey: nodeNameB
        ]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(Notification(name: Notification.Name.DidMakeContactNotification, object: nil, userInfo: contactInfoDict))
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let categoryBitMaskA: UInt32 = contact.bodyA.categoryBitMask
        let collisionBitMaskA: UInt32 = contact.bodyA.collisionBitMask
        let contactBitMaskA: UInt32 = contact.bodyA.contactTestBitMask
        let nodeNameA: String = contact.bodyA.node?.name ?? "None"
        
        let categoryBitMaskB: UInt32 = contact.bodyB.categoryBitMask
        let collisionBitMaskB: UInt32 = contact.bodyB.collisionBitMask
        let contactBitMaskB: UInt32 = contact.bodyB.contactTestBitMask
        let nodeNameB: String = contact.bodyB.node?.name ?? "None"
        
        let contactInfoDict: [String: Any] = [
            
            ContactInfoKeys.PhysicsBodyACategoryBitmaskKey: categoryBitMaskA,
            ContactInfoKeys.PhysicsBodyACollisionBitmaskKey: collisionBitMaskA,
            ContactInfoKeys.PhysicsBodyAContactBitmaskKey: contactBitMaskA,
            ContactInfoKeys.PhysicsBodyANodeNameKey: nodeNameA,
            ContactInfoKeys.PhysicsBodyBCategoryBitmaskKey: categoryBitMaskB,
            ContactInfoKeys.PhysicsBodyBCollisionBitmaskKey: collisionBitMaskB,
            ContactInfoKeys.PhysicsBodyBContactBitmaskKey: contactBitMaskB,
            ContactInfoKeys.PhysicsBodyBNodeNameKey: nodeNameB
        ]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(Notification(name: Notification.Name.DidEndContactNotification, object: nil, userInfo: contactInfoDict))
    }
    
}
