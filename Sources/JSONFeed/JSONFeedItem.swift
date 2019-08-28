//
//  JSONFeedItem.swift
//  JSONFeed
//
//  Created by Bryce Campbell on 8/27/19.
//

import Foundation

/** houses details concerning a feed item in JSON
 For details regarding Feed Items, look under the Items section of the [JSON Feed spec.](https://jsonfeed.org/version/1)
 */
class JSONFeedItem: Codable, Equatable {
    
    /// property that holds the item identifier
    let ID: String
    
    /// property that holds the address of the item
    var url: URL
    
    /// property that holds the address of an item at hand
    var externalURL: URL?
    
    /// property that specifies an image for the item
    var image: URL?
    
    /// property that will hold a banner image
    var bannerImage: URL?
    
    /// property that holds the title
    var title: String
    
    /// property that contains the content
    var htmlContent: String
    
    /// property that holds the summary
    var summary: String?
    
    /// property that holds the published date
    let DATE_PUBLISHED: Date
    
    /// property that holds the modified date
    var dateModified: Date?
    
    /// property that contains author info
    var author: JSONFeedAuthor?
    
    /// property that holds the tags
    var tags: [String]
    
    /// property that holds attachments
    var attachments: [JSONFeedAttachment]
    
    // set coding keys, so they match JSON spec
    enum CodingKeys: String, CodingKey {
        case ID = "id" , url, externalURL = "external_url", image, bannerImage = "banner_image", title, htmlContent = "content_html", summary, DATE_PUBLISHED = "date_published", dateModified = "date_modified", author, tags, attachments
    }
    
    /** default initializer to create a JSONFeedItem
     - Parameters:
        - id: sets the identifier (required).
        - url: sets the url for the item (required).
        - externalURL: used to specify the location of the subject (optional).
        - image: sets item's image (optional).
        - bannerImage: sets a banner image for the item.
        - title: sets the item's title (required).
        - htmlContent: set item's content (required).
        - summary: set summary of item (optional).
        - datePublished: specifies publication date (required).
        - dateModified: specifies the date an item was modified (optional).
        - author: sets the author of an item (optional).
        - tags: set tags for item (optional. defaults to empty String array).
        - attachments: set attachments for item (optional. defaults to empty JSONFeedAttachment array).
    */
    init(withID id: String, url: URL, externalURL: URL? = nil, image: URL? = nil, bannerImage: URL? = nil, title: String, htmlContent: String, summary: String? = nil, datePublished: Date, dateModified: Date? = nil, author: JSONFeedAuthor? = nil, tags: [String] = [String](), attachments: [JSONFeedAttachment] = [JSONFeedAttachment]()) {
        ID = id
        self.url = url
        self.externalURL = externalURL
        self.image = image
        self.bannerImage = bannerImage
        self.title = title
        self.htmlContent = htmlContent
        self.summary = summary
        DATE_PUBLISHED = datePublished
        self.dateModified = dateModified
        self.author = author
        self.tags = tags
        self.attachments = attachments
    }
    
    // add initializer, to allow relaxed decoding
    required convenience init(from decoder: Decoder) throws {
        // set up RFC3339 date formatter
        let RFC3339_DATE_FORMATTER = DateFormatter()
        RFC3339_DATE_FORMATTER.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        // create container
        let CONTAINER = try decoder.container(keyedBy: CodingKeys.self)
        
        // retrieve id
        let ID = try CONTAINER.decode(String.self, forKey: .ID)
        
        // retrieve URL
        let ITEM_URL = try CONTAINER.decode(URL.self, forKey: .url)
        
        // retrieve external URL, if one is present
        var externalURL: URL? = nil
        
        if CONTAINER.contains(.externalURL) {
            externalURL = try CONTAINER.decode(URL.self, forKey: .externalURL)
        }
        
        // retrieve image URL, if one is present
        var image: URL? = nil
        
        if CONTAINER.contains(.image) {
            image = try CONTAINER.decode(URL.self, forKey: .image)
        }
        
        // retrieve banner image URL, if present
        var bannerImage: URL? = nil
        
        if CONTAINER.contains(.bannerImage) {
            bannerImage = try CONTAINER.decode(URL.self, forKey: .bannerImage)
        }
        
        // retrieve title
        let TITLE = try CONTAINER.decode(String.self, forKey: .title)
        
        // retrieve content
        let HTML_CONTENT = try CONTAINER.decode(String.self, forKey: .htmlContent)
        
        // retrieve summary, if present
        var summary: String? = nil
        
        if CONTAINER.contains(.summary) {
            summary = try CONTAINER.decode(String.self, forKey: .summary)
        }
        
        // retrieve publication date
        let DATE_CREATED = try CONTAINER.decode(String.self, forKey: .DATE_PUBLISHED)
        
        var datePublished: Date = Date()
        
        if let CREATION_DATE = RFC3339_DATE_FORMATTER.date(from: DATE_CREATED) {
            datePublished = CREATION_DATE
        }
        
        // retrieve modification date, if present
        var dateModified: String? = nil
        
        if CONTAINER.contains(.dateModified) {
            dateModified = try CONTAINER.decode(String.self, forKey: .dateModified)
        }
        
        var revisedDate: Date? = nil
        
        if let MODIFIED_DATE = dateModified, let MODIFICATION_DATE = RFC3339_DATE_FORMATTER.date(from: MODIFIED_DATE) {
            revisedDate = MODIFICATION_DATE
        }
        
        // retrieve author, if present
        var author: JSONFeedAuthor? = nil
        
        if CONTAINER.contains(.author) {
            author = try CONTAINER.decode(JSONFeedAuthor.self, forKey: .author)
        }
        
        // retrieve tags, if present
        var tags: [String] = []
        
        if CONTAINER.contains(.tags) {
            tags = try CONTAINER.decode([String].self, forKey: .tags)
        }
        
        // retrieve tags, if present
        var attachments: [JSONFeedAttachment] = []
        
        if CONTAINER.contains(.attachments) {
            attachments = try CONTAINER.decode([JSONFeedAttachment].self, forKey: .attachments)
        }
        
        // create JSONFeedItem with the retrieved data
        self.init(withID: ID, url: ITEM_URL, externalURL: externalURL, image: image, bannerImage: bannerImage, title: TITLE, htmlContent: HTML_CONTENT, summary: summary, datePublished: datePublished, dateModified: revisedDate, author: author, tags: tags, attachments: attachments)
    }
    
    static func ==(lhs: JSONFeedItem, rhs: JSONFeedItem) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    // custom encoding function, to make sure date format is right and only the necessary data is present in JSON
    func encode(to encoder: Encoder) throws {
        // set up RFC3339 date formatter
        let RFC3339_DATE_FORMATTER = DateFormatter()
        RFC3339_DATE_FORMATTER.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(ID, forKey: .ID)
        try container.encode(url, forKey: .url)
        
        if let externalURL = externalURL {
            try container.encode(externalURL, forKey: .externalURL)
        }
        
        if let image = image {
            try container.encode(image, forKey: .image)
        }
        
        if let bannerImage = bannerImage {
            try container.encode(bannerImage, forKey: .bannerImage)
        }
        
        try container.encode(title, forKey: .title)
        try container.encode(htmlContent, forKey: .htmlContent)
        
        if let summary = summary {
            try container.encode(summary, forKey: .summary)
        }
        
        try container.encode(RFC3339_DATE_FORMATTER.string(from: DATE_PUBLISHED), forKey: .DATE_PUBLISHED)
        
        if let dateModified = dateModified {
            try container.encode(RFC3339_DATE_FORMATTER.string(from: dateModified), forKey: .dateModified)
        }
        
        if let author = author {
            try container.encode(author, forKey: .author)
        }
        
        if !tags.isEmpty {
            try container.encode(tags, forKey: .tags)
        }
        
        if !attachments.isEmpty {
            try container.encode(attachments, forKey: .attachments)
        }
    }
}
