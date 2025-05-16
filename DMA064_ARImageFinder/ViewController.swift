//
//  ViewController.swift
//  DMA064_ARImageFinder
//
//  Created by Dana Runge on 5/16/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let imageAnchor as ARImageAnchor: nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor: nodeAdded(node, for: planeAnchor)
        default:
            print("An anchor was discoverd, but it is not for planes or images.")
        }
    }
    
    func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
        let referenceImage = imageAnchor.referenceImage
        var color: UIColor = .red
        switch referenceImage.name {
        case "IMG_5141": color = .green
        case "IMG_5142": color = .yellow
        case "IMG_5143": color = .orange
        case "IMG_5144": color = .blue
        default: print("Detected image: \(referenceImage.name ?? "Unknown")")
        }
        
        let plane = SCNPlane(width: referenceImage.physicalSize.width,
                             height: referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = color
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.50
        planeNode.eulerAngles.x = -Float.pi / 2
        node.addChildNode(planeNode)
        planeNode.runAction(waitRemoveAction)
    }
    
    var waitRemoveAction: SCNAction {
        return .sequence([.wait(duration: 5.0), .fadeOut(duration: 2.0), .removeFromParentNode()])
    }

    func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        // Handle plane detection
    }
    
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
