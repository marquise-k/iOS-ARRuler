//
//  ViewController.swift
//  ARRuler
//
//  Created by Marquise Kamanke on 2020-02-03.
//  Copyright © 2020 Marquise Kamanke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // This is to figure out which parts of the scene are a continuous surface
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearDots()
        if let touch = touches.first { // touches.first captures the most recent touch
            let touchLocation = touch.location(in: sceneView)
            // convert touch location to 3d position corresponding to one of our AR plane anchors
            let results = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = results.first{
                addDot(at: hitResult)
                    }
                }
            }
        
    
    func clearDots(){
        if dotNodes.count >= 2 {
                  for dot in dotNodes {
                      dot.removeFromParentNode()
                  }
                  dotNodes = [SCNNode]()
              }
    }
    
    
    func addDot(at hitresult: ARHitTestResult) {
        let dot = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        
        let dotNode = SCNNode(geometry: dot)
        dotNode.position = SCNVector3(
        x: hitresult.worldTransform.columns.3.x,
        y: hitresult.worldTransform.columns.3.y,
        z: hitresult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
      
        updateText(text: "\(abs(distance))", atPosition: end.position)
    }
    
    func updateText(text distance: String, atPosition endPosition: SCNVector3){
        clearText()
        let textGeometry = SCNText(string: distance, extrusionDepth:1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(endPosition.x, endPosition.y + 0.1, endPosition.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }


    func clearText(){
    textNode.removeFromParentNode()
    }


}
