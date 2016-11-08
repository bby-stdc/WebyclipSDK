class WebyclipPlayerItem {
    
    //MARK: - Public
    var mediaId: String
    var title: String
    var author: String
    var publishDate: String
    var provider: String
    
    init(mediaId: String, title: String, author: String, publishDate: Date, provider: String) {
        self.mediaId = mediaId
        self.title = title
        self.author = "Submitted by " + author
        self.publishDate = WebyclipPlayerItem.formatDate(publishDate)
        self.provider = provider
    }
    
    static func createCarouselItems(_ medias: [WebyclipMedia]) -> [WebyclipPlayerItem] {
        var items: [WebyclipPlayerItem] = []
        for media in medias {
            items.append(WebyclipPlayerItem(mediaId: media.mediaId, title: media.title, author: media.author, publishDate: media.publishDate as Date, provider: media.providerName))
        }
        
        return items
    }

    //MARK: - Private
    fileprivate class func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "d"
        var day = formatter.string(from: date)
        
        switch(day) {
            case "1":
                day += "st"
                break;
            case "2":
                day += "nd"
                break;
            case "3":
                day += "rd"
                break;
            default:
                day += "th"
        }
        
        return month + " " + day + ", " + year
    }
}
