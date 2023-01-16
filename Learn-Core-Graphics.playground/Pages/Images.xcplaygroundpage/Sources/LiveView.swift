import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    let mascot = UIImage(named: "HackingWithSwiftMascot.jpg")

    liveView.drawPreview { ctx in
        UIColor.darkGray.setFill()
        ctx.cgContext.fill(rect)

        UIColor.black.withAlphaComponent(0.2).setFill()
        let borderRect = CGRect(x: 180, y: 180, width: 640, height: 640)
        ctx.cgContext.fill(borderRect)

        let imageRect = CGRect(x: 200, y: 200, width: 600, height: 600)
        mascot?.draw(in: imageRect, blendMode: .normal, alpha: 0.2)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
