//
//  GameScene.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/21/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
   
    
    private var lastUpdateTime : TimeInterval = 0
 
    
    override func sceneDidLoad() {
        
        
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
      
        
        self.lastUpdateTime = currentTime
    }
}
