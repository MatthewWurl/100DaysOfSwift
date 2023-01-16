//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Fixing the fade
//: This time you'll see the image now contains five rectangles, each 200 pixels wide and the full height of the image. Your designer wanted to make them red, orange, yellow, green, and blue, but they didn't get some of the colors quite right – they look faded.
//:
//: - Experiment: Can you draw the five rectangles in their correct colors? The first one has been done for you.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 1000))

    // Add your code here
    UIColor.orange.setFill()
    ctx.cgContext.fill(CGRect(x: 200, y: 0, width: 200, height: 1000))
    
    UIColor.yellow.setFill()
    ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))
    
    UIColor.green.setFill()
    ctx.cgContext.fill(CGRect(x: 600, y: 0, width: 200, height: 1000))
    
    UIColor.blue.setFill()
    ctx.cgContext.fill(CGRect(x: 800, y: 0, width: 200, height: 1000))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
