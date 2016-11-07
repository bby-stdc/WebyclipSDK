import UIKit
import SwiftyJSON
import WebKit
import YouTubeiOSPlayerHelper

/**
 The Webyclip's Player controller
 */
public class WebyclipPlayerController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var counter: UILabel!
    @IBOutlet var player: UICollectionView!
    @IBOutlet var disclaimer: UIView!
    
    // MARK: - IBActions
    @IBAction func closeButtonHandler(sender: AnyObject) {
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
    private var cellHeight: CGFloat?
    private var initialIndex: Int? = 0
    private var currentIndex: Int? = 0
    private var medias: [WebyclipPlayerItem]?
    
    private struct View {
        static let CellIdentifier = "WebyClip Player Cell"
    }
    
    private func showHideDisclaimer() {
        self.disclaimer.hidden = !self.disclaimer.hidden
    }
    
    private func closeView() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        let cell = getActiveCell()
        cell.mediaPlayer.alpha = 0.15
        cell.mediaPlayer.stopVideo()
        
        self.initialIndex = 0
        self.currentIndex = 0
        self.view.removeFromSuperview()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WebyclipPlayer", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func getActiveCell() -> WebyclipPlayerCollectionViewCell {
        let cells = self.player?.visibleCells() as! [WebyclipPlayerCollectionViewCell]
        let idx = cells.indexOf({
            $0.media.mediaId == self.medias![self.currentIndex!].mediaId
        })
        
        return cells[idx!]
    }
    
    // MARK: - Public
    
    /// Delegate for getting callbacks
    public var delegate: WebyclipPlayerProtocol?

    /**
     Initializes WebyclipPlayerController with `WebyclipSession` and `WebyclipContext`
     */
    public init(session: WebyclipSession, context: WebyclipContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
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
        
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        self.player.registerNib(UINib(nibName: "WebyclipPlayerCell", bundle: NSBundle(forClass: self.dynamicType)), forCellWithReuseIdentifier: View.CellIdentifier)
        
        self.uiView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
    }
    
    public override func viewDidAppear(animated: Bool) {
        self.counter.text = String(self.initialIndex! + 1) + " of " + String(self.medias!.count)
        self.currentIndex = self.initialIndex
        self.player?.scrollToItemAtIndexPath(NSIndexPath(forItem: self.initialIndex!, inSection: 0), atScrollPosition: .Top, animated: false)
    }
    
    public func openPlayer(media: WebyclipMedia?) {
        print("PLAY")
        if media == nil {
            self.initialIndex = 0
        }
        else {
            self.initialIndex = self.context!.items.indexOf({
                $0.mediaId == media!.mediaId
            })
        }
        
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(self.view)
    }
}

// MARK: - YTPlayerViewDelegate
extension WebyclipPlayerController: YTPlayerViewDelegate {
    public func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.Buffering:
            break
        case YTPlayerState.Unstarted:
            break
        case YTPlayerState.Queued:
            break
        case YTPlayerState.Playing:
            break
        case YTPlayerState.Paused:
            break
        default:
            break
        }
    }
    
    public func playerViewDidBecomeReady(playerView: YTPlayerView) {
        let cell = getActiveCell()
        cell.mediaPlayer.alpha = 1
        cell.mediaPlayer.playVideo()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(View.CellIdentifier, forIndexPath: indexPath) as! WebyclipPlayerCollectionViewCell
        
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
        self.currentIndex = intIndex
        
        if let cell = self.player?.cellForItemAtIndexPath(NSIndexPath(forItem: intIndex, inSection: 0)) {
            let wcCell = cell as! WebyclipPlayerCollectionViewCell
            wcCell.mediaPlayer.alpha = 1
            wcCell.mediaPlayer.playVideo()
        }
        
        offset = CGPoint(x: scrollView.contentInset.left, y: roundedIndex * self.cellHeight!)
        targetContentOffset.memory = offset
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        for view in self.player.visibleCells() as! [WebyclipPlayerCollectionViewCell] {
            view.mediaPlayer.alpha = 0.15
        }
    }
}
