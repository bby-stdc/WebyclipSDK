import UIKit
import SwiftyJSON
import WebKit
import YouTubeiOSPlayerHelper

/**
 The Webyclip's Player controller
 */
public class WebyclipPlayerController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    
    /// Delegate for getting callbacks
    public var delegate: WebyclipPlayerProtocol?
  
    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var counter: UILabel!
    @IBOutlet var player: UICollectionView!
    @IBOutlet var disclaimer: UIView!
    
    // MARK: - IBActions
    @IBAction func closeButtonHandler(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        closeView()
        
    }
    
    @IBAction func disclaimerHandler(sender: AnyObject) {
        showHideDisclaimer()
    }
    
    @IBAction func disclaimerCloseButtonHandler(sender: AnyObject) {
        showHideDisclaimer()
    }
    
    // MARK: - Private
    private var session: WebyclipSession?
    private var context: WebyclipContext?
    private var nextMediaIndex: Int?
    private var loadedMedias = false
    private var currentMediaIndex = 0
    private var cellHeight: CGFloat?
    private var playersObjects: [YTPlayerView] = []
    public var initialIndex: Int?
    
    
    private var medias: [WebyclipPlayerItem]?
    private struct Storyboard {
        static let CellIdentifier = "WebyClip Player Cell"
    }
    
    private var userContentController: WKUserContentController?
    
    private func showHideDisclaimer() {
        self.disclaimer.hidden = !self.disclaimer.hidden
    }
    
    // MARK: - Public
    
    /**
     Initializes WebyclipPlayerController with `WebyclipSession` and `WebyclipContext`
     */
    public init(session: WebyclipSession, context: WebyclipContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
        self.nextMediaIndex = getNextMediaIndex()
        self.medias = WebyclipPlayerItem.createCarouselItems(context.items)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.userContentController = WKUserContentController()
        self.userContentController?.addScriptMessageHandler(self, name: "webyclipIosHandler")
        
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        self.player.registerNib(UINib(nibName: "WebyclipPlayerCell", bundle: NSBundle(forClass: self.dynamicType)), forCellWithReuseIdentifier: "WebyClip Player Cell")
        
        self.uiView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        setupHandlers()
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        self.counter.text = String(self.initialIndex! + 1) + " of " + String(self.medias!.count)
        self.player?.scrollToItemAtIndexPath(NSIndexPath(forItem: self.initialIndex!, inSection: 0), atScrollPosition: .Top, animated: false)
        
        for index in 0...self.medias!.count {
       //     let cell = self.player.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! WebyclipPlayerCollectionViewCell
         //  if (!self.playersObjects.contains(cell.mediaPlayer)) {
          //      self.playersObjects.append(cell.mediaPlayer)
        //    }
            
        }
    }
    
    public func openPlayer(index: Int) {
        
    }
    
    
    private func getNextMediaIndex() -> Int {
        let idx = self.currentMediaIndex + 1 < self.context!.items.count ? self.currentMediaIndex + 1 : 0
        return idx;
    }
    
    private func setupHandlers() {
       
    }
    
   
    
    
   
    
   
    
    
    private func closeView() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.view.removeFromSuperview()
    }
    
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WebyclipPlayer", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    
    private func getMediaThumbnail(mediaId: String) -> UIImage {
        let url = NSURL(string: "https://img.youtube.com/vi/" + mediaId + "/mqdefault.jpg")!
        let data = NSData(contentsOfURL: url)!
        return UIImage(data: data)!
    }
    
    private func setNextMedia() {
        self.currentMediaIndex = getNextMediaIndex()
        self.nextMediaIndex = getNextMediaIndex()
      //  setMediaInfo(self.currentMediaIndex, nextIdx: self.nextMediaIndex!)
    }
    
       
    
    
    public override func viewDidLayoutSubviews() {
        //self.webView?.frame = self.view.bounds
    }
    
    public func play(media: WebyclipMedia) {
        let mediaJson = JSON([
            "provider": JSON(media.providerName),
            "external_id": JSON(media.mediaId),
            "base_media": JSON([
                "duration": media.duration
                ])
            ])
        let mediaString = mediaJson.rawString()
        let scriptString = "window.play(\(mediaString!))"
        
        
        //self.webView?.evaluateJavaScript(scriptString, completionHandler: { result, error in
            
        //})
    }
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        /*if (!self.loadedMedias) {
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
        }*/
        
    }
    
    public func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let jsonString = message.body as! String
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            switch json["event"].stringValue {
            case "playStart":
                let mediaItem = WebyclipMedia()
                mediaItem.mediaId = json["data"]["media"]["external_id"].stringValue
                mediaItem.providerName = json["data"]["media"]["provider"].stringValue
                mediaItem.relatedItems = []
                mediaItem.duration = json["data"]["media"]["base_media"]["duration"].intValue
                self.delegate?.didPlayStart(mediaItem)
                break;
            case "playEnd":
                let mediaItem = WebyclipMedia()
                mediaItem.mediaId = json["data"]["media"]["external_id"].stringValue
                mediaItem.providerName = json["data"]["media"]["provider"].stringValue
                mediaItem.relatedItems = []
                mediaItem.duration = json["data"]["media"]["base_media"]["duration"].intValue
                self.delegate?.didPlayEnd(mediaItem, durationSeconds: json["data"]["duration"].intValue)
                break;
            case "socialShare":
                let mediaItem = WebyclipMedia()
                mediaItem.mediaId = json["data"]["media"]["external_id"].stringValue
                mediaItem.providerName = json["data"]["media"]["provider"].stringValue
                mediaItem.relatedItems = []
                mediaItem.duration = json["data"]["media"]["base_media"]["duration"].intValue
                self.delegate?.didSocialShare(mediaItem, socialNetwork: json["data"]["network"].stringValue)
                break;
                
            default: break
            }
        }
    }
    
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //if webView != nil {
           // webView?.navigationDelegate = nil
        //}
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

// MARK: - YTPlayerViewDelegate
extension WebyclipPlayerController: YTPlayerViewDelegate {
    public func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.Buffering:
            print("buffering")
            break
        case YTPlayerState.Unstarted:
            print("Unstarted")
            break
        case YTPlayerState.Queued:
            print("Ready to play")
            break
        case YTPlayerState.Playing:
            print("Video playing")
            break
        case YTPlayerState.Paused:
            print("Video paused")
            break
        default:
            break
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipPlayerController: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias!.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! WebyclipPlayerCollectionViewCell
        print(indexPath.item)
        cell.media = self.medias![indexPath.item]
        cell.mediaPlayer.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipPlayerController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.cellHeight = collectionView.bounds.size.height * 0.85
        return CGSizeMake(collectionView.bounds.size.width, self.cellHeight!)
    }
}

// MARK: - UICollectionViewDelegate
extension WebyclipPlayerController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.player?.collectionViewLayout as! UICollectionViewFlowLayout
        var offset = targetContentOffset.memory
        let index = (offset.y + scrollView.contentInset.top)  / self.cellHeight!
        let roundedIndex =  round(index)
        let intIndex = Int(roundedIndex)
        
        self.counter.text = String(intIndex + 1) + " of " + String(self.medias!.count)
        print("INT INDEX _ " + String(intIndex))
        //       self.playersObjects[intIndex].playVideo()
        
        
        
        offset = CGPoint(x: scrollView.contentInset.left, y: roundedIndex * self.cellHeight!)
        targetContentOffset.memory = offset
    }


}
