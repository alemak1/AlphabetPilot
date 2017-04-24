//
//  PlatformerEntityManager.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class PlatformerEntityManager{
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    
    lazy var componentSystems: [GKComponentSystem] = {
        
        
        let renderComponent = GKComponentSystem(componentClass: RenderComponent.self)
        
        let nodeNameComponent = GKComponentSystem(componentClass: NodeNameComponent.self)
        
        let physicsComponent = GKComponentSystem(componentClass: PhysicsComponent.self)
        
        let motionResponderComponentX = GKComponentSystem(componentClass: LandscapeMotionResponderComponentX.self)
        
        let orientationComponent = GKComponentSystem(componentClass: OrientationComponent.self)
        
        let animationComponent = GKComponentSystem(componentClass: AnimationComponent.self)
        
        
        let jumpComponent = GKComponentSystem(componentClass: JumpComponent.self)
        
        
        return [renderComponent, nodeNameComponent, physicsComponent, motionResponderComponentX, orientationComponent, animationComponent, jumpComponent]
    
    }()
    
    let scene: PlatformerBaseScene
    
    init(scene: PlatformerBaseScene){
        self.scene = scene
    }
    
    
    func update(_ deltaTime: CFTimeInterval){
        for componentSystem in componentSystems{
            componentSystem.update(deltaTime: deltaTime)
        }
        
      
        for currentRemove in toRemove{
            for componentSystem in componentSystems{
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        
        
        toRemove.removeAll()
    }
    
    func addToWorld(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.move(toParent: scene.worldNode)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    
    func addToScene(_ entity: GKEntity){
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.move(toParent: scene)
        }
        
        for componentSystem in componentSystems{
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    
    func remove(_ entity: GKEntity){
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node{
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func getPlayerEntities() -> [Player]{
        return self.entities.flatMap{entity in
            
            if let entity = entity as? Player{
                return entity
            }
            
            return nil
        }
    }
    
    
}
