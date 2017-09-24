//
//  Scene.swift
//  miniARchive
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
        // NOTE: changed from true
        drawHierarchy(in: bounds, afterScreenUpdates: false)
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

            let myImage:UIImage = sceneView.snapshot! // SEE CUSTOM THING TOP OF FILE!
            //myImage = UIImage(named: "glogo")!

            let imageData:NSData = UIImagePNGRepresentation(myImage)! as NSData
            var imgstr:String = imageData.base64EncodedString()
            // This took me some hours to figure out -- PNGs kept coming up corrupt/blank
            // on backend -- but proper dimensions.  Wasnt sure if was user privacy
            // builtin or using APIs wrong -- but ended up the `+` chars were being
            // interpreted as `SPACE` chars on back -- fixed!
            imgstr = imgstr.replacingOccurrences(of:"+", with:"%2B")
            //print(imgstr)
            
            
            // submit screenshot to back-end service where we can more easily compare
            // it against known pictures of statues and report back the best matched name
            let url = NSURL(string: "https://www-tracey.archive.org/services/ARchive.php")
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.httpBody = ("img=" + imgstr).data(using: String.Encoding.ascii)
            let len = imgstr.lengthOfBytes(using: String.Encoding.utf8)
            print("post screenshot number of bytes: \(len)")
            
            var results = "Statue"
            let urlsession = URLSession.shared
            let task = urlsession.dataTask(with:request as URLRequest, completionHandler: { (data, response, error) in
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                        return
                }
                results = NSString(data:responseData, encoding:String.Encoding.utf8.rawValue)! as String
                print("API Response: \(results)")

                
                // Create a transform with a translation of 0.75 meter in front of the camera
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.75
                let transform = simd_mul(currentFrame.camera.transform, translation)
                
                // Add a new anchor to the session
                let anchor = ARAnchor(transform: transform)
                anchor.accessibilityLabel = results // a little hackety-hack to pass to anchor display
                sceneView.session.add(anchor: anchor)
            })
            task.resume() // send request
        }
    }
}
