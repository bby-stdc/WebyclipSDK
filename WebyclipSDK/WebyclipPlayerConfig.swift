
import Foundation

/**
 Configuration of `WebyclipPlayerController`
*/
open class WebyclipPlayerConfig {
    
    public init() {
        
    }
    /// Play the first video as soon as the player is visible. 
    open var autoPlay: Bool = true
    
    /// Show the video title.
    open var showTitle: Bool = true
    
    /// Show the WebyClip Credit Logo.
    open var showWebyclipCredits: Bool = true
    
    ///  Show an X close button.
    open var showCloseButton: Bool = true
    
    /// Show the "Thumb up" / "Thumb down" buttons.
    open var showSocialButtons: Bool = true

    /// Show the Report flag.
    open var showReportButton: Bool = true

    /// A list of social networks to enable share to, possible values are: facebook, twitter, pinterest, whatsapp, googleplus, linkedin
    open var socialNetworksShare: [String] = ["facebook","twitter","pinterest","whatsapp"]
    
    /// Show the "More Videos" section.
    open var showMoreVideos: Bool = true

    /// Show the "Related Items" section.
    open var showRelatedItems: Bool = true
    
    /// Text to show in the disclaimer section, hides the disclaimer if nil
    open var disclaimerText: String? = "This YouTube video has been automatically selected by the WebyClip service. The video contains an example of the item for sale, which may not be representative of the item you are purchasing. Please check the product description and condition before purchasing. No recommendation from the video creator is implied."

}
