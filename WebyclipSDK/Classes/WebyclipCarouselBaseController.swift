import UIKit
import SwiftyJSON
import WebKit

/**
 Controller object of the Webyclip thumbnails carousel
*/
open class WebyclipCarouselBaseController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var carousel: UICollectionView!
    
    // MARK: - Private
    internal var session: WebyclipSession?
    internal var context: WebyclipContext?
    internal var playerController: WebyclipPlayerController?
    internal var medias: [WebyclipCarouselItem]?
    internal var cellWidth: CGFloat?
    internal var config: WebyclipCarouselConfig?
    
    internal func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WebyclipCarousel", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    // MARK: - Public
    
    /// Delegate for getting callbacks
    open var delegate: WebyclipCarouselProtocol?

    /**
     Initializes WebyclipCarouselController with `WebyclipSession` and `WebyclipContext`
     */
    public init(session: WebyclipSession, context: WebyclipContext, player: WebyclipPlayerController, config: WebyclipCarouselConfig) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
        self.playerController = player
        self.medias = WebyclipCarouselItem.createCarouselItems(context.items)
        self.config = WebyclipCarouselConfig(config: config)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        self.uiView.frame = CGRect(x: 0, y: 0, width: (self.view.superview?.frame.width)!, height: (self.view.superview?.frame.height)!)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipCarouselBaseController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize()
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipCarouselBaseController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias!.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension WebyclipCarouselBaseController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.carousel?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = self.cellWidth! + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = offset.x / self.cellWidth!
        let roundedIndex =  round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing, y: 0)

        targetContentOffset.pointee = offset
    }
}
 
