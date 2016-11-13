open class WebyclipCarouselCompactController: WebyclipCarouselBaseController {

     public override init(session: WebyclipSession, context: WebyclipContext, player: WebyclipPlayerController, config: WebyclipCarouselConfig) {
        super.init(session: session, context: context, player: player, config: config)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        self.carousel.register(UINib(nibName: "WebyclipCarouselCompactCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "WebyClip Carousel Compact Cell")
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellHeight = self.view.superview?.frame.height, let cellWidth = self.view.superview?.frame.width else {
            self.cellWidth = self.view.frame.width / 1.25
            return CGSize(width: self.cellWidth!, height: self.view.frame.height)
        }
        
        self.cellWidth = (cellWidth - collectionView.layoutMargins.right - collectionView.layoutMargins.left) / 1.25
        
        return CGSize(width: self.cellWidth!, height: cellHeight )
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebyClip Carousel Compact Cell", for: indexPath) as! WebyclipCarouselCell
        
        cell.media = self.medias![indexPath.item]
        cell.clickDelegate = {
            let media = self.context!.items[indexPath.item]
            self.delegate?.didClick(media)
            self.playerController!.openPlayer(media)
        }
        
        return cell
    }
}
