//
//  JSONFeedAttachment.swift
//  JSONFeed
//
//  Created by Bryce Campbell on 8/27/19.
//

import Foundation

/**Enumeration to easily specify content type for various audio visual formats.
*/
public enum MimeType: String, Codable {

    /// Wav mimetype
    case wav = "audio/wav"

    /// WebM Audio mimetype
    case webMAudio = "audio/webm"

    /// WebM Video mimetype
    case webMVideo = "video/webm"

    /// OGG Audio mimetype
    case oggAudio = "audio/ogg"

    /// OGG Video mimetype
    case oggVideo = "video/ogg"

    /// MP4 audio mimetype
    case mp4Audio = "audio/mp4"

    /// MP4 video mimetype
    case mp4Video = "video/mp4"

    /// MP3 mimetype
    case mp3 = "audio/mpeg"

    /// FLAC mimetype
    case flac = "audio/flac"

    /// AAC mimetype
    case aac = "audio/aac"
}

/** type that hold data concerning attachments in JSON feed.
 For more information regarding attachments, look under the Attachments section of the [JSON Feed spec.](https://jsonfeed.org/version/1)
 */
public class JSONFeedAttachment: Codable, Equatable, CustomStringConvertible {
    /// property that holds attachment URL.
    public var url: URL
    
    /// property that holds attachment mime type.
    public var mimeType: MimeType
    
    /// property that holds the name of the attachment
    public var title: String?
    
    /// property that holds the file's size in bytes
    public var sizeInBytes: Int?
    
    /// property that holds the duration in seconds
    public var durationInSeconds: Int?

    /// output contents of attachment to string
    public var description: String {
        return """
        URL: \(url)
        Title: \(title ?? "Not Provided")
        Size in Bytes: \(sizeInBytes ?? 0)
        Duration in seconds: \(durationInSeconds ?? 0)
        """
    }
    
    enum CodingKeys: String, CodingKey {
        case url, mimeType = "mime_type", title, sizeInBytes = "size_in_bytes", durationInSeconds = "duration_in_seconds"
    }

    /**
    default initializer.
    - Parameters: 
        - url: specifies attachment URL (required).
        - mimeType: specifies mime type for attachment (required).
        - title: specifies title for attachment (optional)
        - sizeInBytes: specficifies file size for attachment (optional).
        - durationInSeconds: specifies the attachment's duration (optional)
    */
    public init(withURL url: URL, mimeType: MimeType, title: String? = nil, sizeInBytes: Int? = nil, durationInSeconds: Int? = nil) {
        self.url = url
        self.mimeType = mimeType
        self.title = title
        self.sizeInBytes = sizeInBytes
        self.durationInSeconds = durationInSeconds
    }

    /**
    decoding initializer that is lax in what must be present in the JSON for it to decode properly.
    */
    public required convenience init(from decoder: Decoder) throws {
        let CONTAINER = try decoder.container(keyedBy: CodingKeys.self)

        let ATTACHMENT_URL = try CONTAINER.decode(URL.self, forKey: .url)
        let MIME_TYPE = try CONTAINER.decode(MimeType.self, forKey: .mimeType)

        var title: String? = nil

        if CONTAINER.contains(.title) {
            title = try CONTAINER.decode(String.self, forKey: .title)
        }

        var sizeInBytes: Int? = nil

        if CONTAINER.contains(.sizeInBytes) {
            sizeInBytes = try CONTAINER.decode(Int.self, forKey: .sizeInBytes)
        }

        var durationInSeconds: Int? = nil

        if CONTAINER.contains(.durationInSeconds) {
            durationInSeconds = try CONTAINER.decode(Int.self, forKey: .durationInSeconds)
        }

        self.init(withURL: ATTACHMENT_URL, mimeType: MIME_TYPE, title: title, sizeInBytes: sizeInBytes, durationInSeconds: durationInSeconds)
    }

    // implement method to compare attachments
    public static func ==(lhs: JSONFeedAttachment, rhs: JSONFeedAttachment) -> Bool {
        return lhs.mimeType == rhs.mimeType && lhs.url == rhs.url && lhs.sizeInBytes == rhs.sizeInBytes && lhs.durationInSeconds == rhs.durationInSeconds && lhs.title == rhs.title
    }

    /**
    encoding function that make sure only properties that are not nil are included in JSON.
    */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
        try container.encode(mimeType, forKey: .mimeType)

        if let title = title {
            try container.encode(title, forKey: .title)
        }

        if let sizeInBytes = sizeInBytes {
            try container.encode(sizeInBytes, forKey: .sizeInBytes)
        }

        if let durationInSeconds = durationInSeconds {
            try container.encode(durationInSeconds, forKey: .durationInSeconds)
        }
    }
}

// create extension, so that items can be combined into strings easily
extension Sequence where Iterator.Element == JSONFeedAttachment {
    func joinWithSeparator(_ separator: String) -> String {
        return self.reduce(into: "") {(output, attachment) in
            if let lastElement = Array(self).last {
                if attachment == lastElement {
                    output += "\(attachment)"
                } else {
                    output += "\(attachment)\(separator)"
                }
            }
        }
    }
}
