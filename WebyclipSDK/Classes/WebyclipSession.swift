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
    
    private func getDataFromCDN(id: String,
                                completion: @escaping ([WebyclipMedia]) -> Void,
                                error: @escaping (_ error: NSError?) -> Void) {
        
        var webyclipMedia = [WebyclipMedia]()
        
        let md5 = id.md5().md5()
        let url = "https://\(self.sslEndpoint)/group/\(md5).json"
        
        Alamofire.request(url).responseString { response in
            guard response.result.isSuccess else {
                print("Error while fetching context: \(response.result.error)")
                error(nil)
                return
            }
            
            guard response.response?.statusCode != 404 else {
                print("Object not found on CDN")
                error(nil)
                return
            }
            
            guard let value = response.result.value, value.range(of: "webyclipMediaForContext") != nil else {
                print("Malformed data received from CDN")
                error(nil)
                return
            }
            
            let jsonString = value.substring(with: Range<String.Index>(uncheckedBounds: (lower: value.index(value.startIndex, offsetBy: 24) , upper: value.index(value.endIndex, offsetBy: -1))))
            
            if let dataFromString = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                
                var cdnIsValid = false
                
                let json = JSON(data: dataFromString)
                
                if (json["cdn_update_time"].exists()) {
                    let cdnUpdateTime = Date(timeIntervalSince1970: json["cdn_update_time"].doubleValue / 1000)
                    let now = Date()
                    
                    if (WebyclipUtils.getDaysBetweenDates(startDate: now, endDate: cdnUpdateTime) <= 3) {
                        cdnIsValid = true;
                    }
                }
                
                
                if (cdnIsValid) {
                    for item in json["contexts"][0]["medias"].arrayValue {
                        let mediaItem = WebyclipMedia(media: item)
                        webyclipMedia.append(mediaItem)
                    }
                }
                else {
                    error(nil)
                    return
                }
            }
            else {
                error(nil)
                return
            }
            
            completion(webyclipMedia)
        }
    }
    
    private func getDataFromServer(id: String,
                                   config: WebyclipContextConfig,
                                   completion: @escaping ([WebyclipMedia]) -> Void,
                                   error: @escaping (_ error: NSError?) -> Void) {
        var webyclipMedia = [WebyclipMedia]()
        
        let md5 = id.md5().md5()
        let url = "https://app.webyclip.com/api.php?action=get_media_for_context_group"
        let params: Parameters = [
            "site_id": self.siteId,
            "contexts": [
                [
                    "site_id": self.siteId,
                    "type": config.type,
                    "context_id": config.id,
                    "tags": config.tags
                ]
            ],
            "group_id": md5
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { response in
            guard response.result.isSuccess else {
                print("Error while fetching context: \(response.result.error)")
                error(nil)
                return
            }
            guard let value = response.result.value else {
                print("Malformed data received from server")
                error(nil)
                return
            }
            
            if let dataFromString = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                for item in json["contexts"][0]["medias"].arrayValue {
                    let mediaItem = WebyclipMedia(media: item)
                    webyclipMedia.append(mediaItem)
                }
            }
            
            completion(webyclipMedia)
        }
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
        self.getDataFromCDN(id: config.id,
                            completion:  { medias in
                                success(WebyclipContext(items: medias))
                            },
                            error: {_ in 
                                self.getDataFromServer(id: config.id,
                                                       config: config,
                                                       completion: { medias in
                                                            success(WebyclipContext(items: medias))
                                                       },
                                                       error: error)
                            })
    }
 
    /**
     Create a carousel component with a thumbnail for each media.
     
     - parameter context:   Bind this carousel to a context. When the context loads, the context medias will be set to the carousel.
     - parameter carouselConfig:    Carousel configuration `WebyclipCarouselConfig`
     - parameter player:    Player object `WebyclipPlayerController`

     - returns `WebyclipCarouselController`
     */
    open func createCarousel(_ context: WebyclipContext, player: WebyclipPlayerController, carouselConfig: WebyclipCarouselConfig, isCompact: Bool = false) -> WebyclipCarouselBaseController {
        return WebyclipCarouselBaseController(session: self, context: context, player: player, config: carouselConfig, isCompact: isCompact)
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
