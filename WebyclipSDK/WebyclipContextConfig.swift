
import Foundation

/**
 The configuration of `WebyclipContext`
*/
public class WebyclipContextConfig {

    /**
     The explicit ID for this context. If not set, the contextId is generated automatically from the context tag values.
     */
    public var id: String
    
    /**
     The type of content this context matches to. Each context type has a different set of supported <b>tags</b>. The Available types are:
     
      1. "pdp" - Product Details Page.
      2. "ctp" - Category Page.
     */
    public var type: String = "pdp"

    
    /**
     A set of key-value pairs that represent the context. According to the <b>type</b>.

     Here are the supported tags per context type:
     
     <u>pdp</u>
     
     1. <b>product_name</b> - The globally known name of the product (preferably in english)
     2. <b>product_page_title</b> - (optional) The title of the product page as appears on the page
     3. <b>category</b> - (optional) - The top level category the product belongs to
     4. <b>subcategory</b> - (optional) The second level category the product belongs to
     5. <b>external_id</b> - (optional) The ID used to identify the product on the eCommerce website

     <u>ctp</u>
     
     1. <b>category_1</b> - The most specific category level
     2. <b>category_2</b> - (optional) The second level category level
     3. <b>category_3</b> - (optional) The third level category level
     4. <b>category_4</b> - (optional) The forth level category level
     5. <b>category_5</b> - (optional) The fifth level category level
     */
    public var tags: [String:String] = [:]
    
    /**
     Array of image urls
     */
    public var images: [String]?

    /**
     An unique id for the current instance. Use this to allow customization of the shown data per instance.
     */
    public var instanceId: String?
    
    
    
    public init(id : String) {
        self.id = id
    }
}