
import UIKit
import SwiftyJSON
import WebKit

/**
 Controller object of the Webyclip thumbnails carousel
*/
public class WebyclipCarouselController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

    private var session: WebyclipSession?
    private var context: WebyclipContext?
    private var webView: WKWebView?
    private var userContentController: WKUserContentController?
    private var loadedMedias = false
    
    /// Delegate for getting callbacks
    public var delegate: WebyclipCarouselProtocol?
    
    
    /**
     Initializes WebyclipCarouselController with `WebyclipSession` and `WebyclipContext`
     */
    public init(session: WebyclipSession, context: WebyclipContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userContentController = WKUserContentController()
        self.userContentController?.addScriptMessageHandler(self, name: "webyclipIosHandler")
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaPlaybackAllowsAirPlay = true
        config.mediaPlaybackRequiresUserAction = false
        config.userContentController = self.userContentController!
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)

        self.webView!.scrollView.bounces = false
        self.webView!.scrollView.bouncesZoom = false

        self.view.addSubview(self.webView!)
        self.webView!.navigationDelegate = self
        
        self.webView!.loadRequest(NSURLRequest(URL: NSURL(string: "https://6bf746ad5bc91a240a3d-1d8fbdf7ecdc2b67730d7c561f0d1dfd.ssl.cf2.rackcdn.com/static/carousel/WebyclipCarouselWrapperHTML.html")!))
        
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidLayoutSubviews() {
        self.webView?.frame = self.view.bounds
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        if (!self.loadedMedias) {
            var items = [JSON]()
            for item in (self.context?.items)! {
                items.append(JSON([
                    "provider": JSON(item.providerName),
                    "external_id": JSON(item.mediaId),
                    "base_media": JSON([
                        "duration": item.duration
                        ])
                    ]))
            }
            let params = JSON(items)
            let paramsString = params.rawString()
            let scriptString = "window.init('\(self.session!.siteId)',\(paramsString!))"
                        
            self.webView?.evaluateJavaScript(scriptString, completionHandler: { result, error in
                
            })
            
            self.loadedMedias = true
        }
        
    }
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let jsonString = message.body as! String
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            switch json["event"].stringValue {
            case "click":
                let mediaItem = WebyclipMedia()
                mediaItem.mediaId = json["data"]["external_id"].stringValue
                mediaItem.providerName = json["data"]["provider"].stringValue
                mediaItem.relatedItems = []
                mediaItem.duration = json["data"]["base_media"]["duration"].intValue
                self.delegate?.didClick(mediaItem)
            default: break
            }
        }
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    
    deinit {
        if webView != nil {
            webView?.navigationDelegate = nil
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
}
 