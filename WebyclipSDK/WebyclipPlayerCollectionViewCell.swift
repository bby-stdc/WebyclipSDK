import YouTubeiOSPlayerHelper

class WebyclipPlayerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOtlets
    @IBOutlet var mediaPlayer: YTPlayerView!
    @IBOutlet var mediaTitle: UILabel!
    @IBOutlet var mediaAuthor: UILabel!
    @IBOutlet var mediaProvider: UILabel!
    
     // MARK: - Private
    private var playerVars = [
        "playsinline": 1,
        "showinfo": 0,
        "modestbranding": 1,
        "rel": 0,
        "fs": 0,
        "theme": "light",
        "color": "white"
        
    ]
    
    private func updateUI() {
        self.mediaPlayer.loadWithVideoId(self.media.mediaId, playerVars: self.playerVars)
        self.mediaTitle.text = self.media.title
        self.mediaAuthor.text = self.media.author
        self.mediaProvider.text = formatProvider(self.media.provider)
    }
    
    private func formatProvider(provider: String) -> String {
        let prv: String
        switch(provider) {
            case "youtube":
                prv = "YouTube"
                break;
            default:
                prv = "Unknown provider"
        }
        
        return prv;
    }
    
    private func getMediaThumbnail(mediaId: String) -> UIImage {
        let url = NSURL(string: "https://img.youtube.com/vi/" + mediaId + "/mqdefault.jpg")!
        let data = NSData(contentsOfURL: url)!
        return UIImage(data: data)!
    }

    // MARK: - Public
    var media: WebyclipPlayerItem! {
        didSet {
            updateUI();
        }
    }
}
