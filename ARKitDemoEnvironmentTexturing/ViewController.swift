//
//  ViewController.swift
//  ARKitDemoEnvironmentTexturing
//
//  Created by Florian on 03/08/2018.
//  Copyright © 2018 Florian. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.scene = SCNScene()
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        addTapGestureToSceneView()
    }
    
    @objc func addToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        
        // Using automatically detected planes
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        // Using automatically detected feature points
        //let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y + Float.random(in: 0 ..< 0.125)
        let z = translation.z
        
        // Create the sphere node and place in on the scene
        let sphereNode = SCNNode(geometry: SCNSphere(radius: CGFloat( Float.random(in: 0.025 ..< 0.05) )))
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        // Create the reflective material and apply it to the sphere
        let reflectiveMaterial = SCNMaterial()
        reflectiveMaterial.lightingModel = .physicallyBased
        
        reflectiveMaterial.metalness.contents = 1.0
        reflectiveMaterial.roughness.contents = 0
        
        reflectiveMaterial.shininess = 100
        reflectiveMaterial.transparency = 0.85
        
        sphereNode.geometry?.firstMaterial = reflectiveMaterial
        
        sphereNode.position = SCNVector3(x,y,z)
        
        let xm = 0.0
        let ym = CGFloat( Float.random(in: 0.0 ..< 0.05) )
        let zm = 0.0
        
        // 
        let moveOut = SCNAction.moveBy(x: 0, y: ym, z: 0, duration: 1)
        moveOut.timingMode = .easeInEaseOut;
        let moveIn = SCNAction.moveBy(x: 0, y: -ym, z: 0, duration: 1)
        moveIn.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveOut, moveIn])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        sphereNode.runAction(moveLoop)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.environmentTexturing = .automatic
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

