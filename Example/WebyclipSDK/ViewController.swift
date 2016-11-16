import UIKit
import WebyclipSDK

class ViewController: UIViewController, WebyclipCarouselProtocol, WebyclipPlayerProtocol {
    
    @IBOutlet var carouselView: UIView!
    @IBOutlet var carouselViewCompact: UIView!
    @IBOutlet var openButton: UIButton!
    
    var playerController : WebyclipPlayerController?
    
    @IBAction func openPlayerHandler(_ sender: AnyObject) {
        guard self.playerController != nil else {
            print("Player object is not exist")
            return
        }
        self.playerController?.openPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = WebyclipSDKManager.sharedManager.createSession("bestbuy:bccc67d4b0e5885cd603-ad91f58f506454f5c2d14d3c7ead3377.ssl.cf2.rackcdn.com")
        let contextConfig = WebyclipContextConfig(id: "4710800")
        
        session.createContext(contextConfig, success:
            { context in
                if context.hasMedia() {
                    // Player initialization
                    let playerConfig = WebyclipPlayerConfig()
                    self.playerController = session.createPlayer(playerConfig, context: context)
                    self.playerController?.delegate = self
                    
                    // Carousel initialization (default design)
                    let carouselConfig = WebyclipCarouselConfig()
                    let carouselController = session.createCarousel(context, player: self.playerController!, carouselConfig: carouselConfig)
                    carouselController.delegate = self
                    self.carouselView.addSubview(carouselController.view)
                    
                    // Carousel initialization (compact design)
                    let carouselConfigCompact = WebyclipCarouselConfig(compact: true)
                    let carouselControllerCompact = session.createCarousel(context, player: self.playerController!, carouselConfig: carouselConfigCompact, isCompact: true)
                    self.carouselViewCompact.addSubview(carouselControllerCompact.view)
                }
        }, error: { error in
        })
    }
    
    func didClick(_ media: WebyclipMedia) {
        print("I've just clicked on carousel thumbnail!")
    }
    
    func didPlayStart(_ media: WebyclipMedia) {
        print(media)
    }
    
    func didPlayEnd(_ media: WebyclipMedia, durationSeconds: Int) {
        print (durationSeconds)
    }
    
    func didRelatedItemClick(_ media: WebyclipMedia, relatedItem: WebyclipRelatedItem) {
        
    }
    
    func didSocialShare(_ media: WebyclipMedia, socialNetwork: String) {
        print (socialNetwork)
    }
}
