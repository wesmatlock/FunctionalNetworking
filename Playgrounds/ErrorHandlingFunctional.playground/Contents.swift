import Foundation
import FunctionalSwift
import FunctionalNetworking

struct Host: Decodable {
  let ip: String
}

func handleError(error: Error) {
  switch error {
  case let NetworkRequestError.failed(error):
    print(error)
  case NetworkRequestError.invalidRequest:
    print("Invalid Request")
  case let NetworkRequestError.invalidResponse(code):
    print("Invalied Response Code: \(code)")
  default:
    print("An Error Occured \(error)")
  }
}

let fetchIpNumber: IO<Either<Error, Host>> = {
  Optional<URLRequest>.none
  |> requestSyncE
  <&> decodeJsonData
}()

fetchIpNumber
  .unsafeRun()
  .onLeft(handleError)
  .onRight({ dump($0) })
