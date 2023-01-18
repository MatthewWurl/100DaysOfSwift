//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Getting a move on
//: By default, Core Graphics considers X:0 Y:0 to be the top-left corner of your canvas, but you can move that by calling the `translateBy()` method. For example, calling `translateBy(x: 500, y: 500)` will move the center point of your context to the middle of our 1000x1000 image.
//:
//: If we draw the same circle several times, each time translating the origin of our Core Graphics context, we'll actually draw multiple circles across the screen because each one will start at a different location.
//:
//: - Experiment: One of your teammates has tried to reproduce a design that places circles across the screen, but they aren't having much luck. Can you adjust their code so that the seven circles are positioned and sized correctly?
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    let ellipseRectangle = CGRect(x: 0, y: 300, width: 200, height: 200)
    ctx.cgContext.setLineWidth(8)
    UIColor.red.setStroke()

    for _ in 1...3 {
        ctx.cgContext.strokeEllipse(in: ellipseRectangle)
        ctx.cgContext.translateBy(x: 50, y: 0)
    }
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)