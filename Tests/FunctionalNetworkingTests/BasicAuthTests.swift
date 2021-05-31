import XCTest
@testable import FunctionalNetworking
@testable import FunctionalSwift

final class BasicAuthTests: XCTestCase {

  func testBasicAuth() throws {

    let urlRequestWtihTimeout = flip(requestWithCachePolicy(.returnCacheDataElseLoad))

    let request = "http://jigsaw.w3.org/HTTP/Basic/"
      |> URL.init(string:) >=> urlRequestWtihTimeout(15)
      >=> authorization(.basic(username: "guest", password: "guest"))

    let authorization = try XCTUnwrap(request?.value(forHTTPHeaderField: "authorization"))
    XCTAssertEqual(authorization, "Basic Z3Vlc3Q6Z3Vlc3Q=")
  }

  func testCustomAuthorizationField() throws {

    let urlRequesstWithTimeout = flip(requestWithCachePolicy(.returnCacheDataElseLoad))

    let request = "https://jigsaw.w3.org/HTTP/Basic/"
      |> URL.init(string:)
      >=> urlRequesstWithTimeout(15)
      >=> authorization(.custom(field: "Basic", data: "Z3Vlc3Q6Z3Vlc3Q="))


    let authorization = try XCTUnwrap(request?.value(forHTTPHeaderField:"authorization"))
    XCTAssertEqual(authorization, "Basic Z3Vlc3Q6Z3Vlc3Q=")
  }

}
