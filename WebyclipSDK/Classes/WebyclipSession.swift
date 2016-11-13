import Foundation
import Alamofire
import CryptoSwift
import SwiftyJSON

/**
 A session is user's interaction with the Webyclip videos
*/
open class WebyclipSession {
    //MARK: - Private
    fileprivate var sslEndpoint: String
    
    private func getDataFromServer() {
        
    }
    
    //MARK: - Public
    open var siteId: String
    
    public init(siteId: String) {
        let components = siteId.components(separatedBy: ":")
        self.siteId = components[0]
        self.sslEndpoint = components[1]
    }
    
    /**
     Create a context object to represent the content on the view you like to get matching videos for
     
        - parameter config:     Context configuration `WebyclipContextConfig`
        - parameter success:    Callback that is called in case of a success with the newly created `WebyclipContext`
        - parameter error:      Callback that is called in case of error
     */
    open func createContext(_ config: WebyclipContextConfig, success: @escaping (_ context: WebyclipContext) -> Void, error: @escaping (_ error: NSError?) -> Void) {
        
        let md5 = config.id.md5().md5()
        let url = "https://\(self.sslEndpoint)/group/\(md5).json"
        
        Alamofire.request(url).responseString { response in
            guard response.result.isSuccess else {
                print("Error while fetching context: \(response.result.error)")
                self.getDataFromServer()
                return
            }
            guard let value = response.result.value, value.range(of: "webyclipMediaForContext") != nil else {
                print("Malformed data received from CDN")
                self.getDataFromServer()
                return
            }
            let jsonString = value.substring(with: Range<String.Index>(uncheckedBounds: (lower: value.index(value.startIndex, offsetBy: 24) , upper: value.index(value.endIndex, offsetBy: -1))))
            var webyclipMedia = [WebyclipMedia]()
            if let dataFromString = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                for item in json["contexts"][0]["medias"].arrayValue {
                    let mediaItem = WebyclipMedia(media: item)
                    webyclipMedia.append(mediaItem)
                }
                success(WebyclipContext(items: webyclipMedia))
            }
        }
    }
 
    /**
     Create a carousel component with a thumbnail for each media.
     
     - parameter context:   Bind this carousel to a context. When the context loads, the context medias will be set to the carousel.
     - parameter carouselConfig:    Carousel configuration `WebyclipCarouselConfig`
     - parameter player:    Player object `WebyclipPlayerController`

     - returns `WebyclipCarouselController`
     */
    open func createCarousel(_ context: WebyclipContext, player: WebyclipPlayerController, carouselConfig: WebyclipCarouselConfig) -> WebyclipCarouselBaseController {
        if (carouselConfig.compact) {
            return WebyclipCarouselCompactController(session: self, context: context, player: player, config: carouselConfig)
        }
        return WebyclipCarouselDefaultController(session: self, context: context, player: player, config: carouselConfig)
    }

    /**
     Create a player component that plays media from the defined list.
     
     - parameter config:    Player configuration `WebyclipPlayerConfig`
     - parameter context:   Bind this player to a context. When the context loads, the context medias will be set to the player.
     
     - returns `WebyclipPlayerController`
     */
    open func createPlayer(_ config: WebyclipPlayerConfig, context: WebyclipContext) -> WebyclipPlayerController {
        return WebyclipPlayerController(session: self, context: context)
    }
  
    /**
     Report a CFA event
     
     - parameter context:   The context this CFA is associated with     
     - parameter action:    The action name
     */
    open func reportCFA(_ context: WebyclipContext, action: String) {
        // Currently NOT implemented
    }
    
    /**
     Report purchase
     
     - parameter context:   The context this purchase is associated with
     */
    open func reportCFA(_ context: WebyclipContext) {
        // Currently NOT implemented
    }

}
