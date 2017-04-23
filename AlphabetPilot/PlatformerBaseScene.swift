//
//  GameScene.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlatformerBaseScene: SKScene, SKPhysicsContactDelegate {
    
    var entityManager: PlatformerEntityManager!
    
    var player: Player!
    var worldNode: SKSpriteNode!
    var backgroundNode: SKSpriteNode!
    
    
    private var lastUpdateTime : TimeInterval = 0
 
    
    override func sceneDidLoad() {
        
        
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        super.didMove(to: view)
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: -1.00)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
      
        worldNode = SKSpriteNode()
        worldNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        worldNode.position = .zero
        worldNode.scale(to: view.bounds.size)
        addChild(worldNode)
        
        
        backgroundNode = SKSpriteNode()
        
        let groundTexture = SKTexture(image: #imageLiteral(resourceName: "grassMid"))
        
        let adjustedBottomLeftCorner = CGPoint(x: ScreenPoints.BottomLeftCorner.x, y: ScreenPoints.BottomLeftCorner.y+groundTexture.size().height)
        let adjustedBottomRightCorner = CGPoint(x: ScreenPoints.BottomRightCorner.x, y: ScreenPoints.BottomRightCorner.y+groundTexture.size().height)
        
        worldNode.physicsBody = SKPhysicsBody(edgeFrom: adjustedBottomLeftCorner, to: adjustedBottomRightCorner)
        worldNode.physicsBody?.affectedByGravity = false
        worldNode.physicsBody?.isDynamic = false
        worldNode.physicsBody?.allowsRotation = false
        worldNode.physicsBody?.categoryBitMask = CollisionConfiguration.Barrier.categoryMask
        worldNode.physicsBody?.collisionBitMask = CollisionConfiguration.Barrier.collisionMask
        worldNode.physicsBody?.contactTestBitMask = CollisionConfiguration.Barrier.contactMask
        
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode.position = CGPoint(x: Double(0.00), y: -Double(ScreenSizeConstants.HalfScreenHeight))
        worldNode.addChild(backgroundNode)
    
        
        backgroundNode.scale(to: view.bounds.size)
        let scaledScreenWidth = backgroundNode.frame.size.width
        let halfWidth = scaledScreenWidth/2.0
        let halfHeight = backgroundNode.frame.size.height
        let startPos = -1000 - Int(halfWidth)
        let endPos = 1000 + Int(halfWidth)
        
        for index in startPos...endPos{
            let groundTile = SKSpriteNode(texture: groundTexture)
            groundTile.anchorPoint = CGPoint(x: 0.00, y: 0.00)

            let groundWidth = groundTexture.size().width
            let groundHeight = groundTexture.size().height
            
            let topLeft = CGPoint(x: 0, y: 0)
            let topRight = CGPoint(x: groundWidth, y: 0)
          
            
            
            groundTile.position = CGPoint(x: index, y: Int(halfHeight))
            backgroundNode.addChild(groundTile)
            
        }
        
        /**
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
        **/
        
        entityManager = PlatformerEntityManager(scene: self)
        
        player = Player()
        entityManager.add(player)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
     
    }
    
    func touchMoved(toPoint pos : CGPoint) {
   
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
      
        
        entityManager.update(dt)
        
        self.lastUpdateTime = currentTime
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        guard let playerNode = player.component(ofType: RenderComponent.self)?.node else { return }
        centerOnNode(node: playerNode)
        
    }
    
    
    func centerOnNode(node: SKNode){
        
        guard let world = self.worldNode else { return }
        
        let nodePositionInScene = self.convert(node.position, from: world)
        
        world.position = CGPoint(x: world.position.x - nodePositionInScene.x, y: world.position.y)
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
