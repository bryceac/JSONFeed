import Foundation

extension String {
    func stripHTML() {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
    }
}