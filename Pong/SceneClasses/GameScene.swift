//
//  GameScene.swift
//  Pong
//
//  Created by Kaleb Hawkins on 2/10/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var enemyPaddle  = SKSpriteNode()
    var playerPaddle = SKSpriteNode()
    var ball         = SKSpriteNode()
    var playerScoreLabel = SKLabelNode()
    var enemyScoreLabel = SKLabelNode()
    var particles = SKEmitterNode()

    let maxSpeed: CGFloat = 400
    let direction = 1
    var scoreBoard = [0, 0]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.friction = 0
        physicsBody!.restitution = 1
        
        enemyPaddle = childNode(withName: "enemy") as! SKSpriteNode
        playerPaddle = childNode(withName: "player") as! SKSpriteNode
        ball = childNode(withName: "ball") as! SKSpriteNode
        
        playerPaddle.position = CGPoint(x: 0, y: size.width * -0.70)
        enemyPaddle.position = CGPoint(x: 0, y: size.width * 0.70)
        
        playerScoreLabel.fontName = "Menlo"
        enemyScoreLabel.fontName = "Menlo"
        playerScoreLabel.text = String(scoreBoard[0])
        enemyScoreLabel.text = String(scoreBoard[1])
        
        playerScoreLabel.position = CGPoint(x: playerPaddle.position.x, y: playerPaddle.position.y * 0.80)
        enemyScoreLabel.position = CGPoint(x: playerPaddle.position.x, y: playerPaddle.position.y * -0.80)
        addChild(playerScoreLabel)
        addChild(enemyScoreLabel)
        
        particles = SKEmitterNode(fileNamed: "Particles.sks")!
        particles.targetNode = self
        addChild(particles)
        
        kickOff()
        regulateBallVelocity()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
            // Have the enemy paddle follow the ball
            enemyPaddle.run(.moveTo(x: ball.position.x, duration: 0.13))
            particles.position = ball.position
            
            if(isRoundOver()){
                updateScore()
                kickOff()
            }
            
            regulateBallVelocity()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // Move the player paddle with the users touches
            playerPaddle.run(.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    func kickOff(){
        ball.position = .zero
        ball.physicsBody?.velocity = .zero
        ball.physicsBody!.applyImpulse(CGVector(dx: [-maxSpeed, maxSpeed].randomElement()!, dy: [-maxSpeed, maxSpeed].randomElement()!))
    }
    
    func regulateBallVelocity() {
        if ball.physicsBody!.velocity.dx > maxSpeed {
            ball.physicsBody?.velocity.dx = maxSpeed
        } else if ball.physicsBody!.velocity.dx < -maxSpeed {
            ball.physicsBody?.velocity.dx = -maxSpeed
        }

        if ball.physicsBody!.velocity.dy > maxSpeed {
            ball.physicsBody?.velocity.dy = maxSpeed
        } else if ball.physicsBody!.velocity.dy < -maxSpeed {
            ball.physicsBody?.velocity.dy = -maxSpeed
        }
        
        // Regulate angle of the ball. If either the x || y velocity goes within the range of -50-50 it will be increased to 100. This prevents the ball from getting stuck going side to side or straight up and down.
        let minSpeedRange = -50...40
        let correctiveSpeed: CGFloat = 100
        
        if(minSpeedRange.contains(Int(ball.physicsBody!.velocity.dy)) && ball.physicsBody!.velocity.dy >= 0) {
            ball.physicsBody?.velocity.dy = correctiveSpeed
        }
        if(minSpeedRange.contains(Int(ball.physicsBody!.velocity.dy)) && ball.physicsBody!.velocity.dy <= 0) {
            ball.physicsBody?.velocity.dy = -correctiveSpeed
        }
        
        if(minSpeedRange.contains(Int(ball.physicsBody!.velocity.dx)) && ball.physicsBody!.velocity.dx >= 0) {
            ball.physicsBody?.velocity.dx = correctiveSpeed
        }
        if(minSpeedRange.contains(Int(ball.physicsBody!.velocity.dx)) && ball.physicsBody!.velocity.dx <= 0) {
            ball.physicsBody?.velocity.dx = -correctiveSpeed
        }
    }
    
    func isRoundOver() -> Bool {
        if ball.position.y >= enemyPaddle.position.y + 30 || ball.position.y < playerPaddle.position.y - 30 {
            return true
        } else {
            return false
        }
    }
    
    func updateScore(){
        if ball.position.y <= playerPaddle.position.y - 30 {
            // Increase enemy score if ball passes the player.
            scoreBoard[1] += 1
        }
        if ball.position.y >= enemyPaddle.position.y + 30 {
            // Increase player score if ball passes the enemy.
            scoreBoard[0] += 1
        }
        
        playerScoreLabel.text = String(scoreBoard[0])
        enemyScoreLabel.text = String(scoreBoard[1])
    }
}
