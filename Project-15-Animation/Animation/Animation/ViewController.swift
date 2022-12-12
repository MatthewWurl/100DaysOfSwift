//
//  ViewController.swift
//  Animation
//
//  Created by Matt X on 12/12/22.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let penguin = UIImage(named: "penguin")
        imageView = UIImageView(image: penguin)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    @IBAction func tapButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        
        // No chance of strong reference cycle...
        // Won't hold self strongly... No need for [weak self].
        //        UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5)
        {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(
                    translationX: -256,
                    y: -256
                )
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        } completion: { _ in
            sender.isHidden = false
        }
        
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}
