//
//  ViewController.swift
//  UsingCoreGraphics
//
//  Created by Matt X on 1/12/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("Uncomment rectangle")
//        drawRectangle()
        drawHappyFaceEmoji()
    }
    
    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawHappyFaceEmoji()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        let rect = CGRect(x: col * 64, y: row * 64, width: 64, height: 64)
                        context.cgContext.fill(rect)
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                let rect = CGRect(x: -128, y: -128, width: 256, height: 256)
                context.cgContext.addRect(rect)
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                context.cgContext.rotate(by: .pi / 2)
                
                let point = CGPoint(x: length, y: 50)
                
                if first {
                    context.cgContext.move(to: point)
                    first = false
                } else {
                    context.cgContext.addLine(to: point)
                }
                
                length *= 0.99
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { _ in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            let rect = CGRect(x: 32, y: 32, width: 448, height: 448)
            
            attributedString.draw(with: rect, options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            let point = CGPoint(x: 300, y: 150)
            mouse?.draw(at: point)
        }
        
        imageView.image = image
    }
    
    func drawHappyFaceEmoji() {
        let rendererSize = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        
        let image = renderer.image { context in
            // Draw background of emoji...
            let rect = CGRect(x: 0, y: 0, width: 512, height: 512)
            let emojiBackgroundColor = CGColor(red: 0.984, green: 0.780, blue: 0.169, alpha: 1)
            context.cgContext.setFillColor(emojiBackgroundColor)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.drawPath(using: .fill)
            
            // Draw eyes...
            let emojiForegroundColor = CGColor(red: 0.643, green: 0.420, blue: 0.169, alpha: 1)
            context.cgContext.setFillColor(emojiForegroundColor)
            context.cgContext.setStrokeColor(emojiForegroundColor)
            
            let leftRect = CGRect(x: 256 - 80, y: 256 - 40, width: 60, height: 100).offsetBy(dx: -30, dy: -50)
            context.cgContext.addEllipse(in: leftRect)
            context.cgContext.drawPath(using: .fill)
            
            let rightRect = CGRect(x: 256 + 80, y: 256 - 40, width: 60, height: 100).offsetBy(dx: -30, dy: -50)
            context.cgContext.addEllipse(in: rightRect)
            context.cgContext.drawPath(using: .fill)
            
            let smilePath = UIBezierPath(arcCenter: CGPoint(x: 256, y: 256 + 80), radius: 100, startAngle: 300, endAngle: 330, clockwise: true).cgPath
            context.cgContext.addPath(smilePath)
            context.cgContext.setLineWidth(10)
            context.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = image
    }
}
