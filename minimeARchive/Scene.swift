//
//  Scene.swift
//  minime ARchive
//
//  Created by tracey on 9/23/17.
//  Copyright © 2017 tracey. All rights reserved.
//

import SpriteKit
import ARKit
import UIKit

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class Scene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            
            //let myImage = sceneView.session.currentFrame?.capturedImage  //xxxx
            let myImage = sceneView.snapshot
            //let myImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!

            let imageData:NSData = UIImagePNGRepresentation(myImage!)! as NSData
            let imgstr = imageData.base64EncodedString( options: .lineLength64Characters)
            // print(imgstr)
            

            
            // Create a transform with a translation of 0.5 meter in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            
          
            
            let url = NSURL(string: "https://www-tracey.archive.org/services/ARchive.php")
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"

            request.httpBody = ("img=" + imgstr).data(using: String.Encoding.ascii)
            //request.httpBody = ("img=" + imgstr).data(using: String.Encoding.utf8)
            //request.httpBody = "img=" + imgstr as NSData //dataUsingEncoding(NSUTF8StringEncoding)
            //request.httpBody = imageData as Data
            print("LENGTH")
            print(imgstr.lengthOfBytes(using: String.Encoding.utf8))
                
            var response: URLResponse? = nil
            do {
                let reply = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
                let results = NSString(data:reply, encoding:String.Encoding.utf8.rawValue)
                print("API Response: \(results ?? "prollyerror")")
            } catch _ {
                print("POST ERROR")
                return
            }
        }
    }
  
}
