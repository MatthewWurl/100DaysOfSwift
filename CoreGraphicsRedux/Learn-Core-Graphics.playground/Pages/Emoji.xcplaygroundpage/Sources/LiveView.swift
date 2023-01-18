import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let drawRect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    liveView.drawPreview { ctx in
        let innerRenderer = UIGraphicsImageRenderer(bounds: drawRect)

        let innerImage = innerRenderer.image { ctx in
            UIColor.black.setStroke()
            UIColor.yellow.setFill()
            ctx.cgContext.setLineWidth(10)

            let face = CGRect(x: 100, y: 100, width: 800, height: 800)
            ctx.cgContext.addEllipse(in: face)
            ctx.cgContext.drawPath(using: .fillStroke)

            let leftEye = CGRect(x: 250, y: 300, width: 150, height: 150)
            UIColor.black.setFill()
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)

            let rightEye = CGRect(x: 600, y: 300, width: 150, height: 150)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)

            let mouth = CGRect(x: 350, y: 500, width: 300, height: 300)
            UIColor.brown.setFill()
            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        innerImage.draw(in: drawRect, blendMode: .normal, alpha: 0.2)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
