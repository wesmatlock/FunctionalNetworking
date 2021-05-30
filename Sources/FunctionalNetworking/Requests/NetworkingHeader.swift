import Foundation
import FunctionalSwift

public func validHttpHeaders(for request: URLRequest) -> [String: String] {
  request.allHTTPHeaderFields ?? [:]
}

public func setHeader(_ value: String, for field: String) -> (URLRequest) -> URLRequest {
  return { request in
    var requestCopy = request
    requestCopy.allHTTPHeaderFields = (validHttpHeaders(for: request) <> [field: value])
    return requestCopy
  }
}

public func setHeader(_ incomingHeaders: [String: String]) -> (URLRequest) -> URLRequest {
  return { request in
    var requestCopy = request
    requestCopy.allHTTPHeaderFields = (validHttpHeaders(for: request) <> incomingHeaders)
    return requestCopy
  }
}
