//
//  VFloatingButtonProperties.swift
//  VFloatingButton
//
//  Created by Luca Davanzo on 30/06/16.
//  Copyright © 2017 Luca Davanzo. All rights reserved.
//

import Foundation
import UIKit

/// Available FAB's animation versus.
public enum VFloatingButtonAnimationVersus: String {
    case none
    case top
    case bottom
    case right
    case left
    case faraway
}

/// Available FAB's idle position.
public enum VFloatingButtonPosition {
    case topLeft
    case topRight
    case topCenter
    case center
    case centerLeft
    case centerRight
    case bottomLeft
    case bottomRight
    case bottomCenter
}

/// Available FAB's animation on user interaction
///
/// - none:    No animation.
/// - exit:    Exit animation (@see 'exitAnimation')
/// - magnify: Enlarge button until fullfill container view.
public enum VFloatingButtonAnimationOnTap {
    case none
    case exit
    case magnify
}

/// Struct that encapsulate FAB's properties.
public struct VFloatingButtonProperties {
    
    // Constructor
    
    /// Default constructor.
    public init() {}
    
    // Appearance
    
    /// Default button container height.
    public var height: CGFloat = 40.0
    /// Default button container wifth.
    public var width: CGFloat = 40.0
    /// Default button container horizontal margin. It is an asbolute value.
    public var horizontalMargin: CGFloat = 16.0
    /// Default button container vertical margin. It is an asbolute value.
    public var verticalMargin: CGFloat = 16.0
    /// Default button container background color.
    public var backgroundColor: UIColor = .clear
    /// Default button background color.
    public var viewButtonBackgroundColor: UIColor = .clear
    /// Default shape for the button. If false, shape will be a CGRect with layer.cornerRadius = 0.0
    public var circleShape = true
    
    // Animation
    
    /// Default delay for entry animation.
    public var animationEntryDelay: TimeInterval = 0.0
    /// Default duration for entry animation.
    public var animationEntryDuration: TimeInterval = 1.0
    /// Default delay for exit animation.
    public var animationExitDelay: TimeInterval = 0.0
    /// Default duration for exit animation.
    public var animationExitDuration: TimeInterval = 1.0
    /// Specify animation type on user's tap.
    public var animationOnTap: VFloatingButtonAnimationOnTap = .exit
    
    // Position
    
    /// Default FAB's idle position.
    public var idlePosition: VFloatingButtonPosition = .bottomRight
    /// Default FAB's entry animation.
    public var entryAnimation: VFloatingButtonAnimationVersus = .left
    /// Default FAB's exit animation.
    public var exitAnimation: VFloatingButtonAnimationVersus = .left
    
    // Other
    
    /// Specify if animate FAB with the scrollView scrolling.
    public var animateWithScrollView = true
    /// Represent how much view is out of the screen in case of entry/exit animation: by default is equal to view size
    public var entryAnimationDistance: CGFloat = 40.0
    
}
