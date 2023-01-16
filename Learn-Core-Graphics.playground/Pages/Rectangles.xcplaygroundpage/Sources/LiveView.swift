import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    liveView.drawPreview { ctx in
        UIColor.blue.withAlphaComponent(0.2).setFill()
        ctx.cgContext.fill(CGRect(x: 200, y: 200, width: 600, height: 600))

        UIColor.red.withAlphaComponent(0.2).setFill()
        ctx.cgContext.fill(CGRect(x: 400, y: 400, width: 200, height: 200))
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
