import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    liveView.drawPreview { ctx in
        UIColor.red.withAlphaComponent(0.2).setFill()
        let circle1 = CGRect(x: 100, y: 100, width: 500, height: 500)
        ctx.cgContext.addEllipse(in: circle1)

        let circle2 = CGRect(x: 400, y: 100, width: 500, height: 500)
        ctx.cgContext.addEllipse(in: circle2)

        let circle3 = CGRect(x: 100, y: 400, width: 500, height: 500)
        ctx.cgContext.addEllipse(in: circle3)

        let circle4 = CGRect(x: 400, y: 400, width: 500, height: 500)
        ctx.cgContext.addEllipse(in: circle4)

        ctx.cgContext.fillPath()

        UIColor.lightGray.setFill()
        let circle5 = CGRect(x: 400, y: 400, width: 200, height: 200)
        ctx.cgContext.fillEllipse(in: circle5)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
