import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let drawRect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    liveView.drawPreview { ctx in
        let innerRenderer = UIGraphicsImageRenderer(bounds: drawRect)

        let innerImage = innerRenderer.image { ctx in
            UIColor.red.setFill()
            UIColor.black.setStroke()
            ctx.cgContext.setLineWidth(40)

            let bigCircle = CGRect(x: 300, y: 300, width: 400, height: 400)
            ctx.cgContext.addEllipse(in: bigCircle)
            ctx.cgContext.drawPath(using: .fillStroke)

            ctx.cgContext.setLineWidth(10)
            let leftCircle = CGRect(x: 100, y: 400, width: 200, height: 200)
            ctx.cgContext.addEllipse(in: leftCircle)
            let rightCircle = CGRect(x: 700, y: 400, width: 200, height: 200)
            ctx.cgContext.addEllipse(in: rightCircle)
            let topCircle = CGRect(x: 400, y: 100, width: 200, height: 200)
            ctx.cgContext.addEllipse(in: topCircle)
            let bottomCircle = CGRect(x: 400, y: 700, width: 200, height: 200)
            ctx.cgContext.addEllipse(in: bottomCircle)

            ctx.cgContext.drawPath(using: .fillStroke)
        }

        innerImage.draw(in: drawRect, blendMode: .normal, alpha: 0.2)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
