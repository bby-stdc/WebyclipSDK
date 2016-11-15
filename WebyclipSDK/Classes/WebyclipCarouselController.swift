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
    
    // MARK: - Public
    public internal(set) var session: WebyclipSession?
    public internal(set) var context: WebyclipContext?
    public internal(set) var playerController: WebyclipPlayerController?
    public internal(set) var config: WebyclipCarouselConfig?
    public var isCompact = false {
        didSet {
            guard isViewLoaded else { return }
            carousel.reloadData()
        }
    }
    
    // MARK: - Private
    internal var medias: [WebyclipCarouselItem]?
    internal var cellWidth: CGFloat?
    
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
    public init(session: WebyclipSession, context: WebyclipContext, player: WebyclipPlayerController, config: WebyclipCarouselConfig, isCompact: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.session = session
        self.context = context
        self.playerController = player
        self.medias = WebyclipCarouselItem.createCarouselItems(context.items)
        self.config = WebyclipCarouselConfig(config: config)
        self.isCompact = isCompact
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        carousel.register(UINib(nibName: "WebyclipCarouselCompactCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "WebyclipCarouselCompactCell")
        carousel.register(UINib(nibName: "WebyclipCarouselDefaultCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "WebyclipCarouselDefaultCell")
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        uiView.frame = CGRect(x: 0, y: 0, width: (view.superview?.frame.width)!, height: (view.superview?.frame.height)!)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WebyclipCarouselController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scaleFactor: CGFloat = isCompact ? 1.25 : 1.5
        
        guard let cellHeight = self.view.superview?.frame.height, let cellWidth = self.view.superview?.frame.width else {
            self.cellWidth = self.view.frame.width / scaleFactor
            return CGSize(width: self.cellWidth!, height: self.view.frame.height)
        }
        
        self.cellWidth = (cellWidth - collectionView.layoutMargins.right - collectionView.layoutMargins.left) / scaleFactor
        
        return CGSize(width: self.cellWidth!, height: cellHeight )
    }
}

// MARK: - UICollectionViewDataSource
extension WebyclipCarouselController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = isCompact ? "WebyclipCarouselCompactCell" : "WebyclipCarouselDefaultCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WebyclipCarouselCell
        
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
 
