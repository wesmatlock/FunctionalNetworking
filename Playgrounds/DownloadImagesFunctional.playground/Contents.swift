import Foundation
import FunctionalNetworking
import FunctionalSwift
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

final class ImageViewController: UIViewController {

  private lazy var  stackView: UIStackView = {

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    return stackView
  }()

  private func createRequest(httpCode: Int) -> String {
    "https://http.cat/\(httpCode)"
  }

  private func requetImages(for stackView: UIStackView) {
    zip(
      downloadImageE(url: createRequest(httpCode: 204)),
      downloadImageE(url: createRequest(httpCode: 404)),
      downloadImageE(url: createRequest(httpCode: 504)),
      downloadImageE(url: createRequest(httpCode: 501))
    )
    .map(zip)
    .run { result in
      DispatchQueue.main.async {
        switch result {
        case let .left(error): print(error)
        case let .right((first, second, third, forth)):
          stackView.addArrangedSubview(UIImageView(image: first))
          stackView.addArrangedSubview(UIImageView(image: second))
          stackView.addArrangedSubview(UIImageView(image: third))
          stackView.addArrangedSubview(UIImageView(image: forth))
        }
      }
    }
  }

  private func setupSubview() {
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
                                  stackView.topAnchor.constraint(equalTo: view.topAnchor),
                                  stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                  stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                  stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubview()
    requetImages(for: stackView)
  }
}

let controller = ImageViewController()
controller.view.frame = .init(x: 0, y: 0, width: 320, height: 600)
PlaygroundPage.current.liveView = controller
