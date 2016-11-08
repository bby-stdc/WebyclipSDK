import UIKit
import SwiftyJSON
import WebKit

/**
 Controller object of the Webyclip thumbnails carousel
*/
open class WebyclipCarouselController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var carousel: UICollectionView!
    
    // MARK: - Private
    fileprivate var session: WebyclipSession?
    fileprivate var context: WebyclipContext?
    fileprivate var playerController: WebyclipPlayerController?
    fileprivate var medias: [WebyclipCarouselItem]?
    fileprivate var cellWidth: CGFloat?
    
    fileprivate struct View {
        static let CellIdentifier = "WebyClip Carousel Cell"
    }
    
    fileprivate func loadViewFromNib() -> UIView {
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
    public init(session: WebyclipSession, context: WebyclipContext, player: WebyclipPlayerController) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
        self.playerController = player
        self.medias = WebyclipCarouselItem.createCarouselItems(context.items)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = loadViewFromNib()
        self.view.addSubview(view)
        self.carousel.register(UINib(nibName: "WebyclipCarouselCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: View.CellIdentifier)
        
        self.uiView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipCarouselController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.cellWidth = self.view.frame.width / 1.5
        return CGSize(width: cellWidth!, height: collectionView.bounds.size.height)
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipCarouselController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias!.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: View.CellIdentifier, for: indexPath) as! WebyclipCarouselCollectionViewCell
        
        cell.media = self.medias![indexPath.item]
        cell.clickDelegate = {
            let media = self.context!.items[indexPath.item]
            self.delegate?.didClick(media)
            self.playerController!.openPlayer(media)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WebyclipCarouselController: UIScrollViewDelegate {
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
 
