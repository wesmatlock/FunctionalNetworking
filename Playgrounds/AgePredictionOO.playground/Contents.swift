import Foundation
import FunctionalNetworking
import FunctionalSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct AgeGuess: Decodable { let name: String, age, count: Int }

func createAgifyRequest(for name: String) -> URLRequest? {
  URL(string: "https://api.agify.io/?name=\(name)")
    .flatMap {
      URLRequest(url: $0, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
    }
}

func ageGuessWithRetryFrom(_ request: URLRequest?) -> Deferred<Result<AgeGuess, Error>> {
  let requestWithRetry = retry(requestAsyncR, retries: 3, debounce: .linear(3))
  return requestWithRetry(request).map(decodeJsonData)
}

func ageGuessFrom(_ request: URLRequest?) -> Deferred<Result<AgeGuess, Error>> {
  let requestFunc = retry(requestAsyncR, retries: 3, debounce: .linear(5))
  return requestFunc(request).map(decodeJsonData)
}

zip(
  ageGuessFrom(createAgifyRequest(for: "Robin")),
  ageGuessWithRetryFrom(createAgifyRequest(for: "Amy")),
  ageGuessFrom(createAgifyRequest(for: "Wesley")))
  .map(zip)
  .run { result in
    dump(result)
  }
