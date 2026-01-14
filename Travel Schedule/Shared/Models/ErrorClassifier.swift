import Foundation

enum AppErrorKind {
    case noInternet
    case serverError
    case clientErrorNoOverlay
}

import Foundation

enum ErrorClassifier {
    static func classify(_ error: Error) -> AppErrorKind {
        if isNoInternet(error) { return .noInternet }
        return .serverError
    }

    private static func isNoInternet(_ error: Error) -> Bool {
        let ns = error as NSError

        if ns.domain == NSURLErrorDomain, isNoInternetCode(ns.code) { return true }

        if let underlying = ns.userInfo[NSUnderlyingErrorKey] as? NSError {
            if underlying.domain == NSURLErrorDomain, isNoInternetCode(underlying.code) { return true }
        }

        return false
    }

    private static func isNoInternetCode(_ code: Int) -> Bool {
        switch code {
        case NSURLErrorNotConnectedToInternet,
             NSURLErrorNetworkConnectionLost,
             NSURLErrorTimedOut,
             NSURLErrorCannotFindHost,
             NSURLErrorCannotConnectToHost,
             NSURLErrorDNSLookupFailed:
            return true
        default:
            return false
        }
    }
}

extension Error {
    var rootNSError: NSError {
        var current = self as NSError
        var visited = Set<ObjectIdentifier>()

        while true {
            let id = ObjectIdentifier(current)
            if visited.contains(id) { return current }
            visited.insert(id)

            if let underlying = current.userInfo[NSUnderlyingErrorKey] as? NSError {
                current = underlying
                continue
            }
            return current
        }
    }
}
