class WebyclipCarouselItem {
    
    // MARK: - Public
    var mediaImage: UIImage!
    var title = ""

    init(mediaImage: UIImage!, title: String) {
        self.mediaImage = mediaImage
        self.title = title
    }
    
    static func createCarouselItems(_ medias: [WebyclipMedia]) -> [WebyclipCarouselItem] {
        var items: [WebyclipCarouselItem]? = []
        for media in medias {
            let url = URL(string: "https://img.youtube.com/vi/" + media.mediaId + "/mqdefault.jpg")!
            guard let data = try? Data(contentsOf: url) else {
                debugPrint("ERROR: \(#file):(\(#line)) Unable to load carousel item: \(url.absoluteString)")
                continue
            }
            let image = UIImage(data: data)
            items?.append(WebyclipCarouselItem(mediaImage: image, title: media.title))
        }
        
        return items!
    }
}
