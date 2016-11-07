class WebyclipCarouselItem {
    
    // MARK: - Public
    var mediaImage: UIImage!
    var title = ""

    init(mediaImage: UIImage!, title: String) {
        self.mediaImage = mediaImage
        self.title = title
    }
    
    static func createCarouselItems(medias: [WebyclipMedia]) -> [WebyclipCarouselItem] {
        var items: [WebyclipCarouselItem]? = []
        for media in medias as! [WebyclipMedia] {
            let url = NSURL(string: "https://img.youtube.com/vi/" + media.mediaId + "/mqdefault.jpg")!
            let data = NSData(contentsOfURL: url)!
            let image = UIImage(data: data)
            items?.append(WebyclipCarouselItem(mediaImage: image, title: media.title))
        }
        // Add fake slide for correct sliding
        items?.append(WebyclipCarouselItem(mediaImage: UIImage(), title: ""))
        
        return items!
    }
}