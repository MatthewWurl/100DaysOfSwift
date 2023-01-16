//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
//: # The Poppyseed Bread Company
//: You have a new client! A local artisanal bakery always adds a finishing touch to its loaves by sprinkling poppy seeds on top, and they want you to make them a great poppy logo. Your designer has already sketched something, but it falls to you to figure out how to make it happen in code.
//:
//: - Experiment: Your designer has provided a sketch of what they want: four red circles, with a black circle in the middle. Can you make this happen using ellipses? They've drawn the first one for you, but it isn't quite right.
import UIKit

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
	// "This doesn't seem right…" – Designer
    UIColor.red.setFill()
    let circle1 = CGRect(x: 100, y: 100, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle1)
    
    let circle2 = CGRect(x: 400, y: 100, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle2)
    
    let circle3 = CGRect(x: 100, y: 400, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle3)

    let circle4 = CGRect(x: 400, y: 400, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle4)
    
    UIColor.black.setFill()
    let circle5 = CGRect(x: 400, y: 400, width: 200, height: 200)
    ctx.cgContext.fillEllipse(in: circle5)
}

showOutput(rendered)
//: [< Previous](@previous)           [Home](Introduction)           [Next >](@next)
