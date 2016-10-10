
import Foundation

/**
 Configuration of `WebyclipPlayerController`
*/
public class WebyclipPlayerConfig {
    
    public init() {
        
    }
    /// Play the first video as soon as the player is visible. 
    public var autoPlay: Bool = true
    
    /// Show the video title.
    public var showTitle: Bool = true
    
    /// Show the WebyClip Credit Logo.
    public var showWebyclipCredits: Bool = true
    
    ///  Show an X close button.
    public var showCloseButton: Bool = true
    
    /// Show the "Thumb up" / "Thumb down" buttons.
    public var showSocialButtons: Bool = true

    /// Show the Report flag.
    public var showReportButton: Bool = true

    /// A list of social networks to enable share to, possible values are: facebook, twitter, pinterest, whatsapp, googleplus, linkedin
    public var socialNetworksShare: [String] = ["facebook","twitter","pinterest","whatsapp"]
    
    /// Show the "More Videos" section.
    public var showMoreVideos: Bool = true

    /// Show the "Related Items" section.
    public var showRelatedItems: Bool = true
    
    /// Text to show in the disclaimer section, hides the disclaimer if nil
    public var disclaimerText: String? = "This YouTube video has been automatically selected by the WebyClip service. The video contains an example of the item for sale, which may not be representative of the item you are purchasing. Please check the product description and condition before purchasing. No recommendation from the video creator is implied."

}