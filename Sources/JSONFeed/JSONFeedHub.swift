import Foundation

/**
use to establish endpoints for feeds.

For more more information, refer to the [JSON Feed spec.](https://jsonfeed.org/version/1)
*/
public class JSONFeedHub: Codable {

    /// endpoint type
    var type: String

    /// endpot URL
    var url: URL

    /**
    default initializer
    - Parameter type: specify the endpoint's type (required)
    - Parameter url: specify the endpoint's address (required)
    - Returns: JSONFeedHub
    */
    init(withType type: String, andURL url: URL) {
        self.type = type
        self.url = url
    }
}