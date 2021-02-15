//
//  StartScene.swift
//  Pong
//
//  Created by Kaleb Hawkins on 2/14/21.
//

import SpriteKit

class StartScene: SKScene {
    
    let startLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        startLabel.text = "Start Game"
        startLabel.fontName = "Menlo"
        
        addChild(startLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.reveal(with: .up, duration: 2)
        
        if let gameScene = GameScene(fileNamed: "GameScene") {
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
