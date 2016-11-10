import SwiftyJSON

/**
 Represents a media object in Webyclip context.
*/
open class WebyclipMedia {
    //MARK: - Public
    
    /// The name of the media provider
    open var providerName: String
    /// The id of the media
    open var mediaId: String
    /// The media title
    open var title: String
    /// The media author
    open var author: String
    /// The media publish date
    open var publishDate: Date
    /// A list of related items associated with the media
    open var relatedItems: [WebyclipRelatedItem] = []
    /// A media duration
    open var duration: Int
    
    /**
     Initializes WebyclipMedia
     */
    public init(media: JSON) {
        
        self.mediaId = media["external_id"].stringValue
        self.providerName = media["provider"].stringValue
        
        let baseMedia = media["base_media"]
        
        self.title = baseMedia["provider_title"].stringValue
        self.author = baseMedia["channel_name"].stringValue
        self.publishDate = NSDate(timeIntervalSince1970: baseMedia["published_at"].doubleValue / 1000) as Date
        self.duration = baseMedia["duration"].intValue
        
        self.relatedItems = []
    }
}
