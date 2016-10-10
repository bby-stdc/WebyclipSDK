
import Foundation

/**
 Configuration of `WebyclipCarouselController`
*/
public class WebyclipCarouselConfig {
    
    public init() {
        
    }
    
    /// The amount of visible slides to show on the carousel
    public var numberOfSlides: Int?
    /// True / False to show the slide title
    public var showSlideTitle: Bool = true
    /// True / False to show the navigation arrows
    public var showNavigation: Bool = false
    /// True / False to show the pagination dots
    public var showPagination: Bool = true
    /// True / False to show the video duration
    public var showDuration: Bool = true
    /// True / False to show the video publish date
    public var showPublishedAgo: Bool = false
    /// The orientation of the carousel ("horizontal","vertical")
    public var orientation: String = "horizontal"
}