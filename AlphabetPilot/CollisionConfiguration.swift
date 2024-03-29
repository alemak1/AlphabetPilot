//
//  CollisionConfiguration.swift
//  AlphabetPilot
//

import Foundation

import Foundation
import GameplayKit
import SpriteKit


struct CollisionConfiguration: Hashable{
    
    var rawValue: UInt32
    
    init(){
        rawValue = 0 << 0
    }
    
    init(rawValue: UInt32){
        self.rawValue = rawValue
    }
    
    
    //MARK: Conformance to Hashable Protocol
    
    var hashValue: Int{
        return Int(rawValue)
    }
    
    //MARK: SKPhysics Properties
    
    var categoryMask: UInt32{
        return rawValue
    }
    
    var collisionMask: UInt32{
        let mask = CollisionConfiguration.definedCollision[self]?.map({$0.rawValue}).reduce(0, { return $0 | $1 })
        
        return mask ?? 0
        
    }
    
    var contactMask: UInt32{
        let mask = CollisionConfiguration.definedContacts[self]?.map({$0.rawValue}).reduce(0, { return $0 | $1})
        
        return mask ?? 0
    }
}


//MARK:     Static Variables: DefinedContacts and DefinedCollisions Dict

extension CollisionConfiguration: OptionSet{
    
    static let NoCategory = CollisionConfiguration()
    static let Player = CollisionConfiguration(rawValue: 1 << 0)
    static let Letter = CollisionConfiguration(rawValue: 1 << 1)
    static let Enemy = CollisionConfiguration(rawValue: 1 << 2)
    static let Barrier = CollisionConfiguration(rawValue: 1 << 3)
    static let Collectible = CollisionConfiguration(rawValue: 1 << 4)
    static let NonCollidingEnemy = CollisionConfiguration(rawValue: 1 << 5)
    static let Portal = CollisionConfiguration(rawValue: 1 << 6)
    
    static let definedCollision: [CollisionConfiguration:[CollisionConfiguration]] = [
        CollisionConfiguration.Player :
            [CollisionConfiguration.Enemy,                                    CollisionConfiguration.Barrier],
        
        CollisionConfiguration.Enemy :
            [CollisionConfiguration.Player, CollisionConfiguration.Barrier],
        CollisionConfiguration.Barrier :
            [CollisionConfiguration.Player, CollisionConfiguration.Enemy, CollisionConfiguration.Letter],
        
        CollisionConfiguration.NonCollidingEnemy : [CollisionConfiguration.NoCategory],
        CollisionConfiguration.Letter : [CollisionConfiguration.Barrier]
    ]
    
    static let definedContacts: [CollisionConfiguration:[CollisionConfiguration]] = [
        CollisionConfiguration.Player :
            [CollisionConfiguration.Portal, CollisionConfiguration.Collectible, CollisionConfiguration.Letter, CollisionConfiguration.Enemy, CollisionConfiguration.NonCollidingEnemy, CollisionConfiguration.Barrier],
        CollisionConfiguration.Barrier : [CollisionConfiguration.Player],
        CollisionConfiguration.NonCollidingEnemy:
            [CollisionConfiguration.Player],
        CollisionConfiguration.Letter : [CollisionConfiguration.Barrier,CollisionConfiguration.Player],
        CollisionConfiguration.Portal :      [CollisionConfiguration.Player]
    ]
    
}
