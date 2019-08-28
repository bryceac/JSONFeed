//
//  JSONFeedAttachment.swift
//  JSONFeed
//
//  Created by Bryce Campbell on 8/27/19.
//

import Foundation

/** type that hold data concerning attachments in JSON feed.
 For more information regarding attachments, look under the Attachments section of the [JSON Feed spec.](https://jsonfeed.org/version/1)
 */
public struct JSONFeedAttachment: Codable {
    /// property that holds attachment URL.
    var url: URL
    
    /// property that holds attachment mime type.
    var mimeType: String
    
    /// property that holds the name of the attachment
    var title: String?
    
    /// property that holds the file's size in bytes
    var sizeInBytes: Int?
    
    /// property that holds the duration in seconds
    var durationInSeconds: Int?
    
    enum CodingKeys: String, CodingKey {
        case url, mimeType = "mime_type", sizeInBytes = "size_in_bytes", durationInSeconds = "duration_in_seconds"
    }

    /**
    default initializer.
    - Parameters: 
        - url: specifies attachment URL (required).
        - mimeType: specifies mime type for attachment (required).
        - title: specifies title for attachment (optional)
        - sizeInBytes: specficifies file size for attachment (optional).
        - durationInSecond: specifies the attachment's duration (optional)
    */
    public init(withURL url: URL, mimeType: String, title: String? = nil, sizeInBytes: Int? = nil, durationInSeconds: Int? = nil) {
        self.url = url
        self.mimeType = mimeType
        self.title = title
        self.sizeInBytes = sizeInBytes
        self.durationInSeconds = durationInSeconds
    }
}
