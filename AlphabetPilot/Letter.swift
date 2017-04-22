//
//  Letter.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Letter: GKEntity{
    
    
    override init() {
        super.init()
    }
    
    convenience init(letterCategory: LetterNode.LetterCategory, letterMass: CGFloat = 1.00) {
        self.init()

        let renderComponent = RenderComponent()
        
        let startXPos = RandomGenerator.getRandomXPos(adjustmentFactor: 0.95)
        let startYPos = Int(ScreenSizeConstants.HalfScreenHeight) + 100
        let startPos = CGPoint(x: startXPos, y: startYPos)
        
        let letterNode = LetterNode(letter: letterCategory, position: startPos, scalingFactor: 0.60)
        
        renderComponent.node = letterNode
        addComponent(renderComponent)
        
        let letterTexture = letterCategory.texture
        let letterTextureSize  = letterTexture.size()
        
        let physicsBody = letterNode.physicsBody ?? SKPhysicsBody(texture: letterTexture, size: letterTextureSize)
        physicsBody.mass = letterMass
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, collisionConfiguration: CollisionConfiguration.Letter)
        addComponent(physicsComponent)
        
        
        let contactHandlerComponent = ContactHandlerComponent(categoryContactHandler: {
        
            otherCategoryBitmask in
            
            let spriteNode = renderComponent.node
            
            switch(otherCategoryBitmask){
                case CollisionConfiguration.Barrier.categoryMask:
                    print("Letter \(letterCategory.stringLetter) hit the barrier")
                    spriteNode.removeFromParent()
                    break
                case CollisionConfiguration.Player.categoryMask:
                    print("Letter \(letterCategory.stringLetter) hit the player")
                    spriteNode.removeFromParent()
                    break
                default:
                    print("No contact logic implemented")
            }
        }, nodeContactHandler: nil, categoryEndContactHandler: nil, nodeEndContactHandler: nil)
        
        addComponent(contactHandlerComponent)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: The agent used when pathfinding to a target tile at a certain ground location
    
   // let agent: GKAgent2D
    
    //MARK: Helper Method: Post a notificaiton
}

