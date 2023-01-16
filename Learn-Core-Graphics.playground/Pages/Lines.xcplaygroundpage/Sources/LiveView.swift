import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    liveView.drawPreview { ctx in
        UIColor(red: 0, green: 0.37, blue: 0.72, alpha: 1).setFill()
        ctx.cgContext.fill(rect)

        UIColor.white.setStroke()
        ctx.cgContext.setLineWidth(10)

        ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: 200, y: 200))

        ctx.cgContext.strokePath()
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
