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
    var entityManager: EntityManager!
    
    
    //MARK: LetterArray and Related Spawning Variables; each letter entity in the letter array has an associated boolean flag that is set to true if the letter has already been spawned; letters that have already been spawned will be repositioned above the screen in the implementation of the contact logic
    
    typealias LetterTuple = (Letter,Bool)
    
    var letterEntityArray: [LetterTuple] = [
        (Letter(letterCategory: .letterA), false),
        (Letter(letterCategory: .letterB), false),
        (Letter(letterCategory: .letterC), false),
        (Letter(letterCategory: .letterD), false),
        (Letter(letterCategory: .letterE), false),
        (Letter(letterCategory: .letterF), false),
        (Letter(letterCategory: .letterG), false),
        (Letter(letterCategory: .letterH), false),
        (Letter(letterCategory: .letterI), false),
        (Letter(letterCategory: .letterJ), false),
        (Letter(letterCategory: .letterK), false),
        (Letter(letterCategory: .letterL), false),
        (Letter(letterCategory: .letterM), false),
        (Letter(letterCategory: .letterN), false),
        (Letter(letterCategory: .letterO), false),
        (Letter(letterCategory: .letterP), false),
        (Letter(letterCategory: .letterQ), false),
        (Letter(letterCategory: .letterR), false),
        (Letter(letterCategory: .letterS), false),
        (Letter(letterCategory: .letterT), false),
        (Letter(letterCategory: .letterU), false),
        (Letter(letterCategory: .letterV), false),
        (Letter(letterCategory: .letterW), false),
        (Letter(letterCategory: .letterX), false),
        (Letter(letterCategory: .letterY), false),
        (Letter(letterCategory: .letterZ), false),

    ]
    
    var randomLetterIndex: Int{
        let randSrc = GKMersenneTwisterRandomSource()
        let randDst = GKRandomDistribution(randomSource: randSrc, lowestValue: 0, highestValue: letterEntityArray.count-1)
        return randDst.nextInt()
    }
    
    var allLettersSpawned: Bool = false
    
    private func allLetterSpawned() -> Bool{
        return letterEntityArray.map({ return $0.1 }).reduce(true){ return $0 && $1 }
    }
    
    let customQueue = OperationQueue()
    
    var letterSpawnInterval: TimeInterval = 2.00
    var letterSpawnFrameCount: TimeInterval = 0.00
    
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
        self.physicsWorld.gravity = CGVector(dx: 0.00, dy: -1.00)
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
        
        entityManager = EntityManager(scene: self)

        player = Player()
        entityManager.add(player)
        
    
        
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        let nodesTouched = nodes(at: touchLocation)
            
        for node in nodesTouched{
            if node.name == "PlayerNode"{
                print("Touched the player")
                
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name.DidTouchPlayerNodeNotification, object: nil, userInfo: nil)
            }
        }
        
        if worldNode.contains(touchLocation){
            print("WorldNode was touched")
            if let playerNode = player.component(ofType: RenderComponent.self)?.node, playerNode.contains(touchLocation){
            
                print("Touched the player")
            
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name.DidTouchPlayerNodeNotification, object: nil, userInfo: nil)
            
            }
        
     
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        letterSpawnFrameCount += dt
        
        if(letterSpawnFrameCount > letterSpawnInterval){
            
            
            //Consider how to dispatch this code to an synchronous queue
            
            
            customQueue.addOperation {
                
               if(self.allLettersSpawned) { return }
                
                var isNewLetter: Bool
                
                repeat{
                    
                    isNewLetter = true
                    
                    let newRandomLetterIndex = self.randomLetterIndex
                    var randomLetterTuple = self.letterEntityArray[newRandomLetterIndex]
                    
                    if(!randomLetterTuple.1){
                        DispatchQueue.main.sync {
                            let randomLetter = randomLetterTuple.0
                            self.entityManager.add(randomLetter)
                            self.setLetterStatusToFalse(letterTuple: &self.letterEntityArray[newRandomLetterIndex])
                        }
                       
                    } else {
                        isNewLetter = false
                    }
                }while(!isNewLetter)
            
            }
        
            if(allLetterSpawned()){
                allLettersSpawned = true
            }
            letterSpawnFrameCount = 0
            
        }
 
        entityManager.update(dt)

        self.lastUpdateTime = currentTime
    }
    
    
    
}

extension BaseScene{
    
    
    //Function should be dispatched asynchronously to a concurrent queue to prevent blocing of the main thread since the function will take longer as the number of letter available for spawning decreases
    func spawnRandomLetterFromPreloadedArray(){
        
            var isNewLetter: Bool
            
            repeat{
                
                isNewLetter = true
                
                var newRandomLetterIndex = randomLetterIndex
                var randomLetterTuple = letterEntityArray[newRandomLetterIndex]
                
                if(!randomLetterTuple.1){
                    let randomLetter = randomLetterTuple.0
                    entityManager.add(randomLetter)
                    setLetterStatusToFalse(letterTuple: &letterEntityArray[newRandomLetterIndex])
                } else {
                    isNewLetter = false
                }
            }while(!isNewLetter)
        }
    
    //Tuple are value-types, so the truth-value of the boolean flag can be modified by passing the tuple into a function by reference; using a mutating method in a struct can also serve the same purpose
    func setLetterStatusToFalse(letterTuple: inout LetterTuple){
            letterTuple.1 = true
    }
}



