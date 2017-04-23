//
//  InProgressWord.swift
//  AlphabetPilot
//
//  Created by Aleksander Makedonski on 4/23/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit



class InProgressWord: GKEntity{
    
    var targetWord: String = String()
    var inProgressWord: String = String()
    
    override init() {
        super.init()
    }
    
    convenience init(targetWord: String) {
        self.init()
        self.targetWord = targetWord
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
