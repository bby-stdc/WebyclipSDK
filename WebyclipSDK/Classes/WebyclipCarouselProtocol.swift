

import Foundation

/**
 Delegate of `WebyclipCarouselController`
*/
public protocol WebyclipCarouselProtocol {
    
    /**
     Invoked when a video thumbnail is clicked.
     
     - parameter media: The media that is clicked on `WebyclipMedia`
     */
    func didClick(_ media: WebyclipMedia)
}
