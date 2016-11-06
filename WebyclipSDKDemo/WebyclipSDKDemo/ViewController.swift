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
    
    var session : WebyclipSession?
    var contextConfig: WebyclipContextConfig?
    var playerController : WebyclipPlayerController?
    var carouselController : WebyclipCarouselController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(self.view.bounds.size.width / 2 - 50, self.view.bounds.size.height / 2 - 25, 100, 50)
        button.backgroundColor = UIColor.blackColor()
        button.setTitle("Watch Video", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ViewController.watchVideo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
       // self.view.addSubview(button)
        
        self.session = WebyclipSDKManager.sharedManager.createSession("bestbuy:bccc67d4b0e5885cd603-ad91f58f506454f5c2d14d3c7ead3377.ssl.cf2.rackcdn.com")
        self.contextConfig = WebyclipContextConfig(id: "027242891074")
        
        self.session!.createContext(self.contextConfig!, success:
            { context in
                let playerConfig = WebyclipPlayerConfig()
                self.playerController = self.session!.createPlayer(playerConfig, context: context)
                self.playerController?.delegate = self
                
                let carouselConfig = WebyclipCarouselConfig()
                self.carouselController = self.session!.createCarousel(context, player: self.playerController!, carouselConfig: carouselConfig)
                self.carouselController?.delegate = self
                self.view.addSubview(self.carouselController!.view)
            }, error: { error in
        })

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func watchVideo(sender: UIButton!) {
        self.session!.createContext(self.contextConfig!, success:
            { context in
                let playerConfig = WebyclipPlayerConfig()
                self.playerController = self.session!.createPlayer(playerConfig, context: context)
                self.playerController?.delegate = self
                self.view.addSubview(self.playerController!.view)
            }, error: { error in
        })

    }
    
    func didClick(media: WebyclipMedia) {
        print (media)
        //self.playerController!.play(media)
       // self.view.addSubview(self.playerController!.view)
    }
    
    func didPlayStart(media: WebyclipMedia) {
        print(media)
    }
    
    func didPlayEnd(media: WebyclipMedia, durationSeconds: Int) {
        print (durationSeconds)
    }
    
    func didRelatedItemClick(media: WebyclipMedia, relatedItem: WebyclipRelatedItem) {
        
    }
    
    func didSocialShare(media: WebyclipMedia, socialNetwork: String) {
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

