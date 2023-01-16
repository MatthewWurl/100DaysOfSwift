import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    liveView.drawPreview { ctx in
        UIColor.red.withAlphaComponent(0.2).setFill()
        let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle1)

        UIColor.yellow.withAlphaComponent(0.2).setFill()
        let circle2 = CGRect(x: 500, y: 0, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle2)

        UIColor.blue.withAlphaComponent(0.2).setFill()
        let circle3 = CGRect(x: 0, y: 500, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle3)

        UIColor.green.withAlphaComponent(0.2).setFill()
        let circle4 = CGRect(x: 500, y: 500, width: 500, height: 500)
        ctx.cgContext.fillEllipse(in: circle4)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
