import UIKit
import PlaygroundSupport

public func showOutput(_ image: UIImage) {
    let liveView = PreviewViewController()

    let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

    liveView.drawPreview { ctx in
        let firstPosition = rect.offsetBy(dx: 0, dy: 300)
        let firstText = "The early bird catches the worm."
        let firstAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 72),
            .foregroundColor: UIColor.blue
        ]

        let firstString = NSAttributedString(string: firstText, attributes: firstAttrs)
        firstString.draw(in: firstPosition)

        let secondPosition = firstPosition.offsetBy(dx: 0, dy: 100)
        let secondText = "But the second mouse gets the cheese."
        let secondAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 72),
            .foregroundColor: UIColor.red.withAlphaComponent(0.1)
        ]

        let secondString = NSAttributedString(string: secondText, attributes: secondAttrs)
        secondString.draw(in: secondPosition)
    }

    liveView.readerImageView.image = image

    PlaygroundPage.current.liveView = liveView
}
