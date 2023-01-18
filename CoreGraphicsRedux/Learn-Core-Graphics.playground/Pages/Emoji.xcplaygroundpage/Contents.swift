//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # O… M… G…
//: It's time for the ultimate test of your circle-drawing ability: can you draw emoji? Your CEO wants to pitch a new design for Apple to use in iOS, but to win the contract you'll need to convert your designer's sketch into Core Graphics code using ellipses, strokes, and fills.
//:
//: - Experiment: Try to recreate your designer's sketch using four circles. The face should be colored yellow, the mouth brown, and both eyes black. Your designer has helped write the code for the face, but it isn't quite right.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.black.setStroke()
    UIColor.yellow.setFill()
    ctx.cgContext.setLineWidth(10)

    let face = CGRect(x: 100, y: 100, width: 800, height: 800)
    ctx.cgContext.addEllipse(in: face)
    ctx.cgContext.drawPath(using: .fillStroke)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
