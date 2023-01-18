//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Will it blend?
//: All the drawing operations you've used so far come with a hidden superpower: you can blend them together. This means that when you draw an ellipse over some existing color you can specify how the drawing should take place – should the new color just overwrite the old one, or should they be combined together somehow?
//:
//: The easiest way to see how this works is to try it for yourself. So, below is some code that renders four overlapping red circles – try running it now. You'll notice code to adjust the blend mode is commented out, so try uncommenting it then running the code again.
//:
//: That commented line is an XOR, which means this: "if the source pixel has a color and the destination doesn't, use the source; if the destination pixel has a color and the source doesn't, use the destination; if they both have colors, draw nothing." It's a pretty neat end result for such little work!
//:
//: - Experiment: Try some alternative blend modes to see what you can come up with – it's common to use `.multiply` to make one color to darken another, for example.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // ctx.cgContext.setBlendMode(.xor)

    UIColor.red.setFill()
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 200, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 200, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 400, y: 400, width: 400, height: 400))
    ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 400, width: 400, height: 400))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
