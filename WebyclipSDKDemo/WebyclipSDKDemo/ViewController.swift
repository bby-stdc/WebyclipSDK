//
//  ViewController.swift
//  WebyclipSDKDemo
//
//  Created by Nimrod Ben Yaakov on 10/10/2016.
//  Copyright © 2016 Webyclip. All rights reserved.
//

import UIKit
import WebyclipSDK

class ViewController: UIViewController, WebyclipCarouselProtocol, WebyclipPlayerProtocol {
    
    var playerController : WebyclipPlayerController?
    var carouselController : WebyclipCarouselController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = WebyclipSDKManager.sharedManager.createSession("bestbuy:bccc67d4b0e5885cd603-ad91f58f506454f5c2d14d3c7ead3377.ssl.cf2.rackcdn.com")
        let contextConfig = WebyclipContextConfig(id: "719192596023")
        
        session.createContext(contextConfig, success:
            { context in
                
                
                let playerConfig = WebyclipPlayerConfig()
                self.playerController = session.createPlayer(playerConfig, context: context)
                self.playerController?.delegate = self
                self.playerController!.view.frame = CGRect(origin: self.view.bounds.origin, size: CGSize(width: self.view.bounds.size.width , height: 400))
                self.view.addSubview(self.playerController!.view)
                
                let carouselConfig = WebyclipCarouselConfig()
                self.carouselController = session.createCarousel(carouselConfig, context: context)
                self.carouselController?.delegate = self
                self.carouselController!.view.frame = CGRect(origin: CGPoint(x: self.view.bounds.origin.x, y: 400), size: CGSize(width: self.view.bounds.size.width , height: self.view.bounds.size.height - 400))
                self.view.addSubview(self.carouselController!.view)
            }, error: { error in
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    public func didClick(media: WebyclipMedia) {
        print (media)
        self.playerController!.play(media)
    }
    
    public func didPlayStart(media: WebyclipMedia) {
        print(media)
    }
    
    public func didPlayEnd(media: WebyclipMedia, durationSeconds: Int) {
        print (durationSeconds)
    }
    
    public func didRelatedItemClick(media: WebyclipMedia, relatedItem: WebyclipRelatedItem) {
        
    }
    
    public func didSocialShare(media: WebyclipMedia, socialNetwork: String) {
        print (socialNetwork)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

