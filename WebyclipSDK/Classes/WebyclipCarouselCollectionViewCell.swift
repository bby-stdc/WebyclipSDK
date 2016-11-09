class WebyclipCarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOtlets
    @IBOutlet var mediaThumbnail: UIButton!
    @IBOutlet var mediaTitle: UILabel!
    
    // MARK: - IBActions
    @IBAction func openPlayerHandler(_ sender: AnyObject) {
        self.clickDelegate!()
    }
    
    // MARK: - Private
    fileprivate func updateUI() {
        mediaTitle?.text! = media.title
        mediaThumbnail?.setBackgroundImage(media.mediaImage, for: UIControlState())
    }
    
    // MARK: - Public
    var index: Int?
    var player: WebyclipPlayerController?
    var clickDelegate: (()->Void)?

    var media: WebyclipCarouselItem! {
        didSet {
            updateUI();
        }
    }
}
