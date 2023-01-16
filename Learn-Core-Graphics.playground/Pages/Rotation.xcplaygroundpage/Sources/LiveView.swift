import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let boxRectangle = CGRect(x: 0, y: 0, width: 300, height: 300)

    liveView.drawPreview { ctx in
        ctx.cgContext.translateBy(x: 500, y: 500)
        ctx.cgContext.setLineWidth(8)

        for _ in 1...8 {
            ctx.cgContext.addRect(boxRectangle)
            ctx.cgContext.rotate(by: .pi / 4)
        }

        UIColor(white: 0.9, alpha: 1).setStroke()
        ctx.cgContext.strokePath()
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
