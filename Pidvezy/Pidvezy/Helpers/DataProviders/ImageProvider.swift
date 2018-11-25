//
//  ImageProvider.swift

import Foundation
import UIKit

class ImageProvider {
    
    enum PrepareType {
        case round(CGFloat)
        case thumbnail(CGFloat, CGFloat)
        case custom(((_ image: UIImage) -> UIImage?))
        
        var preparation: ((_ image: UIImage) -> UIImage?) {
            switch self {
            case .round(let diameter):
                return { image in
                    
                    let size = diameter 
                    let squareImage = image.thumbnailImage(size: CGSize(width: size, height: size), quality: .high, keepAspectRatio: true)
                    return squareImage?.roundedImage(cornerRadius: image.size.width/2.0)
                }
            case .thumbnail(let width, let height):
                return { image in
                    // do not redraw if image is smaller then targeted size
                    if image.size.width <= width || image.size.height <= height {
                        return image
                    }
                    return image.thumbnailImage(size: CGSize(width: width, height: height), quality: .high, keepAspectRatio: true)
                }
            case .custom (let closure):
                return closure
            }
        }
        
        func cacheURL(_ url: URL) -> URL? {
            switch self {
            case .round(let diameter):
                return url.appendingPathComponent("round-\(diameter)")
            case .thumbnail(let width, let height):
                return url.appendingPathComponent("thumbnail-\(width)x\(height)")
            case .custom:
                return nil
            }
        }
    }
    
    /* @discussion
        points for improvement:
        - move all this stuff to cacheReqeustHandler
        - move to download mechanism with background session and delegates (NOTE: background session doesn't support completion blocks)
            if decided to move to background download, data tasks should be switched to download tasks
        - add ability to cancel loading
    */
    
    let session: URLSession
    let documentsDirectory: String
    
    init() {
        /*
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.hive.networking.background")
        session = URLSession(configuration: backgroundConfiguration, delegate: self, delegateQueue: .main)
        */
        session = URLSession(configuration: .default)
        documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    private var images = [URL: UIImage]()
    
    var placeholder: UIImage?
    var prepareType: PrepareType?
    
    // load images on demand
    /*
     1. return image, if already loaded
     2. if not, check the cache
     3. if not, load it in background
     4. if prepare closure is available, call it and store prepared image
     5. else, store loaded image in cache and in memory
     6. return image in main thread
     */
    func loadImage(url: URL, completion: @escaping (_ image: UIImage) -> Void) -> UIImage? {
        
        let cacheURL = prepareType?.cacheURL(url) ?? url
        
        if let image = images[cacheURL] {
            return image
        } else if let image = Cache.shared.cachedImage(url: cacheURL) { // why not always check cache and skip in-memory store?
            // cuz reading from file system is also expensive
            images[cacheURL] = image
            return image
        } else {
            // set to placeholder, if loading trigers after already started
            self.images[cacheURL] = placeholder // TODO: placeholder is optional, may cause deadlock if nil
            // load
            let request = URLRequest(url: url)
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error == nil, let data = data, let image = UIImage(data: data) {
                    if let closure = self.prepareType?.preparation, let processedImage = closure(image) {
                        self.images[cacheURL] = processedImage
                        Cache.shared.cache(image: processedImage, url: cacheURL)
                        DispatchQueue.main.async {
                            completion(processedImage)
                        }
                    } else {
                        self.images[cacheURL] = image
                        // here we can skip double conversion from UIImage, since it was not modified by prepare block
                        Cache.shared.cache(imageData: data, url: cacheURL)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                } else if let placeholder = self.placeholder {
                    DispatchQueue.main.async {
                        completion(placeholder)
                    }
                }
            }).resume()
        }
        
        return nil
    }
    
}

extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func roundedImage(cornerRadius: CGFloat) -> UIImage? {
        return roundedImage(cornerRadius: cornerRadius, backgroundImage: nil, margin: 0)
    }
    
    func roundedImage(cornerRadius: CGFloat, backgroundImage: UIImage?, margin: CGFloat?) -> UIImage? {
        return roundedImage(size: self.size, cornerRadius: cornerRadius, backgroundImage: backgroundImage, margin: margin)
    }
    
    func roundedImage(size: CGSize, cornerRadius: CGFloat, backgroundImage: UIImage?, margin: CGFloat?) -> UIImage? {
        assert(!Thread.isMainThread, "executing heavy image task in main thread")
        return autoreleasepool(invoking: { () -> UIImage? in
            // Begin a new image that will be the new image with the rounded corners
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            
            context.interpolationQuality = .high
            
            // Add a clip before drawing anything, in the shape of an rounded rect
            let rect = CGRect(x: 0, y:0, width: size.width, height: size.height)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.addClip()
            
            // Draw image
            self.draw(in: rect)
            
            // Get the image
            var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext()
            
            if let background = backgroundImage, let margin = margin, margin > 0 {
                // Begin a new image that will be the new image with the rounded corners
                UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + 2 * margin, height: size.height + 2 * margin), false, 0.0)
                
                guard let context = UIGraphicsGetCurrentContext() else {
                    return roundedImage
                }
                
                context.interpolationQuality = .high
                
                // Add a clip before drawing anything, in the shape of an rounded rect
                let rect = CGRect(x: 0, y: 0, width: size.width + 2 * margin, height: size.height + 2 * margin)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                path.addClip()
                
                background.draw(in: rect)
                roundedImage?.draw(in: CGRect(x: margin, y: margin, width: size.width, height: size.height))
                
                // Get the image, here setting the UIImageView image
                roundedImage =  UIGraphicsGetImageFromCurrentImageContext()
                
                // Lets forget about that we were drawing
                UIGraphicsEndImageContext()
            }
            
            return roundedImage
        })
    }
    
    func thumbnailImage(size: CGSize, quality: CGInterpolationQuality, keepAspectRatio: Bool) -> UIImage? {
        assert(!Thread.isMainThread, "executing heavy image task in main thread")
        return autoreleasepool(invoking: { () -> UIImage? in
            if size.width * size.height == 0 {
                return nil
            }
            
            var scaledImage: UIImage? = nil
            
            UIGraphicsBeginImageContext(size)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            
            context.interpolationQuality = quality
            
            if (!keepAspectRatio)
            {
                let rect = CGRect(x: 0, y:0, width: size.width, height: size.height)
                context.draw(self.cgImage!, in: rect)
            }
            else
            {
                let horizontalScaleFactor  = size.width / self.size.width
                let verticalScaleFactor = size.height / self.size.height
                
                let scaleFactor = max(horizontalScaleFactor, verticalScaleFactor)
                
                let rect = CGRect(x: (size.width - self.size.width * scaleFactor) / 2,
                                  y: (size.height - self.size.height * scaleFactor) / 2,
                                  width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
                
                self.draw(in: rect)
            }
            
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return scaledImage
        })
    }
}
