import Foundation
import FunctionalSwift

public enum DowloadFileError: Error {
  case invalidImageData
}

private func createRequest(url: String) -> Either<Error, URLRequest> {
  guard let url = URL(string: url) else { return .left(NetworkRequestError.invalidRequest) }

  let requestWithTimeout = flip(requestWithCachePolicy(.returnCacheDataElseLoad))
  return .right(url |> requestWithTimeout(15))
}

// MARK: - Download Either Request
public func downloadFileE(request: URLRequest?) -> Deferred<Either<Error, Data>> {

  Deferred { callback in

    guard let request = request
    else { callback(.left(NetworkRequestError.invalidRequest)); return }

    if let data = URLCache.shared.cachedResponse(for: request)?.data {
      callback(.right(data))
    } else {
      deferredDataTask(request: request).run { result in
        switch result {
        case let .left(error):
          callback(.left(error))
        case let .right((data, response)):
          let cachedData = CachedURLResponse(response: response, data: data)
          URLCache.shared.storeCachedResponse(cachedData, for: request)
          callback(.right(data))
        }
      }
    }
  }
}

public func downloadFileE(url: String) -> Deferred<Either<Error, Data>> {
  switch createRequest(url: url) {
  case let .left(error):
    return Deferred { $0(.left(error)) }
  case let .right(request):
    return downloadFileE(request:request)
  }
}

// MARK: - Download Result Request
public func downloadFileR(request: URLRequest?) -> Deferred<Result<Data, Error>> {
  downloadFileE(request: request)
    .map(Result.init(either:))
}

public func downloadFileR(url: String) -> Deferred<Result<Data, Error>> {
  downloadFileE(url: url)
    .map(Result.init(either:))
}

// MARK: - Download image with Request
public func downloadImageR(request: URLRequest?) -> Deferred<Result<FunctionalImage?, Error>> {
  downloadFileE(request: request)
    .map(Result.init(either:))
    .mapT(FunctionalImage.init(data:))
}

public func downloadImageE(request: URLRequest?) -> Deferred<Either<Error, FunctionalImage?>> {
  downloadFileE(request: request)
    .mapT(FunctionalImage.init(data:))
}

// MARK: - Download image from raw string
public func downloadImageE(url: String) -> Deferred<Either<Error, FunctionalImage?>> {
  switch createRequest(url: url) {
  case let .left(error):
    return Deferred { $0(.left(error)) }
  case let .right(request):
    return downloadImageE(request:request)
  }
}

public func downloadImageR(url: String) -> Deferred<Result<FunctionalImage?, Error>> {
  downloadImageE(url: url)
    .map(Result.init(either:))
}
