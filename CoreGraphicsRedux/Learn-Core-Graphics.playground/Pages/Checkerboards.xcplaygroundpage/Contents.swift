//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Rectangles in a loop
//: Drawing rectangles inside two loops lets us create a checkerboard pattern. The image already has a white background color, so we need to draw black rectangles in an odd-even pattern to get the desired result.
//:
//: - Experiment: The code below makes a checkerboard, but it doesn't fill the image correctly. Try adjusting the grid size, number of rows, and number of columns so that you get a 10x10 checkerboard across the entire image.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.black.setFill()

    let size = 100

    for row in 0 ..< 10 {
        for col in 0 ..< 10 {
            if (row + col) % 2 == 0 {
                ctx.cgContext.fill(CGRect(x: col * size, y: row * size, width: size, height: size))
            }
        }
    }
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
