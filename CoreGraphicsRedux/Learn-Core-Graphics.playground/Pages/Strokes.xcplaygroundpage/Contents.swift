//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Five red rings
//: Core Graphics lets us control *how* things are drawn: do we want to fill the shape, stroke the outline of the shape, or both? When you're stroking the outline, you can also adjust the line width to make the stroke thicker or thinner.
//:
//: So far we've been using `fill()` and `fillEllipse()` to draw shapes, but when you want to fill *and* stroke you should use `addRect()` and `addEllipse()`. These don't draw anything, but instead just create a path that you can then fill and/or stroke using `drawPath()`.
//:
//: Your designer has sketched out the icon for a new app: one 400x400 circle in the middle, and four 200x200 circles on its top, bottom, left, and right edges. Although a 40-point line width looks good on the big circle, they think something like 10 points for the smaller circles might look better.
//:
//: - Experiment: Can you recreate their logo sketch using ellipses, strokes, and fills? They already added the first circle for you, which should give you a nice template for the others.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    UIColor.black.setStroke()
    ctx.cgContext.setLineWidth(40)

    let bigCircle = CGRect(x: 300, y: 300, width: 400, height: 400)
    ctx.cgContext.addEllipse(in: bigCircle)
    ctx.cgContext.drawPath(using: .fillStroke)

    // Add your code here
    ctx.cgContext.setLineWidth(10)
    
    let smallCircle1 = CGRect(x: 100, y: 400, width: 200, height: 200)
    ctx.cgContext.addEllipse(in: smallCircle1)
    ctx.cgContext.drawPath(using: .fillStroke)
    
    let smallCircle2 = CGRect(x: 400, y: 700, width: 200, height: 200)
    ctx.cgContext.addEllipse(in: smallCircle2)
    ctx.cgContext.drawPath(using: .fillStroke)
    
    let smallCircle3 = CGRect(x: 400, y: 100, width: 200, height: 200)
    ctx.cgContext.addEllipse(in: smallCircle3)
    ctx.cgContext.drawPath(using: .fillStroke)
    
    let smallCircle4 = CGRect(x: 700, y: 400, width: 200, height: 200)
    ctx.cgContext.addEllipse(in: smallCircle4)
    ctx.cgContext.drawPath(using: .fillStroke)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
