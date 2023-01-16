//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Lining it up
//: It's approaching Burns Night, the one day of the year where everyone asks "so, what exactly *is* haggis?" Your team needs to design some suitably Scottish graphics to place around your office, and you've decided to draw a *saltire* – the Scottish flag. This is a diagonal white cross on a blue background.
//:
//: Fortunately for you, Core Graphics is able to draw lines out of the box: pass a `CGPoint` to the `move(to:)` method, then another to `addLine(to:)` to build a path. Add and move as many times as you need, before finally calling `strokePath()` to render it all. As this is a stroke action, you can adjust the width of your line by calling `setLineWidth()` beforehand.
//:
//: - Experiment: Your team tried to write code to draw the flag, but only managed one arm of the cross and even then it's far too small – it needs to stretch from corner to corner, and have another arm going in the other direction. Your designer also thinks a 10-pixel width is too small, and suggests trying 100 instead. Can you use Core Graphics to draw a good-looking Scottish flag like the one below?
//:
//: ![The Scottish saltire: a white diagonal cross on a blue background.](saltire.png)
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor(red: 0, green: 0.37, blue: 0.72, alpha: 1).setFill()
    ctx.cgContext.fill(rect)
    UIColor.white.setStroke()

    ctx.cgContext.setLineWidth(10)

    ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
    ctx.cgContext.addLine(to: CGPoint(x: 200, y: 200))

    ctx.cgContext.strokePath()
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)