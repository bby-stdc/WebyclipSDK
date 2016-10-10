
import Foundation

/**
 Delegate of `WebyclipPlayerController`
*/
public protocol WebyclipPlayerProtocol {
    /**
     Invoked when a video starts playing in the player.
     
     - parameter media: The media that is played `WebyclipMedia`
     */
    func didPlayStart(media: WebyclipMedia)
    /**
     Invoked when a video stops playing in the player.
     
     - parameter media: The media that was played `WebyclipMedia`
     - parameter durationSeconds: The duration in seconds that the video was played for
     */
    func didPlayEnd(media: WebyclipMedia, durationSeconds: Int)
    /**
     Invoked when a related item is clicked in the player.
     
     - parameter media: The media that was playing while the item was clicked `WebyclipMedia`
     - parameter relatedItem: The item that was clicked `WebyclipRelatedItem`
     */
    func didRelatedItemClick(media: WebyclipMedia, relatedItem: WebyclipRelatedItem)
    /**
     Invoked when a social share button is clicked in the player.
     
     - parameter media: The media that was playing while the social share button was clicked `WebyclipMedia`
     - parameter socialNetwork: The social network key name (one of the following: facebook, twitter, pinterest, whatsapp, googleplus, linkedin)
     */
    func didSocialShare(media: WebyclipMedia, socialNetwork: String)
}