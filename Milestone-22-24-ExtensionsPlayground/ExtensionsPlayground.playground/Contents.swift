import UIKit

// MARK: - Challenge 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        Self.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 2.5)

// MARK: - Challenge 2
extension Int {
    func times(_ closure: @escaping (() -> Void)) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

// Will print "It's going to rain!" 3 times...
3.times {
    print("It's going to rain!")
}

// MARK: - Challenge 3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return } // Bail out if item doesn't exist...
        
        self.remove(at: index)
    }
}

var arr1 = [5, 6, 8, 2, 6, -1, 0]
arr1.remove(item: 6) // Will remove the first instance at index 1...

var arr2 = ["Monday", "Wednesday", "Thursday", "Saturday"]
arr2.remove(item: "Sunday") // Will not do anything since "Sunday" is not in array...
