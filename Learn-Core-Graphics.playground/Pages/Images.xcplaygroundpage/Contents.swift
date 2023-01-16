//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # Picture perfect
//: If you have a `UIImage`, you can render it directly into a Core Graphics context at any size you want – it will automatically be scaled up or down as needed. To do this, just call `draw(in:)` on your image, passing in the `CGRect` where it should be drawn.
//:
//: - Experiment: Your designer wants you to create a picture frame effect for an image. He's placed the frame at the right size, but it's down to you to position it correctly then position and size the image inside it.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let mascot = UIImage(named: "HackingWithSwiftMascot.jpg")

let rendered = renderer.image { ctx in
    // "I can't get this right!" – Designer
    // UIColor.darkGray.setFill()
    // ctx.cgContext.fill(rect)

    // UIColor.black.setFill()
    // let borderRect = CGRect(x: 0, y: 0, width: 640, height: 640)
    // ctx.cgContext.fill(borderRect)

    // let imageRect = CGRect(x: 100, y: 100, width: 100, height: 100)
    // mascot?.draw(in: imageRect)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
