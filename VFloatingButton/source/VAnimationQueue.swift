//
//  VAnimationQueue.swift
//  VFloatingButton
//
//  Created by Luca Davanzo on 01/07/16.
//  Copyright © 2017 Luca Davanzo. All rights reserved.
//

import Foundation

internal class VAnimation: NSObject {
    
    /// An animation is represented by a closure
    typealias Animation = () -> Void
    
    // MARK: Public properties
    
    var action: (Animation)?
    var isAnimating = false
}

internal class VAnimationQueue: NSObject {
    
    // MARK: - Public properties -
    
    var maxAnimationInQueue = 2
    
    // MARK: - Private properties -
    
    fileprivate var animations = [VAnimation]()
    
    // MARK: - Public methods -
    
    /// Add an animation to the queue. Animation will be processed immediately.
    ///
    /// - Parameter animation: animation to execute
    func addAnimation(_ animation: VAnimation) {
        if self.animations.count < self.maxAnimationInQueue {
            self.animations.append(animation)
            self.performAnimations()
        }
    }
    
    /// Call this method when animation have finished.
    ///
    /// - Parameter animation: animation
    func animationDidFinish(animation: VAnimation) {
        animation.isAnimating = false
        if let _ = self.animations.first {
            self.animations.removeFirst()
        }
        self.performAnimations()
    }
    
    // MARK: - Private method -
    
    /// Perfom the animation only if previous animation on the queue has finished.
    fileprivate func performAnimations() {
        if let a = self.animations.first {
            if !a.isAnimating {
                a.isAnimating = true
                a.action?()
            } else {
                print("animation not yet finished")
            }
        }
    }
    
}
