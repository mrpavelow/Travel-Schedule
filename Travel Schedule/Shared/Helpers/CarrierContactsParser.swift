import Foundation

enum CarrierContactsParser {
    static func parse(_ raw: String?) -> (phone: String?, email: String?) {
        guard var s = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !s.isEmpty else { return (nil, nil) }

        // Превращаем <br> в переносы
        s = s.replacingOccurrences(of: "<br>", with: "\n")
        s = s.replacingOccurrences(of: "<br/>", with: "\n")
        s = s.replacingOccurrences(of: "<br />", with: "\n")

        // Часто там \r\n
        s = s.replacingOccurrences(of: "\r", with: "")

        let phone = firstMatch(in: s, patterns: [
            #"Телефон:\s*([^\n]+)"#,
            #"телефон:\s*([^\n]+)"#
        ])

        let email = firstMatch(in: s, patterns: [
            #"e-mail:\s*([^\s\n]+)"#,
            #"email:\s*([^\s\n]+)"#,
            #"E-mail:\s*([^\s\n]+)"#
        ])

        return (phone?.trimmed, email?.trimmed)
    }

    private static func firstMatch(in text: String, patterns: [String]) -> String? {
        for p in patterns {
            if let r = text.firstRegexGroup(p) { return r }
        }
        return nil
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }

    func firstRegexGroup(_ pattern: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return nil }
        let range = NSRange(self.startIndex..., in: self)
        guard let match = regex.firstMatch(in: self, range: range),
              match.numberOfRanges >= 2,
              let r = Range(match.range(at: 1), in: self) else { return nil }
        return String(self[r])
    }
}
