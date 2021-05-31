import Foundation
import FunctionalSwift
import FunctionalNetworking
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let stringWithEncoding = flip(curry(String.init(data:encoding:)))
let utf8String = stringWithEncoding(.utf8)

let urlREquestWithTimeout = flip(requestWithCachePolicy(.returnCacheDataElseLoad))
let basicAuthUrl = "https://jigsaw.w3.org/HTTP/Basic/"

let request: Deferred<Result<Data, Error>> = basicAuthUrl
  |> URL.init(string:)
  >=> urlREquestWithTimeout(15)
  >=> authorization(.basic(username: "guest", password: "guest"))
  |> requestAsyncR

request
  .mapT(utf8String)
  .run { result in
    dump(result)
  }
