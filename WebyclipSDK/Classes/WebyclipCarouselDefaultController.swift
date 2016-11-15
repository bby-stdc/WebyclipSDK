open class WebyclipCarouselDefaultController: WebyclipCarouselBaseController {

     public override init(session: WebyclipSession, context: WebyclipContext, player: WebyclipPlayerController, config: WebyclipCarouselConfig) {
        super.init(session: session, context: context, player: player, config: config)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        let view = loadViewFromNib()
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        self.carousel.register(UINib(nibName: "WebyclipCarouselDefaultCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "WebyClip Carousel Default Cell")
    }
    
    public override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellHeight = self.view.superview?.frame.height, let cellWidth = self.view.superview?.frame.width else {
            self.cellWidth = self.view.frame.width / 1.5
            return CGSize(width: self.cellWidth!, height: self.view.frame.height)
        }
        
        self.cellWidth = (cellWidth - collectionView.layoutMargins.right - collectionView.layoutMargins.left) / 1.5
        
        return CGSize(width: self.cellWidth!, height: cellHeight )
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebyClip Carousel Default Cell", for: indexPath) as! WebyclipCarouselCell
        
        cell.media = self.medias![indexPath.item]
        cell.clickDelegate = {
            let media = self.context!.items[indexPath.item]
            self.delegate?.didClick(media)
            self.playerController!.openPlayer(media)
        }
        
        return cell
    }
}
