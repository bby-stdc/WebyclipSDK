import UIKit
import SwiftyJSON
import WebKit

/**
 Controller object of the Webyclip thumbnails carousel
*/
public class WebyclipCarouselController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var uiView: UIView!
    @IBOutlet var carousel: UICollectionView!
    
    // MARK: - Private
    private var session: WebyclipSession?
    private var context: WebyclipContext?
    private var playerController: WebyclipPlayerController?
    private var medias: [WebyclipCarouselItem]?
    private var cellWidth: CGFloat?
    
    private struct View {
        static let CellIdentifier = "WebyClip Carousel Cell"
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "WebyclipCarousel", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    // MARK: - Public
    
    /// Delegate for getting callbacks
    public var delegate: WebyclipCarouselProtocol?

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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = loadViewFromNib()
        self.view.addSubview(view)
        self.carousel.registerNib(UINib(nibName: "WebyclipCarouselCell", bundle: NSBundle(forClass: self.dynamicType)), forCellWithReuseIdentifier: View.CellIdentifier)
        
        self.uiView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipCarouselController: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        self.cellWidth = self.view.frame.width / 1.5
        return CGSizeMake(cellWidth!, collectionView.bounds.size.height)
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipCarouselController: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias!.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(View.CellIdentifier, forIndexPath: indexPath) as! WebyclipCarouselCollectionViewCell
        
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
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.carousel?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = self.cellWidth! + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        let index = offset.x / self.cellWidth!
        let roundedIndex =  round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing, y: 0)

        targetContentOffset.memory = offset
    }
}
 