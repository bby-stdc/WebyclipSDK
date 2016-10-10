
import Foundation

/**
 Represents a content on the view you like to get matching videos for
*/
public class WebyclipContext {
    
    public var items: [WebyclipMedia] = []
    
    public init(items: [WebyclipMedia]) {
        self.items = items
    }
    
    /**
     Check whether the loaded context has any assigned media
     
     - returns: true if the context has media
     */
    public func hasMedia() -> Bool {
        return self.items.count > 0
    }
    
}