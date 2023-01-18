import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let drawRect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    liveView.drawPreview { ctx in
        let innerRenderer = UIGraphicsImageRenderer(bounds: drawRect)

        let innerImage = innerRenderer.image { ctx in
            let ellipseRectangle = CGRect(x: 0, y: 300, width:
                400, height: 400)
            ctx.cgContext.setLineWidth(8)
            UIColor.red.setStroke()

            for _ in 1...7 {
                ctx.cgContext.strokeEllipse(in: ellipseRectangle)
                ctx.cgContext.translateBy(x: 100, y: 0)
            }
        }

        innerImage.draw(in: drawRect, blendMode: .normal, alpha: 0.1)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
