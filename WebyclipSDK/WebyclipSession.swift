
import Foundation
import Alamofire
import CryptoSwift
import SwiftyJSON

/**
 A session is user's interaction with the Webyclip videos
*/
public class WebyclipSession {
    
    public var siteId: String
    private var sslEndpoint: String
    
    public init(siteId: String) {
        let components = siteId.componentsSeparatedByString(":")
        self.siteId = components[0]
        self.sslEndpoint = components[1]
    }
    
    /**
     Create a context object to represent the content on the view you like to get matching videos for
     
        - parameter config:     Context configuration `WebyclipContextConfig`
        - parameter success:    Callback that is called in case of a success with the newly created `WebyclipContext`
        - parameter error:      Callback that is called in case of error
     */
    public func createContext(config: WebyclipContextConfig, success: (context: WebyclipContext) -> Void, error: (error: NSError?) -> Void) {
        
        let md5 = config.id.md5().md5()
    
        let url = "https://\(self.sslEndpoint)/group/\(md5).json"
        Alamofire.request(.GET, url).responseString { response in
            
            if response.result.isSuccess {
                let value = response.result.value!
                let jsonString = value.substringWithRange(Range<String.Index>(start: value.startIndex.advancedBy(24), end: value.endIndex.advancedBy(-1)))
                var webyclipMedia = [WebyclipMedia]()
                if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    for item in json["contexts"][0]["medias"].arrayValue {
                        let mediaItem = WebyclipMedia()
                        mediaItem.mediaId = item["external_id"].stringValue
                        mediaItem.providerName = item["provider"].stringValue
                        mediaItem.relatedItems = []
                        mediaItem.duration = item["base_media"]["duration"].intValue
                        webyclipMedia.append(mediaItem)
                        
                    }
                    success(context: WebyclipContext(items: webyclipMedia))
                }
            }
            else {
                error(error: response.result.error)
            }
        }
    }
 
    /**
     Create a carousel component with a thumbnail for each media.
     
     - parameter config:    Carousel configuration `WebyclipCarouselConfig`
     - parameter context:   Bind this carousel to a context. When the context loads, the context medias will be set to the carousel.

     - returns `WebyclipCarouselController`
     */
    public func createCarousel(config: WebyclipCarouselConfig, context: WebyclipContext) -> WebyclipCarouselController {
        return WebyclipCarouselController(session: self, context: context)
    }

    /**
     Create a player component that plays media from the defined list.
     
     - parameter config:    Player configuration `WebyclipPlayerConfig`
     - parameter context:   Bind this player to a context. When the context loads, the context medias will be set to the player.
     
     - returns `WebyclipPlayerController`
     */
    public func createPlayer(config: WebyclipPlayerConfig, context: WebyclipContext) -> WebyclipPlayerController {
        return WebyclipPlayerController(session: self, context: context)
    }
  
    /**
     Report a CFA event
     
     - parameter context:   The context this CFA is associated with     
     - parameter action:    The action name
     */
    public func reportCFA(context: WebyclipContext, action: String) {
        // Currently NOT implemented
    }
    
    /**
     Report purchase
     
     - parameter context:   The context this purchase is associated with
     */
    public func reportCFA(context: WebyclipContext) {
        // Currently NOT implemented
    }

}