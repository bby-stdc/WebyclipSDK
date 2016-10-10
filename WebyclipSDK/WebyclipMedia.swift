

import Foundation

/**
 Represents a media object in Webyclip context.
*/
public class WebyclipMedia {
    /// The name of the media provider
    public var providerName: String!
    /// The id of the media
    public var mediaId: String!
    /// A list of related items associated with the media
    public var relatedItems: [WebyclipRelatedItem] = []
    
    public var duration: Int!
}