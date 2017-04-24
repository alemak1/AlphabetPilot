//
//  AgentComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/24/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class AgentComponent: GKComponent, GKAgentDelegate{
    
    let entityAgent = GKAgent2D()
    var renderNode: SKSpriteNode?
    
    
    convenience init(defaultAgent: GKAgent2D) {
        self.init()
        
        entityAgent.delegate = self
        
    }
    
    
    //Convenience initializer for initializing "chasing/intercepting" agents
    
    convenience init(targetAgent: GKAgent2D, obstacles: [GKObstacle]) {
        
        self.init()
        
        entityAgent.delegate = self
        
        guard let spriteNode = entity?.component(ofType: RenderComponent.self)?.node else {
            print("An agent can only be added to an entity with a render component")
            return
        }
        
        let xPos = Float(spriteNode.position.x)
        let yPos = Float(spriteNode.position.y)
        
        entityAgent.position = vector_float2(xPos, yPos)
        
        let mainGoal = GKGoal(toInterceptAgent: targetAgent, maxPredictionTime: 5.00)
        entityAgent.behavior = GKBehavior(goal: mainGoal, weight: 1.00)
        entityAgent.maxSpeed = 1.00
        
    }
    
    override func didAddToEntity() {
        guard let renderComponentNode = entity?.component(ofType: RenderComponent.self)?.node else {
            print("An agent can only be added to an entity with a render component")
            return
        }
        
        self.renderNode = renderComponentNode
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        guard let renderNode = self.renderNode else {
            print("RenderNode failed to set for current agent component")
            return }
        
        guard let agent = agent as? GKAgent2D else {
            print("The agent must be a GKAgent2D agent")
            return
        }
        let xPos = CGFloat(agent.position.x)
        let yPos = CGFloat(agent.position.y)
        
        renderNode.position = CGPoint(x: xPos, y: yPos)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        entityAgent.update(deltaTime: seconds)
        
    }
}
