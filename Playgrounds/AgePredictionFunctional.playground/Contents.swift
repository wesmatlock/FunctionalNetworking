import Foundation
import FunctionalNetworking
import FunctionalSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let urlRequestWithTimeout = flip(requestWithCachePolicy(.reloadRevalidatingCacheData))

func ageGuess(from name: String) -> IO<Result<Guess, Error>> {
  "https://api.agify.io/?name=\(name)"
    |> URL.init(string:)
    >=> urlRequestWithTimeout(30)
    |> requestSyncR
    <&> decodeJsonData
}

zip(
  ageGuess(from: "Tim"),
  ageGuess(from: "John"),
  ageGuess(from: "Amy"))
  .map(zip)
  .unsafeRun()
  .onSuccess { dump($0) }
  .onFailure { print($0) }
