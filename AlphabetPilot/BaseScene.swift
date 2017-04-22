//
//  BaseScene.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BaseScene: SKScene, SKPhysicsContactDelegate{
    
    
    //MARK: EntityManager
    var entityManger: EntityManager!
    
    //MARK: Main Player 
    
    var player: Player!
    
    //MARK: Pause Overlay Node (Base Scene contains a  weak reference to the pause overlay node to avoid strong reference cycle, since button overlay node and its parent scene have mutual reference; PauseOverlay Node appears only when the Pause button is pressed
    weak var pauseOverlayNode: PauseOverlayNode?
    
    var worldNode: SKNode!
    
    var backgroundNode: SKNode!
    
    //MARK: *********** MARK 
    
    var lastUpdateTime: TimeInterval = 0.00
    
    //MARK: *********** Initializers
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        worldNode = SKNode()
        addChild(worldNode)
        
        
        backgroundNode = SKNode()
        addChild(backgroundNode)
        
        
        
        let islandTexture = SKTexture(image: #imageLiteral(resourceName: "ground_grass"))
        let islandNode = SKSpriteNode(texture: islandTexture)
        islandNode.position = CGPoint(x: 0.00, y: -ScreenSizeConstants.HalfScreenHeight)
        islandNode.physicsBody = SKPhysicsBody(texture: islandTexture, size: islandTexture.size())
        islandNode.physicsBody?.affectedByGravity = false
        islandNode.physicsBody?.isDynamic = false
        islandNode.physicsBody?.categoryBitMask = CollisionConfiguration.Barrier.categoryMask
        islandNode.physicsBody?.collisionBitMask = CollisionConfiguration.Barrier.collisionMask
        islandNode.physicsBody?.contactTestBitMask = CollisionConfiguration.Barrier.contactMask
        worldNode.addChild(islandNode)
        
        entityManger = EntityManager(scene: self)

        player = Player()
        entityManger.add(player)
        
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
     
        

    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        entityManger.update(dt)

        self.lastUpdateTime = currentTime
    }
}

