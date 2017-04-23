//
//  RenderComponent.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/22/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class RenderComponent: GKComponent{
    
    //MARK: Properties 
    
    var node: SKSpriteNode?
    var autoRepositioningEnabled: Bool = false
    var autoRemoveEnabled: Bool = false
    
    var autoRemoveFrameCount: TimeInterval = 0.00
    var autoRemoveInterval: TimeInterval = 8.00
    
    var autoRepositionFrameCount: TimeInterval = 0.00
    var autoRepositionInterval: TimeInterval = 5.00
    
    var position: CGPoint = .zero
    
    override init() {
        super.init()
    }
    
    
    convenience init(position: CGPoint, autoRemoveEnabled: Bool = false) {
        self.init()
        self.position = position
        self.autoRemoveEnabled = autoRemoveEnabled
    }
    
    
    convenience init(position: CGPoint, autoRepositioningEnabled: Bool = false) {
        self.init()
        self.position = position
        self.autoRepositioningEnabled = autoRepositioningEnabled

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: GKComponent Base-Class Methods 
    
    override func didAddToEntity() {
        node = SKSpriteNode()
        
        if let node = self.node{
            node.entity = entity
            node.position = position
        }
        
    }
    
    override func willRemoveFromEntity() {
        if let node = self.node{
            node.entity = nil
        }
        node = nil
    }
    
    /** If the node is contacted by the player while it is fading away, then the completion handler should only run the removeFromParentAction() if the node is not nil
 
    **/
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        if autoRemoveEnabled{
            
            autoRemoveFrameCount += seconds
            
            if(autoRemoveFrameCount > autoRepositionInterval){
            
                node?.run(SKAction.fadeOut(withDuration: 3.00), completion: {
    
                    self.node?.removeFromParent()
                })
                
                autoRemoveFrameCount = 0
            }
        }
        
        if autoRepositioningEnabled {
            
            autoRepositionFrameCount += seconds
            
            if(autoRepositionFrameCount > autoRepositionInterval){
                
                DispatchQueue.global(qos: .background).async {
                    
                    self.node?.run(SKAction.fadeOut(withDuration: 3.00))
                    self.repositionNodeAboveScreen()
                    
                    DispatchQueue.main.sync {
                        self.node?.alpha = 1.00
                    }
                    
                }
                
                autoRepositionFrameCount = 0
            }
        
        
        }
        
        
       
        
    }
    
  
    
    func repositionNodeAboveScreen(){
        
        let xPos = RandomGenerator.getRandomXPos(adjustmentFactor: 0.95)
        let yPos = Int(ScreenSizeConstants.HalfScreenHeight) + 100
        node?.position = CGPoint(x: xPos, y: yPos)
    }
}
