

import Foundation

/**
 Represents a media object in Webyclip context.
*/
open class WebyclipMedia {
    /// The name of the media provider
    open var providerName: String!
    /// The id of the media
    open var mediaId: String!
    /// The media title
    open var title: String!
    /// The media author
    open var author: String!
    /// The media publish date
    open var publishDate: Date!
    /// A list of related items associated with the media
    open var relatedItems: [WebyclipRelatedItem] = []
    
    open var duration: Int!
}
