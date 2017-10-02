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
import CoreImage

import CocoaImageHashing
//import WTF

// returns UIIimage from current ARFrame
extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        // NOTE: changed from true
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// Image Scaling
extension UIImage {
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        if (size.width == newSize.width  &&  size.height == newSize.height) {
            print("RETURN ASIS")
            return self
        }

        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}



class Scene: SKScene {
    var compareWidth:Int = 189
    var compareHeight:Int = 252
    // ls|perl -pe 's/\.png$//'|quotem|tr "'" '"' ..
    let phashes: [String: OSHashDistanceType] = [
        "AaronBinns": -7008665226162146816,
        "AaronSwartz": -111397507828879360,
        "AaronXimm": -5891631873931578880,
        "AlexisRossi": 7979987795101284352,
        "BradTofel": 1062348146014482944,
        "BrewsterKahle": -8782308880383281152,
        "BrewsterKahle2": -8783080728922490880,
        "GabeJuszel": -3684302162399397376,
        "GordonMohr": -1288957358449594368,
        "HankBromley": -1801808468412403200,
        "IMG_2844": 3224214761400105472,
        "IMG_2846": -3675334508888040960,
        "IMG_2847": -4846226457074443776,
        "IMG_2859": -795238557894653440,
        "IMG_2860": -1378604380667880960,
        "IMG_2861": -1434754274839569920,
        "IMG_2862": 7277428553319995904,
        "IMG_2863": -1246165913829615104,
        "IMG_2864": -1243362113989977600,
        "IMG_2865": -5999150134767060480,
        "IMG_2866": -4702113435776124416,
        "IMG_2867": -4704365233408411648,
        "IMG_2868": -5315163922733795328,
        "IMG_2869": -8143572425113014272,
        "IMG_2870": -4846241815843899392,
        "IMG_2871": -8343271707313770496,
        "IMG_2872": -4882826991525234688,
        "IMG_2873": -8161439308130881536,
        "IMG_2874": 4537409747883454464,
        "IMG_2875": -4723081148333622784,
        "IMG_2876": -7585153989141661696,
        "IMG_2877": -8161438878634280960,
        "IMG_2879": -4287782390853863424,
        "IMG_2880": 503473645707917312,
        "IMG_2881": 2196824476286988288,
        "IMG_2882": 1061932573566758912,
        "IMG_2883": -4747710902319517696,
        "IMG_2884": -5858976309330284032,
        "IMG_2885": -7008665215932239360,
        "IMG_2886": -1964065864366362624,
        "IMG_2887": 917815152110006272,
        "IMG_2888": -5891800436366446592,
        "IMG_2889": -3594369361387556864,
        "IMG_2890": -1225332356802479616,
        "IMG_2891": -2542600046525646336,
        "IMG_2894": -1838420006092246528,
        "IMG_2897": -1252367114489374208,
        "IMG_2898": -3675475246414669312,
        "IMG_2899": -6449507960119961088,
        "IMG_2900": -1227590753795018240,
        "IMG_2901": -6422495156310222336,
        "IMG_2902": -5983385500301198848,
        "IMG_2903": -1236591459084338688,
        "IMG_2904": -6413514348245394944,
        "IMG_2905": -5449735170155980800,
        "IMG_2906": -5837027205817148928,
        "IMG_2908": -6424738341484340736,
        "IMG_2909": -6999087789974327296,
        "IMG_2910": -5855598059886808576,
        "IMG_2913": 7421015940751350272,
        "IMG_2914": 3358768452513757184,
        "IMG_2916": 3367633273326957056,
        "IMG_2917": 4484521024254439424,
        "IMG_2919": -8773372479606558720,
        "IMG_2920": -6441239573992900096,
        "IMG_2922": 341882715409543168,
        "IMG_2923": -8179033702595235328,
        "IMG_2925": 3239983821339914240,
        "IMG_2926": -4738705878938750464,
        "IMG_2927": -703620790084521984,
        "IMG_2928": -8197483585017155584,
        "IMG_2929": -3536383315015831040,
        "IMG_2931": -6441204517706737664,
        "IMG_2932": -5864183562877767168,
        "IMG_2933": -8169889794529267712,
        "IMG_2937": -1279976412317191680,
        "IMG_2938": 918371539084407296,
        "IMG_2939": 3210136607575011328,
        "IMG_2942": -1243346790208581120,
        "IMG_2944": 5671927741050190336,
        "IMG_2945": -8142898847801345536,
        "IMG_2946": -5891633446159323136,
        "IMG_2947": -5864602923492806144,
        "IMG_2948": 3368304110854404096,
        "IMG_2949": -1288959557607297024,
        "IMG_2950": -5891064422851874816,
        "IMG_2952": -8178890293635679744,
        "IMG_2953": -4684239807371616256,
        "IMG_2954": -1851344429697437696,
        "IMG_2955": -1226038389265076224,
        "IMG_2957": -5850676622992279552,
        "IMG_2958": 3331599657361403904,
        "IMG_2960": -8161023229425422336,
        "IMG_2962": -1964098680066477568,
        "IMG_2963": -8287128966784552448,
        "IMG_2965": 3386210518717757440,
        "IMG_2967": -1261374324976586752,
        "IMG_2968": -3531177539775434752,
        "IMG_2969": -3549333216972312576,
        "IMG_2971": -3549896338456512512,
        "JacquesCressaty": -90425250537350656,
        "JakeJohnson": 2212602863012084224,
        "JasonScott": -4866527816384316928,
        "JeffKaplan": 3359323302127391232,
        "JimShankland": -5846060870761025024,
        "JudeCohelo": -3531844014815547392,
        "JuneGoldsmith": -1963933656280010752,
        "MarioMurphy": -8304999878758305792,
        "MaryKahleAustin": -4702149236878968320,
        "MichelleKrasowski": -8143039480060776448,
        "MikeMcCabe": 1062425651380549632,
        "NualaCreed": 3359329289076011008,
        "PaulHickman": -1407763291827308032,
        "RajKumar": -1279943598500155392,
        "RalfMuehlen": -1945954451405867008,
        "RickPrelinger": 501798091829956608,
        "RobertMiller": -8161023770346196480,
        "RodHewitt": -5891064422359959040,
        "SamStoller": -5837581952217712640,
        "TedNelson": -8197052576192368640,
        "TraceyJaquith": 2791693758624356864,
        "TrevorVonStein": -1387499911134152704,
        "VinayGoel": 7277463737655286272,
    ]
    
     
    // returns passed in image as grayscale
    // https://stackoverflow.com/questions/40178846/convert-uiimage-to-grayscale-keeping-image-quality
    func Noir(orig: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: orig), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
    

    func match(cam: UIImage, fname:String) -> String {
        let phasher:OSImageHashingProvider = OSImageHashingProviderFromImageHashingProviderId(OSImageHashingProviderId(rawValue: 4))
        let phash1:OSHashType = phasher.hashImage(cam)
        print("\"\(fname)\": \(phash1),") // JFC make ur sh*t unsigned!
        
        var scores = [String: OSHashDistanceType]()
        for name in phashes.keys {
            var phash2:OSHashType = 0
            if ((phashes[name]) != nil  &&  phashes[name] != 0) {
                phash2 = phashes[name]!
            } else {
                phash2 = phasher.hashImage(UIImage(named: name)!)
                print("\"\(name)\": \(phash2),") // JFC make ur sh*t unsigned!
            }
            scores[name] = phasher.hashDistance(phash1, to: OSHashType(phash2))
        }
        
        var best = ""
        for (k, v) in (Array(scores).sorted {$0.1 < $1.1}) {
            if (best == "") {
                best = k
            }
            print("\(k):\(v)")
        }
        
        return best
    }
    
    
    func xxx(cam: UIImage) -> String {
        let size = CGSize(width: compareWidth, height: compareHeight)

        //mainly(3, ["js.ppm", "bk.ppm"])
        //String.fromCString(mainly(3, ["js.ppm", "bk.ppm"]))


        
        for TESTIMG in ["BrewsterKahle","BrewsterKahle2","BrewsterKahle-xxx","BrewsterKahle-xxx2","jason-xxx"] { //xxx
            print("=========== \(TESTIMG) =====================================================================")
            match(cam: UIImage(named: TESTIMG)!, fname:TESTIMG)
        }


        var t1 = UIImage(named: "TraceyJaquith")!.scaled(to: size)
        var t2 = UIImage(named: "TraceyJaquith")!.scaled(to: size)
        
        var b1 = UIImage(named: "BrewsterKahle")!.scaled(to: size)
        var b2 = UIImage(named: "BrewsterKahle2")!.scaled(to: size)
        
        let phasher = OSImageHashingProviderFromImageHashingProviderId(OSImageHashingProviderId.pHash)
        let phash1:OSHashType = phasher.hashImage(b1)
        let phash2:OSHashType = phasher.hashImage(b2)
        let dist:OSHashDistanceType = phasher.hashDistance(phash1, to: phash2)
        print("b1 phash: \(String(phash1, radix: 16, uppercase: false))")
        print("b2 phash: \(String(phash2, radix: 16, uppercase: false))")
        print("dist: \(dist)")

        // METRICS:                  // MAE  / RMSE / MAET
        chex(image1: t1, image2: t2) // 0    / 0    / 0
        chex(image1: b1, image2: b2) // 46.8 / 69.0 / 46.4
        chex(image1: t1, image2: b1) //_42.7_/_68.7_/_42.1_
        chex(image1: t1, image2: b2) // 60.4 / 86.1 / 60.1
        print("\n\n============================\n\n")
        t1 = Noir(orig: t1)
        b1 = Noir(orig: b1)
        b2 = Noir(orig: b2)
        chex(image1: t1, image2: t2) // 65.7 / 90.3  / 65.2
        t2 = Noir(orig: t2)
        // METRICS:                  // MAE  / RMSE / MAET
        chex(image1: t1, image2: t2) // 0    / 0     / 0
        chex(image1: b1, image2: b2) //_50.3_/ 76.30 /_50.0_
        chex(image1: t1, image2: b1) // 50.5 /_76.28_/ 50.2
        chex(image1: t1, image2: b2) // 62.6 / 87.9  / 62.3
        
        return "Statue"
    }
    
    
    func chex(image1: UIImage, image2: UIImage) {
        if (!image1.size.equalTo(image2.size)) {
            print("DIFF SIZES!")
            return
        }
        
        let pixelData1:CFData = image1.cgImage!.dataProvider!.data!
        let pixelData2:CFData = image2.cgImage!.dataProvider!.data!
        print("LEN: \(CFDataGetLength(pixelData1))")
        print("LEN: \(CFDataGetLength(pixelData2))")
        
        let img1ptr: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData1)
        let img2ptr: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData2)
        
        let width  = (image1.cgImage!).width
        let height = (image1.cgImage!).height
        print("width: \(width) height: \(height)")
        
        if (CFDataGetLength(pixelData1) != width * height * 4  ||  CFDataGetLength(pixelData2) != width * height * 4) {
            print("PIXEL DATA LEN UNEXPECTED")
            return
        }
        
        // helpful:
        //  http://www.imagemagick.org/discourse-server/viewtopic.php?t=17284#p64697
        // RMSE => Square Root Mean Squared Error.
        // It means for each pixel get the color difference, and square it, average all
        // the squared differences, then return the square root of that.
        // Mean Absolute Error - but count < 5% as 0 / "Threshold"
        //    (I made MAET up -- but MAE + thresholding is a concept..)
        var MAE:float_t = 0 // Mean Absolute Error
        var RMSE:float_t = 0
        var MAET:float_t = 0
        let totalCompares:float_t = 3 * float_t(width) * float_t(height)
        var numDifferences:float_t = 0.0
        var compared = 0
        for yCoord in 0...height {
            for xCoord in 0...width {
                compared += 3 // comparing R,G,B // nixxx this later
                let idx:Int = ((width * yCoord) + xCoord ) * 4 // The image is png, 4B (R,B,G,A)
                
                let d1 = abs(Int(img1ptr[idx+0]) - Int(img2ptr[idx+0]))
                let d2 = abs(Int(img1ptr[idx+1]) - Int(img2ptr[idx+1]))
                let d3 = abs(Int(img1ptr[idx+2]) - Int(img2ptr[idx+2]))
                
                MAE  += float_t(d1 + d2 + d3)
                RMSE += float_t((d1 * d1) + (d2 * d2) + (d3 * d3))
                
                if (d1 > 12) { MAET += float_t(d1) }
                if (d2 > 12) { MAET += float_t(d2) }
                if (d3 > 12) { MAET += float_t(d3) }
                
                if (d1 > 25 || d2 > 25 || d3 > 25) {
                    //one or more pixel components differs by 10% or more
                    numDifferences += 1
                }
            }
        }
        print("#compares: expected: \(totalCompares), did: \(compared), \(numDifferences) differed 10%+")
        print("--> MAE: \(MAE / totalCompares)")
        print("--> RMSE: \(sqrt(RMSE / totalCompares))")
        print("--> MAET: \(MAET / totalCompares)")
        print("--> they are \(numDifferences / totalCompares * 100.0)% different\n")
        
        
        // faster? single stream through bytes
        MAE = 0
        RMSE = 0
        MAET = 0
        numDifferences = 0
        for idx in 0...(width * height * 4) {
            if ((idx % 4) == 3) {
                continue // skip alpha channel
            }
            let diff = float_t(abs(Int(img1ptr[idx]) - Int(img2ptr[idx])))
            MAE += diff
            RMSE += (diff * diff)
            
            if (diff > 12.0) { MAET += diff }
            if (diff > 25) {
                //one or more pixel components differs by 10% or more
                numDifferences += 1
            }
        }
        
        print("#compares: expected: \(totalCompares), \(numDifferences) differed 10%+")
        print("--> MAE: \(MAE / totalCompares)")
        print("--> RMSE: \(sqrt(RMSE / totalCompares))")
        print("--> MAET: \(MAET / totalCompares)")
        print("--> they are \(numDifferences / totalCompares * 100.0)% different\n")
    }

    
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
            var results = "Statue"

            let myImage:UIImage = sceneView.snapshot! // SEE CUSTOM THING TOP OF FILE!
            //myImage = UIImage(named: "glogo")!
            results = match(cam: myImage, fname:"camera")

            // Create a transform with a translation of 0.75 meter in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.75
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            anchor.accessibilityLabel = results // a little hackety-hack to pass to anchor display
            print("DA PHUQUE? \(results)")
            

            
            if (false) {
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
}
