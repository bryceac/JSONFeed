import Foundation

extension String {
    public func stripHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
    }
}