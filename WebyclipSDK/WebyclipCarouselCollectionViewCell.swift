class WebyclipCarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOtlets
    @IBOutlet var mediaThumbnail: UIButton!
    @IBOutlet var mediaTitle: UILabel!
    
    // MARK: - IBActions
    @IBAction func openPlayerHandler(sender: AnyObject) {
        self.clickDelegate!()
    }
    
    // MARK: - Private
    private func updateUI() {
        mediaTitle?.text! = media.title
        mediaThumbnail?.setBackgroundImage(media.mediaImage, forState: .Normal)
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
