class WebyclipPlayerItem {
    
    //MARK: - Public
    var mediaId: String
    var title: String
    var author: String
    var publishDate: String
    var provider: String
    
    init(mediaId: String, title: String, author: String, publishDate: NSDate, provider: String) {
        self.mediaId = mediaId
        self.title = title
        self.author = "Submitted by " + author
        self.publishDate = WebyclipPlayerItem.formatDate(publishDate)
        self.provider = provider
    }
    
    static func createCarouselItems(medias: [WebyclipMedia]) -> [WebyclipPlayerItem] {
        var items: [WebyclipPlayerItem] = []
        for media in medias as! [WebyclipMedia] {
            let url = NSURL(string: "https://img.youtube.com/vi/" + media.mediaId + "/mqdefault.jpg")!
            let data = NSData(contentsOfURL: url)!
            let image = UIImage(data: data)
            items.append(WebyclipPlayerItem(mediaId: media.mediaId, title: media.title, author: media.author, publishDate: media.publishDate, provider: media.providerName))
        }
        
        return items
    }

    //MARK: - Private
    private class func formatDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "MMMM"
        let month = formatter.stringFromDate(date)
        
        formatter.dateFormat = "yyyy"
        let year = formatter.stringFromDate(date)
        
        formatter.dateFormat = "d"
        var day = formatter.stringFromDate(date)
        
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