//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # One nation under Swift
//: Impressed with your rectangle drawing prowess, your designer has returned to ask for help in designing a flag for the United Republic of Swiftovia.
//:
//: The client asked for a solid background color with a nice and bright cross over it, but they didn't like the colors chosen by your designer.
//:
//: - Experiment: Recreate your designer's image, but this time using a yellow background and an orange cross. Your designer suggested a couple of lines for you, which should give you a headstart.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    // "I think these two look better!" – Designer
    // UIColor.orange.setFill()
    // ctx.cgContext.fill(CGRect(x: 0, y: 400, width: 1000, height: 200))
    UIColor.yellow.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 1000, height: 1000))
    
    UIColor.orange.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 400, width: 1000, height: 200))
    ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
