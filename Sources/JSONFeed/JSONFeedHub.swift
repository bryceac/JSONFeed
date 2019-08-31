import Foundation

/**
use to establish endpoints for feeds.

For more more information, refer to the [JSON Feed spec.](https://jsonfeed.org/version/1)
*/
public struct JSONFeedHub: Codable, Equatable, CustomStringConvertible {

    /// endpoint type
    public var type: String

    /// endpot URL
    public var url: URL

    /// output hub values to String
    public var description: String {
        return """
        Type: \(type)
        URL: \(url.absoluteString)
        """
    }

    /**
    default initializer
    - Parameter type: specify the endpoint's type (required)
    - Parameter url: specify the endpoint's address (required)
    - Returns: JSONFeedHub
    */
    public init(withType type: String, andURL url: URL) {
        self.type = type
        self.url = url
    }

    // implement method to compare hubs.
    public static func ==(lhs: JSONFeedHub, rhs: JSONFeedHub) {
        return lhs.type == rhs.type && lhs.url == rhs.url
    }
}

// create extension, so that items can be combined into strings easily
extension Sequence where Iterator.Element == JSONFeedHub {
    func joinWithSeparator(_ separator: String) -> String {
        return self.reduce(into: "") {(output, hub) in
            if let lastElement = Array(self).last {
                if hub == lastElement {
                    output += "\(hub)"
                } else {
                    output += "\(hub)\(separator)"
                }
            }
        }
    }
}