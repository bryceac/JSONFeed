import Foundation

/// enumeration to specify version of feed easily
public enum JSONFeedVersion: String, Codable {
    case version1 = "https://jsonfeed.org/version/1"
}

/** used to hold data concerning JSON feed, and holds methods to generate and read them.
 
 For more information regarding JSON Feeds and best practices, refer to the [JSON Feed spec.](https://jsonfeed.org/version/1)
 */
public class JSONFeed: Codable {
    
    /// feed version
    var version: JSONFeedVersion
    
    /// feed title
    var title: String
    
    /// website URL
    var homePage: URL?
    
    /// feed URL
    var url: URL?
    
    /// icon URL
    var icon: URL?
    
    /// favicon URL
    var favicon: URL?
    
    /// feed author struct
    var author: JSONFeedAuthor
    
    /// feed description
    var desc: String?
    
    /// user comments for feed
    var comments: String?
    
    /// status of feed's life
    var expired: Bool
    
    /// feed items
    var items: [JSONFeedItem]
    
    enum CodingKeys: String, CodingKey {
        case version, title, homePage = "home_page_url", url = "feed_url", icon, favicon, author, desc = "description", comments = "user_comment", expired, items
    }
    
    /** default initializer
     - Parameters:
        - version: specifies version of JSON feed (optional. Defaults to version 1).
        - title: specifies feed title (required).
        - homePage: specifies the address of the website (optional).
        - url: specifies feed url (optional).
        - icon: specifies feed icon (optional).
        - favicon: specifies feed favicon (optional).
        - author: specifies author info (required).
        - desc: specifies a description of the feed (optional).
        - comments: specify comments people will see in output (optional).
        - expired: specifies whether feed is active or not (optional. defaults to false)
        - items: specifies feed items (optional. defaults to empty JSONFeedItem array).
     */
    public init!(withVersion version: JSONFeedVersion = JSONFeedVersion.version1, title: String, homePage: URL? = nil, url: URL? = nil, icon: URL? = nil, favicon: URL? = nil, author: JSONFeedAuthor, desc: String? = nil, comments: String? = nil, expired: Bool = false, items: [JSONFeedItem] = [JSONFeedItem]()) {
        guard !title.isEmpty else { return nil }
        self.version = version
        self.title = title
        self.homePage = homePage
        self.url = url
        self.icon = icon
        self.favicon = favicon
        self.author = author
        self.desc = desc
        self.comments = comments
        self.expired = expired
        self.items = items
    }
    
    /** type method that can load local JSON feed
     - Parameter url: URL of feed.
     - Returns: JSONFeed?
    */
    public class func load(from url: URL) -> JSONFeed? {
        
        // create decoder object
        let JSON_DECODER = JSONDecoder()
        
        // try to retrieve data and decode it into JSONFeed object
        guard let jsonData = try? Data(contentsOf: url), let FEED = try? JSON_DECODER.decode(JSONFeed.self, from: jsonData) else { return nil }
        
        return FEED
    }
    
    /**
     type method that can load JSON from data, which is best used for decoding remote json.
     - Parameter data: Data to be decoded into JSON Feed
     - Returns: JSONFeed?
    */
    public class func load(from data: Data) -> JSONFeed? {
        
        // create decoder object.
        let JSON_DECODER = JSONDecoder()
        
        // try to decode data into JSONFeed object
        guard let FEED = try? JSON_DECODER.decode(JSONFeed.self, from: data) else { return nil }
        
        return FEED
    }
    
    // function to convert feed to data in JSON format
    private func json() -> Data? {
        
        // create encoder object
        let JSON_ENCODER = JSONEncoder()
        
        // make JSON easy for humans to read
        JSON_ENCODER.outputFormatting = .prettyPrinted
        
        // attempt to encode data to JSON and convert it to a string
        guard let JSON = try? JSON_ENCODER.encode(self) else { return nil }
        
        return JSON
    }
    
    /**
     method to retrieve JSON feed as string.
     - Returns: String?
    */
    public func display() -> String? {
        guard let JSON_DATA = json(), let CONTENT = String(data: JSON_DATA, encoding: .utf8) else { return nil }
        
        return CONTENT
    }
    
    /**
     method to save JSON feed somewhere.
     - Parameter path: the location where the JSON file is to be saved.
    */
    public func save(to path: URL) {
        guard let JSON_DATA = json() else { return }
        
        try? JSON_DATA.write(to: path, options: .atomic)
    }
}
