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
public class JSONFeedItem: Codable, Equatable, CustomStringConvertible {
    
    /// property that holds the item identifier
    public let ID: String
    
    /// property that holds the address of the item
    public var url: URL?
    
    /// property that holds the address of an item at hand
    public var externalURL: URL?
    
    /// property that specifies an image for the item
    public var image: URL?
    
    /// property that will hold a banner image
    public var bannerImage: URL?
    
    /// property that holds the title
    public var title: String?
    
    /// property that contains the content
    public var htmlContent: String

    /// calculated property that returns content as plain text
    public var textContent: String {
        return htmlContent.stripHTML()
    }
    
    /// property that holds the summary
    public var summary: String?
    
    /// property that holds the published date
    public let DATE_PUBLISHED: Date
    
    /// property that holds the modified date
    public var dateModified: Date?
    
    /// property that contains author info
    public var author: JSONFeedAuthor?
    
    /// property that holds the tags
    public var tags: [String]
    
    /// property that holds attachments
    public var attachments: [JSONFeedAttachment]

    /// output item attributes to string
    public var description: String {
        return """
        id: \(ID)
        URL: \(url?.absoluteString ?? "Not Provided")
        External URL: \(externalURL?.absoluteString ?? "Not Provided")
        Image URL: \(image?.absoluteString ?? "Not Provided")
        Banner Image URL: \(bannerImage?.absoluteString ?? "Not Provided")
        Title: \(title ?? "Not Provided")
        Content: \(htmlContent)
        Content (Plain Text): \(textContent)
        Summary: \(summary ?? "Not Provided")
        Date Published: \(DATE_PUBLISHED)
        Date Modified: \(dateModified as Date?)
        
        Author:
        --------
        \(author?.description ?? "Unknown")
        --------

        Tags: \(tags)

        Attachments:
        ---------
        \(attachments.joinWithSeparator("\r\n\r\n"))
        ---------
        """
    }
    
    // set coding keys, so they match JSON spec
    enum CodingKeys: String, CodingKey {
        case ID = "id" , url, externalURL = "external_url", image, bannerImage = "banner_image", title, htmlContent = "content_html", textContent = "content_text", summary, DATE_PUBLISHED = "date_published", dateModified = "date_modified", author, tags, attachments
    }
    
    /** default initializer to create a JSONFeedItem
     - Parameters:
        - id: sets the identifier (required).
        - url: sets the url for the item (required).
        - externalURL: used to specify the location of the subject (optional).
        - image: sets item's image (optional).
        - bannerImage: sets a banner image for the item.
        - title: sets the item's title (optional).
        - htmlContent: set item's content (required).
        - summary: set summary of item (optional).
        - datePublished: specifies publication date (required).
        - dateModified: specifies the date an item was modified (optional).
        - author: sets the author of an item (optional).
        - tags: set tags for item (optional. defaults to empty String array).
        - attachments: set attachments for item (optional. defaults to empty JSONFeedAttachment array).
    */
    public init(withID id: String, url: URL? = nil, externalURL: URL? = nil, image: URL? = nil, bannerImage: URL? = nil, title: String? = nil, htmlContent: String, summary: String? = nil, datePublished: Date, dateModified: Date? = nil, author: JSONFeedAuthor? = nil, tags: [String] = [String](), attachments: [JSONFeedAttachment] = [JSONFeedAttachment]()) {
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
    public required convenience init(from decoder: Decoder) throws {
        // set up RFC3339 date formatter, with timezone set for user's current locale and timezone.
        let RFC3339_DATE_FORMATTER = ISO8601DateFormatter()
        RFC3339_DATE_FORMATTER.timeZone = TimeZone.current
        RFC3339_DATE_FORMATTER.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
        
        // create container
        let CONTAINER = try decoder.container(keyedBy: CodingKeys.self)
        
        // retrieve id
        let ID = try CONTAINER.decode(String.self, forKey: .ID)
        
        // retrieve URL for item, if present
        var url: URL? = nil 
        
        if CONTAINER.contains(.url) {
            url = try CONTAINER.decode(URL.self, forKey: .url)
        }
        
        
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
        
        // retrieve title, if present
        var title: String? = nil

        if CONTAINER.contains(.title) {
            title = try CONTAINER.decode(String.self, forKey: .title)
        } 
        
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
        self.init(withID: ID, url: url, externalURL: externalURL, image: image, bannerImage: bannerImage, title: title, htmlContent: HTML_CONTENT, summary: summary, datePublished: datePublished, dateModified: revisedDate, author: author, tags: tags, attachments: attachments)
    }
    
    public static func ==(lhs: JSONFeedItem, rhs: JSONFeedItem) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    // custom encoding function, to make sure date format is right and only the necessary data is present in JSON
    public func encode(to encoder: Encoder) throws {
        // set up RFC3339 date formatter
        let RFC3339_DATE_FORMATTER = ISO8601DateFormatter()
        RFC3339_DATE_FORMATTER.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone]
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(ID, forKey: .ID)

        if let url = url {
            try container.encode(url, forKey: .url)
        }
        
        if let externalURL = externalURL {
            try container.encode(externalURL, forKey: .externalURL)
        }
        
        if let image = image {
            try container.encode(image, forKey: .image)
        }
        
        if let bannerImage = bannerImage {
            try container.encode(bannerImage, forKey: .bannerImage)
        }
        
        if let title = title {
            try container.encode(title, forKey: .title)
        }

        try container.encode(htmlContent, forKey: .htmlContent)
        try container.encode(textContent, forKey: .textContent)
        
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

// create extension, so that items can be combined into strings easily
extension Sequence where Iterator.Element == JSONFeedItem {
    func joinWithSeparator(_ separator: String) -> String {
        return self.reduce(into: "") {(output, item) in
            if let lastElement = Array(self).last {
                if item == lastElement {
                    output += "\(item)"
                } else {
                    output += "\(item)\(separator)"
                }
            }
        }
    }
}
