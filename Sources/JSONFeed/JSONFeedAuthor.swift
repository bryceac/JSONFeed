//
//  JSONFeedAuthor.swift
//  JSONFeed
//
//  Created by Bryce Campbell on 8/27/19.
//

import Foundation

/** type that holds the details concerning a feed's or item's author.
 For more details, look under the Top-Level section of the [JSON Feed spec.](https://jsonfeed.org/version/1)
 */
struct JSONFeedAuthor: Codable {
    
    /// property that holds the author's name
    var name: String?
    
    /// property that holds the address of the author's website
    var url: URL?
    
    /// property that contains the address of the author's avatar
    var avatar: URL?
    
    /** initializer that creates an Optional JSONAuthor object
     - Parameter name: The author's name.
     - Parameter url: The author's website
     - Parameter avatar: The location of the author's avatar
    */
    init!(withName name: String? = nil, url: URL? = nil, avatar: URL? = nil) {
        
        // check to make sure that at least one parameter is not nil, otherwise return nil
        guard name != nil || url != nil || avatar != nil else { return nil }
        
        // set properties
        self.name = name
        self.url = url
        self.avatar = avatar
    }
}
