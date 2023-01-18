import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    liveView.drawPreview { ctx in
        ctx.cgContext.setLineWidth(50)

        let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
        var xPos = 0
        var yPos = 500
        var size = 1000

        for color in colors {
            xPos += 50
            yPos += 50
            size -= 100

            let rect = CGRect(x: xPos, y: yPos, width: size, height: size)
            color.withAlphaComponent(0.2).setStroke()
            ctx.cgContext.strokeEllipse(in: rect)
        }
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
