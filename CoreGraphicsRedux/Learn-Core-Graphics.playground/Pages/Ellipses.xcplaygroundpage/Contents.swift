//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Four circles
//: Now that you've mastered rectangles, ellipses ought to be easy. Like rectangles, ellipses are drawn by activating a color then specifying a rectangle. If the rectangle has the same width and height you'll get a circle, otherwise you'll get an ellipse.
//:
//: - Experiment: The code below draws one red circle in the top-left corner, but your designer wants you to create three more: a yellow circle in the top-right corner, a blue circle in the bottom-left corner, and a green circle in the bottom-right corner.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle1)

    // Add your code here
    UIColor.yellow.setFill()
    let circle2 = CGRect(x: 500, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle2)
    
    UIColor.blue.setFill()
    let circle3 = CGRect(x: 0, y: 500, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle3)
    
    UIColor.green.setFill()
    let circle4 = CGRect(x: 500, y: 500, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle4)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
