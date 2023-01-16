import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()
    liveView.readerImageView.image = image
    PlaygroundPage.current.liveView = liveView
}
