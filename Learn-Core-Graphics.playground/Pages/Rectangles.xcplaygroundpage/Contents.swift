//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Welcome to Core Graphics!
//: Core Graphics is Apple's high-performance drawing framework, and you can use it to draw shapes, text, images, gradients, and more.
//:
//: In this playground you'll explore the fundamentals of working with Core Graphics, starting with the basics: how to draw rectangles.
//:
//: When you run the code below, it will create a 1000x1000 image with a 600x600 blue box in its center, then display it in the image view you'll see in the playground live view.
//:
//: - Experiment: Can you write some code to draw a red box on top of the blue one, making it 200x200 and centered like the blue one?
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.blue.setFill()
    ctx.cgContext.fill(CGRect(x: 200, y: 200, width: 600, height: 600))

    // Add your code here
    UIColor.red.setFill()
    ctx.cgContext.fill(CGRect(x: 400, y: 400, width: 200, height: 200))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
