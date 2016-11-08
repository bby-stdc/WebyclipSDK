import UIKit
import SwiftyJSON
import WebKit
import YouTubeiOSPlayerHelper

/**
 The Webyclip's Player controller
 */
open class WebyclipPlayerController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var counter: UILabel!
    @IBOutlet var player: UICollectionView!
    @IBOutlet var disclaimer: UIView!
    
    // MARK: - IBActions
    @IBAction func closeButtonHandler(_ sender: AnyObject) {
        closeView()
    }
    
    @IBAction func disclaimerHandler(_ sender: AnyObject) {
        showHideDisclaimer()
    }
    
    @IBAction func disclaimerCloseButtonHandler(_ sender: AnyObject) {
        showHideDisclaimer()
    }
    
    // MARK: - Private
    fileprivate var session: WebyclipSession?
    fileprivate var context: WebyclipContext?
    fileprivate var cellHeight: CGFloat?
    fileprivate var initialIndex: Int? = 0
    fileprivate var currentIndex: Int? = 0
    fileprivate var medias: [WebyclipPlayerItem]?
    
    fileprivate struct View {
        static let CellIdentifier = "WebyClip Player Cell"
    }
    
    fileprivate func showHideDisclaimer() {
        self.disclaimer.isHidden = !self.disclaimer.isHidden
    }
    
    fileprivate func closeView() {
        UIApplication.shared.statusBarStyle = .default
        let cell = getActiveCell()
        cell.mediaPlayer.alpha = 0.15
        cell.mediaPlayer.stopVideo()
        
        self.initialIndex = 0
        self.currentIndex = 0
        self.view.removeFromSuperview()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WebyclipPlayer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    fileprivate func getActiveCell() -> WebyclipPlayerCollectionViewCell {
        let cells = self.player?.visibleCells as! [WebyclipPlayerCollectionViewCell]
        let idx = cells.index(where: {
            $0.media.mediaId == self.medias![self.currentIndex!].mediaId
        })
        
        return cells[idx!]
    }
    
    // MARK: - Public
    
    /// Delegate for getting callbacks
    open var delegate: WebyclipPlayerProtocol?

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
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
       
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        self.player.register(UINib(nibName: "WebyclipPlayerCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: View.CellIdentifier)
        
        self.uiView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        self.counter.text = String(self.initialIndex! + 1) + " of " + String(self.medias!.count)
        self.currentIndex = self.initialIndex
        self.player?.scrollToItem(at: IndexPath(item: self.initialIndex!, section: 0), at: .top, animated: false)
    }
    
    /**
     Open player frame
     
     - parameter WebyclipMedia?:    initial media object `WebyclipMedia` for showing. Pass nil for starting from the beginning
     */
    open func openPlayer(_ media: WebyclipMedia?) {
        print("PLAY")
        if media == nil {
            self.initialIndex = 0
        }
        else {
            self.initialIndex = self.context!.items.index(where: {
                $0.mediaId == media!.mediaId
            })
        }
        
        let window = UIApplication.shared.keyWindow
        window!.addSubview(self.view)
    }
}

// MARK: - YTPlayerViewDelegate
extension WebyclipPlayerController: YTPlayerViewDelegate {
    public func playerView(_ playerView: YTPlayerView!, didChangeTo state: YTPlayerState) {
        switch(state) {
        case YTPlayerState.buffering:
            break
        case YTPlayerState.unstarted:
            break
        case YTPlayerState.queued:
            break
        case YTPlayerState.playing:
            break
        case YTPlayerState.paused:
            break
        default:
            break
        }
    }
    
    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        let cell = getActiveCell()
        cell.mediaPlayer.alpha = 1
        cell.mediaPlayer.playVideo()
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipPlayerController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias!.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: View.CellIdentifier, for: indexPath) as! WebyclipPlayerCollectionViewCell
        
        cell.media = self.medias![indexPath.item]
        cell.mediaPlayer.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipPlayerController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.cellHeight = collectionView.bounds.size.height * 0.85
        return CGSize(width: collectionView.bounds.size.width, height: self.cellHeight!)
    }
}

// MARK: - UICollectionViewDelegate
extension WebyclipPlayerController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.player?.collectionViewLayout as! UICollectionViewFlowLayout
        var offset = targetContentOffset.pointee
        let index = (offset.y + scrollView.contentInset.top)  / self.cellHeight!
        let roundedIndex =  round(index)
        let intIndex = Int(roundedIndex)
        
        self.counter.text = String(intIndex + 1) + " of " + String(self.medias!.count)
        self.currentIndex = intIndex
        
        if let cell = self.player?.cellForItem(at: IndexPath(item: intIndex, section: 0)) {
            let wcCell = cell as! WebyclipPlayerCollectionViewCell
            wcCell.mediaPlayer.alpha = 1
            wcCell.mediaPlayer.playVideo()
        }
        
        offset = CGPoint(x: scrollView.contentInset.left, y: roundedIndex * self.cellHeight!)
        targetContentOffset.pointee = offset
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for view in self.player.visibleCells as! [WebyclipPlayerCollectionViewCell] {
            view.mediaPlayer.alpha = 0.15
        }
    }
}
