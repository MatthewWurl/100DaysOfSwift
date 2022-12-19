//
//  ViewController.swift
//  Debugging
//
//  Created by Matt X on 12/19/22.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad() method.")
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        
        assert(1 == 1, "Math failure.")
//        assert(1 == 2, "Math failure.") // Will fail...
        
//        assert(
//            reallySlowMethod() == true,
//            "The slow method returned false, which is a bad thing"
//        )
        
        // Experimenting with breakpoints...
        for i in 1...100 {
            print("Got number \(i).")
        }
    }
}
