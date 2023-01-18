//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import PlaygroundSupport
import UIKit

public class PreviewViewController: UIViewController {
    public var previewImageView = UIImageView(frame: .zero) // used to pre-render something so readers can see what they have to do
    public var readerImageView = UIImageView(frame: .zero) // used to display the image the reader create

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.9, alpha: 1)

        for imageView in [previewImageView, readerImageView] {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)

            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        }

        previewImageView.backgroundColor = .white


        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Clear Drawing", for: .normal)
        resetButton.backgroundColor = UIColor(white: 1, alpha: 0.7)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)

        resetButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        resetButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        resetButton.topAnchor.constraint(equalTo: readerImageView.bottomAnchor, constant: 20).isActive = true
        resetButton.layer.cornerRadius = 20

        resetButton.addTarget(self, action: #selector(resetDrawing), for: .touchUpInside)
    }

    public func drawPreview(instructions: (UIGraphicsImageRendererContext) -> Void) {
        let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
        let renderer = UIGraphicsImageRenderer(bounds: rect)

        previewImageView.image = renderer.image(actions: instructions)
    }

    @objc func resetDrawing() {
        readerImageView.image = nil
    }
}
