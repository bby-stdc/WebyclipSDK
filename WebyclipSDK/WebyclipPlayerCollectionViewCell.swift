import YouTubeiOSPlayerHelper
//import youtube_ios_player_helper

class WebyclipPlayerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOtlets
    @IBOutlet var mediaPlayer: YTPlayerView!
    @IBOutlet var mediaTitle: UILabel!
    @IBOutlet var mediaAuthor: UILabel!
    @IBOutlet var mediaProvider: UILabel!
    
    // MARK: - Private
    fileprivate var playerVars = [
        "playsinline": 1,
        "showinfo": 0,
        "modestbranding": 1,
        "rel": 0,
        "fs": 0,
        "theme": "light",
        "color": "white"
    ] as [String : Any]
    
    fileprivate func updateUI() {
        self.mediaPlayer.isUserInteractionEnabled = false
        self.mediaPlayer.load(withVideoId: self.media.mediaId, playerVars: self.playerVars)
        self.mediaTitle.text = self.media.title
        self.mediaAuthor.text = self.media.author
        self.mediaProvider.text = formatProvider(self.media.provider)
    }
    
    fileprivate func formatProvider(_ provider: String) -> String {
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
    
    fileprivate func getMediaThumbnail(_ mediaId: String) -> UIImage {
        let url = URL(string: "https://img.youtube.com/vi/" + mediaId + "/mqdefault.jpg")!
        let data = try! Data(contentsOf: url)
        return UIImage(data: data)!
    }

    // MARK: - Public
    var media: WebyclipPlayerItem! {
        didSet {
            updateUI();
        }
    }
}
