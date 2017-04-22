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
    
    var node = SKSpriteNode()
    
    //MARK: GKComponent Base-Class Methods 
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil 
    }
}
