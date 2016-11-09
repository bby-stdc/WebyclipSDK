
import UIKit

/**
    Webyclip base entry point for the API
 */
open class WebyclipSDKManager {
    /**
     Shared instance of `WebyclipSDKManager`
    */
    open static var sharedManager: WebyclipSDKManager = {
        return WebyclipSDKManager()
    }()
    
    /**
     A session is user's interaction with the Webyclip videos
     Create a session every time whenever the current context of the app should load Webyclip
     For example:
        Showing videos for a product
        Notifing Webyclip of a purchuse
     
     - parameter id: The assigned ID that was given to you by Webyclip
     
     - returns: A new `WebyclipSession`
    */
    open func createSession(_ siteId: String) -> WebyclipSession {
       return WebyclipSession(siteId: siteId)
    }
    
    
}
