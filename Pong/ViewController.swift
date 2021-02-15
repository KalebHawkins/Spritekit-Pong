//
//  ViewController.swift
//  Pong
//
//  Created by Kaleb Hawkins on 2/10/21.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = view as? SKView {
            if let scene = SKScene(fileNamed: "StartScene") {
                skView.presentScene(scene)
            }
        }
    }
}

