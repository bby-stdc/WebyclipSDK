
import Foundation

/**
 Configuration of `WebyclipCarouselController`
*/
open class WebyclipCarouselConfig {
    
    public init() {
        
    }
    
    /// The amount of visible slides to show on the carousel
    open var numberOfSlides: Int?
    /// True / False to show the slide title
    open var showSlideTitle: Bool = true
    /// True / False to show the navigation arrows
    open var showNavigation: Bool = false
    /// True / False to show the pagination dots
    open var showPagination: Bool = true
    /// True / False to show the video duration
    open var showDuration: Bool = true
    /// True / False to show the video publish date
    open var showPublishedAgo: Bool = false
    /// The orientation of the carousel ("horizontal","vertical")
    open var orientation: String = "horizontal"
}
