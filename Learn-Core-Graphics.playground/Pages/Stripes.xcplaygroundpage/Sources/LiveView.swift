import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    liveView.drawPreview { ctx in
        let alphaComponent: CGFloat = 0.2
        UIColor.red.withAlphaComponent(alphaComponent).setFill()
        ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 1000))

        UIColor.orange.withAlphaComponent(alphaComponent).setFill()
        ctx.cgContext.fill(CGRect(x: 200, y: 0, width: 200, height: 1000))

        UIColor.yellow.withAlphaComponent(alphaComponent).setFill()
        ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))

        UIColor.green.withAlphaComponent(alphaComponent).setFill()
        ctx.cgContext.fill(CGRect(x: 600, y: 0, width: 200, height: 1000))

        UIColor.blue.withAlphaComponent(alphaComponent).setFill()
        ctx.cgContext.fill(CGRect(x: 800, y: 0, width: 200, height: 1000))
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
