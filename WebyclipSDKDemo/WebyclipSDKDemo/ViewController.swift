import UIKit
import WebyclipSDK

class ViewController: UIViewController, WebyclipCarouselProtocol, WebyclipPlayerProtocol {
    
    @IBOutlet var carouselView: UIView!
    @IBOutlet var openButton: UIButton!
    
    var playerController : WebyclipPlayerController?
    var carouselController : WebyclipCarouselController?
    
    @IBAction func openPlayerHandler(sender: AnyObject) {
        self.playerController!.openPlayer(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = WebyclipSDKManager.sharedManager.createSession("bestbuy:bccc67d4b0e5885cd603-ad91f58f506454f5c2d14d3c7ead3377.ssl.cf2.rackcdn.com")
        let contextConfig = WebyclipContextConfig(id: "027242891074")
        
        session.createContext(contextConfig, success:
            { context in
                if context.hasMedia() {
                    let playerConfig = WebyclipPlayerConfig()
                    self.playerController = session.createPlayer(playerConfig, context: context)
                    self.playerController?.delegate = self
                    
                    let carouselConfig = WebyclipCarouselConfig()
                    self.carouselController = session.createCarousel(context, player: self.playerController!, carouselConfig: carouselConfig)
                    self.carouselController?.delegate = self
                    
                    self.carouselView.addSubview(self.carouselController!.view)
                }
            }, error: { error in
        })
    }
    
    func didClick(media: WebyclipMedia) {
        print("I've just clicked on carousel thumbnail!")
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
}

