import Foundation
import FunctionalSwift
import FunctionalNetworking
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension String: Error {}

enum WorldId: Int {
  case copenhagen = 554890
  case london = 44418
  case stockholm = 906057
}

struct WeatherInformation: Decodable {
  let title: String, consolidatedWeather: [Condition]

  struct Condition: Decodable {
    let weatherStateName: String, minTemp, maxTemp: Double
  }
}

let weatherDecoder: JSONDecoder = {

  let jsonDecoder = JSONDecoder()
  let formatter = DateFormatter()

  formatter.dateFormat = "yyyy-MM-dd"
  jsonDecoder.dateDecodingStrategy = .formatted(formatter)
  jsonDecoder.keyDecodingStrategy  = .convertFromSnakeCase

  return jsonDecoder
}()

func weatherUrlFor(id: Int) -> String {
  "https://www.metaweather.com/api/location/\(id)"
}

func weatherInfo(for id: WorldId) -> Deferred<Result<WeatherInformation, Error>> {

  let urlString = weatherUrlFor(id: id.rawValue)

  guard let url = URL(string: urlString) else {
    return Deferred { $0(.failure("Failed to create URL")) }
  }

  let requestFunc = retry(requestAsyncR, retries: 3, debounce: .linear(3))
  return requestFunc(URLRequest(url: url))
    .map(decodeJsonData(with: weatherDecoder))
}

zip(
  weatherInfo(for: .copenhagen),
  weatherInfo(for: .london),
  weatherInfo(for: .stockholm))
  .map(zip)
  .run { result in
    dump(result)
  }
