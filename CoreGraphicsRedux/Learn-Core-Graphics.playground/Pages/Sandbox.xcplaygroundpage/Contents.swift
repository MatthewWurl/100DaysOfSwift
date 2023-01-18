//: [< Previous](@previous)           [Home](Introduction)
//: # Sandbox
//: *Sandbox - noun: a place where people can play. (In the sand.)*
//:
//: Below are some example Core Graphics instructions based on things you've learned in this playground. This is a great place to experiment by copying, pasting, and experimenting until you get the result you want – enjoy!
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // draw a green box
    UIColor.green.setFill()
    UIColor.black.setStroke()
    ctx.cgContext.setLineWidth(10)
    ctx.cgContext.addRect(CGRect(x: 50, y: 500, width: 150, height: 150))
    ctx.cgContext.drawPath(using: .fillStroke)

    // draw a zig zag line
    ctx.cgContext.move(to: CGPoint(x: 50, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 100, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 150, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 200, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 250, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 300, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 350, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 400, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 450, y: 300))
    ctx.cgContext.setLineWidth(20)
    ctx.cgContext.strokePath()

    // draw a quote
    let text = "Here's to the crazy ones"
    let attrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.blue
    ]

    let string = NSAttributedString(string: text, attributes: attrs)
    string.draw(in: rect)

    // draw overlapping circles
    UIColor.red.setFill()
    ctx.cgContext.setBlendMode(.xor)
    ctx.cgContext.fillEllipse(in: CGRect(x: 700, y: 400, width: 200, height: 200))
    ctx.cgContext.fillEllipse(in: CGRect(x: 600, y: 400, width: 200, height: 200))
    ctx.cgContext.setBlendMode(.normal)

    // draw an image
    ctx.cgContext.rotate(by: .pi / 8)
    let image = UIImage(named: "saltire")
    image?.draw(at: CGPoint(x: 600, y: 400))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)