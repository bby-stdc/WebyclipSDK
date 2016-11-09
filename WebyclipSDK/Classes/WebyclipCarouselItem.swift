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
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            items?.append(WebyclipCarouselItem(mediaImage: image, title: media.title))
        }
        
        return items!
    }
}
