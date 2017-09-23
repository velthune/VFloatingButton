//
//  VFloatingButton.swift
//  VFloatingButton
//
//  Created by Luca Davanzo on 30/06/16.
//  Copyright © 2017 Luca Davanzo. All rights reserved.
//

import Foundation
import UIKit

/// Delegate for VFloatingButton.
@objc
public protocol VFloatingButtonDelegate: NSObjectProtocol {
    
    /// Called when FAB begins entry animation.
    @objc optional func floatingButtonWillAppear(floatingButton: VFloatingButton)
    
    /// Called when FAB ends entry animation.
    @objc optional func floatingButtonDidAppear(floatingButton: VFloatingButton)
    
    /// Called when FAB begins exit animation.
    @objc optional func floatingButtonWillDisappear(floatingButton: VFloatingButton)
    
    ///  Called when FAB ends exit animation.
    @objc optional func floatingButtonDidDisappear(floatingButton: VFloatingButton)
    
    /// Called when user tap on FAB.
    @objc optional func floatingButtonDidTapOnButton()
}

internal enum ScrollViewDirection {
    case up
    case down
    case none
}

/// Represent a view with an UIButton as subview.
open class VFloatingButton: UIView, UIScrollViewDelegate {
    
    // MARK: - Public properties -
    
    /// FAB's properties such as appearance, animation etc.
    open var properties = VFloatingButtonProperties()
    /// View for button. By default is a button.
    open var viewButton: UIView = UIButton()
    /// Delegate
    open weak var delegate: VFloatingButtonDelegate?
    
    // MARK: - Private properties -
    
    fileprivate var idlePosition = CGRect.zero
    fileprivate var initialEntryPosition = CGRect.zero
    fileprivate var finalExitPosition = CGRect.zero
    fileprivate var scrollView: UIScrollView?
    fileprivate var lastContentOffset: CGFloat = 0
    fileprivate var scrollDirection: ScrollViewDirection = .none
    fileprivate var animationQueue = VAnimationQueue()
    fileprivate var frameContainer = CGRect.zero
    
    // MARK: - Constructors -
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// Init FloatingButton specifying frame of the container view and button properties
    ///
    /// - Parameters:
    ///   - frameContainer: container in which floating button is in
    ///   - properties: properties for the floating button
    public init(frameContainer: CGRect, properties: VFloatingButtonProperties? = nil) {
        super.init(frame: CGRect.zero)
        if let p = properties {
            self.properties = p
        }
        let frame = self.calculcateIdlePosition(frameContainer)
        // Save idle and initial position
        self.idlePosition = frame
        self.frame = frame
        self.frameContainer = frameContainer
        self.refresh()
        self.setup()
    }
    
    /// Required initializer for UIView
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setup() {
        self.backgroundColor = properties.backgroundColor
        self.viewButton.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        self.viewButton.backgroundColor = self.properties.viewButtonBackgroundColor
        self.addSubview(self.viewButton)
        if let button = self.viewButton as? UIButton {
            button.addTarget(self, action:#selector(self.didTapOnFloatingButton), for: .touchUpInside)
        }
        if self.properties.circleShape {
            self.applyCircleEffect()
        }
    }
    
    /// Draw view as a circle. It is possibile only when both width and height are equals
    ///
    /// - Returns: true if circle shape could be drawn
    @discardableResult fileprivate func applyCircleEffect() -> Bool {
        guard self.properties.height == self.properties.width else {
            return false
        }
        self.showAsCircle()
        self.viewButton.showAsCircle()
        return true
    }
    
    fileprivate func calculcateInitialPosition(_ frameContainer: CGRect, versus: VFloatingButtonAnimationVersus) -> CGRect {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        switch versus {
        case .none :
            return self.frame
        case .top :
            x = self.frame.origin.x
            y = frameContainer.origin.y - self.properties.entryAnimationDistance - self.properties.height / 2.0
        case .bottom :
            x = self.frame.origin.x
            y = frameContainer.origin.y + frameContainer.height + self.properties.entryAnimationDistance
        case .right :
            x = frameContainer.origin.x + frameContainer.width + self.properties.entryAnimationDistance
            y = self.frame.origin.y
        case .left :
            x = frameContainer.origin.x - self.properties.entryAnimationDistance - self.properties.width / 2.0
            y = self.frame.origin.y
        case .faraway:
            let center = self.center
            return CGRect(x: center.x, y: center.y, width: 1, height: 1)
        }
        return CGRect(x: x, y: y, width: self.properties.width, height: self.properties.height)
    }
    
    fileprivate func calculcateIdlePosition(_ frameContainer: CGRect) -> CGRect {
        let containerWidth = frameContainer.width
        let containerHeight = frameContainer.height
        let containerOriginX = frameContainer.origin.x
        let containerOriginY = frameContainer.origin.y
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        switch self.properties.idlePosition {
        case .topLeft :
            x = containerWidth - self.properties.width - self.properties.horizontalMargin
            y = self.properties.verticalMargin
        case .topRight :
            x = containerOriginX + containerWidth - self.properties.width - self.properties.horizontalMargin
            y = containerOriginY + properties.verticalMargin
        case .topCenter :
            x = ((containerOriginX + containerWidth) / 2.0 - self.properties.width / 2.0)
            y = containerOriginY + properties.verticalMargin
        case .center :
            x = ((containerOriginX + containerWidth) / 2.0 - self.properties.width / 2.0)
            y = ((containerOriginY + containerHeight) / 2.0 - self.properties.height / 2.0)
        case .centerLeft :
            x = containerOriginX + self.properties.horizontalMargin
            y = ((containerOriginY + containerHeight) / 2.0 - self.properties.height / 2.0)
        case .centerRight :
            x = containerOriginX + containerWidth - self.properties.width - self.properties.horizontalMargin
            y = ((containerOriginY + containerHeight) / 2.0 - self.properties.height / 2.0)
        case .bottomLeft :
            x = containerOriginX + self.properties.horizontalMargin
            y = containerOriginY + containerHeight - self.properties.height - self.properties.verticalMargin
        case .bottomRight :
            x = containerOriginX + containerWidth - self.properties.width - self.properties.horizontalMargin
            y = containerOriginY + containerHeight - self.properties.height - self.properties.verticalMargin
        case .bottomCenter :
            x = ((containerOriginX + containerWidth) / 2.0 - self.properties.width / 2.0)
            y = containerOriginY + containerHeight - self.properties.height - self.properties.verticalMargin
        }
        return CGRect(x: x, y: y, width: self.properties.width, height: self.properties.height)
    }
    
    // MARK: - Public methods -
    
    /// Choosing this option, floating button will appear/disappear following scroll view
    ///
    /// - Parameter scrollView: observable scroll view
    open func observeScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        self.scrollView?.delegate = self
    }
    
    /// Hide FAB. You can choose whether to animate the status change
    ///
    /// - Parameter animated: animated
    open func hide(animated: Bool = false) {
        self.delegate?.floatingButtonWillDisappear?(floatingButton: self)
        let duration: TimeInterval? = animated ? nil : 0
        self.animate(show: false, forcedDuration: duration)
    }
    
    /// Show FAB. You can choose whether to animate the status change.
    ///
    /// - Parameter animated: animated
    open func show(animated: Bool = false) {
        self.alpha = 1.0
        self.delegate?.floatingButtonWillAppear?(floatingButton: self)
        let duration: TimeInterval? = animated ? nil : 0
        self.animate(show: true, forcedDuration: duration)
    }
    
    /// Check if FAB is visible.
    ///
    /// - Returns: true if not hidden (alpha == 0) && in screen
    open func isVisible() -> Bool {
        return self.alpha == 0.0 && self.idlePosition == self.frame
    }
    
    ///  Set FAB's image
    ///
    /// - Parameters:
    ///   - name: image name
    ///   - state: button state (@see UIControlState)
    ///   - contentMode: imageView content mode, ScaleAspectFit by default
    open func setImage(named name: String, forState state: UIControlState, contentMode: UIViewContentMode = .scaleAspectFit) {
        if let button = self.viewButton as? UIButton {
            if let image = UIImage(named: name) {
                button.setImage(image, for: state)
                button.imageView?.contentMode = contentMode
            } else {
                print("VFloatingButton warning: no images for name \"\(name)\".")
            }
        }
    }
    
    /// Each time you programmatically change some properties's attribute you may need to call this method.
    open func refresh() {
        self.initialEntryPosition = self.calculcateInitialPosition(self.frameContainer, versus: self.properties.entryAnimation)
        self.finalExitPosition = self.calculcateInitialPosition(self.frameContainer, versus: self.properties.exitAnimation)
    }
    
    /// Facility to show a border shadow around FAB
    ///
    /// - Parameters:
    ///   - color: shadow color
    ///   - radius: shadow radius
    ///   - opacity: shadow opacity
    ///   - shadowOffset: shadow offset
    open func showBordersShadow(color: UIColor = .black, radius: CGFloat = 2.0, opacity: Float = 0.8, shadowOffset: CGFloat = 0.2) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        self.layer.shadowOpacity = 0.8
    }
    
    internal func didTapOnFloatingButton() {
        self.delegate?.floatingButtonDidTapOnButton?()
        switch self.properties.animationOnTap {
        case .none:
            return
        case .exit:
            self.delegate?.floatingButtonWillDisappear?(floatingButton: self)
            self.scrollDirection = .none
            self.animate(show: false)
        case .magnify:
            self.magnify()
            break
        }
    }
    
    internal func magnify() {
        self.delegate?.floatingButtonWillDisappear?(floatingButton: self)
        var screen = UIScreen.main.bounds
        let size = max(screen.width, screen.height)
        screen = CGRect(x: 0, y: 0, width: size, height: size)
        self.backgroundColor = .red
        UIView.animate(withDuration: 0.6, animations: {
            self.transform = CGAffineTransform(scaleX: 20, y: 20)
            self.alpha = 0.0
        }, completion: { (finish: Bool) in
            self.delegate?.floatingButtonDidDisappear?(floatingButton: self)
        })
        self.layoutIfNeeded()
        self.scrollDirection = .none
    }
    
    // MARK: - Private methods -
    
    fileprivate func animate(show: Bool, forcedDuration: TimeInterval? = nil) {
        var toPosition = CGRect.zero
        var duration: TimeInterval = 0.0
        var delay: TimeInterval = 0.0
        if show {
            toPosition = self.idlePosition
            duration = forcedDuration ?? self.properties.animationEntryDuration
            delay = self.properties.animationEntryDelay
        } else {
            toPosition = self.finalExitPosition
            duration = forcedDuration ?? self.properties.animationExitDuration
            delay = self.properties.animationExitDelay
        }
        if self.properties.entryAnimation == .faraway {
            self.performCircleAnimation(show: show, duration: duration, delay: delay)
        } else {
            self.performDefaultAnimation(show: show, duration: duration, delay: delay, toPosition: toPosition)
        }
        self.layoutIfNeeded()
    }
    
    fileprivate func performCircleAnimation(show: Bool, duration: TimeInterval, delay: TimeInterval) {
        let animation = VAnimation()
        animation.action = {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 2.0, initialSpringVelocity: 1.0, options: [], animations: {
                if show {
                    self.alpha = 1.0
                    self.transform = CGAffineTransform.identity
                } else {
                    self.alpha = 0.0
                    self.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                }
            }) { (_: Bool) in
                self.notifyDelegateDidAppear(isViewVisible: show)
                self.animationQueue.animationDidFinish(animation: animation)
            }
        }
        self.animationQueue.addAnimation(animation)
    }
    
    fileprivate func performDefaultAnimation(show: Bool, duration: TimeInterval, delay: TimeInterval, toPosition: CGRect) {
        let a = VAnimation()
        a.action = {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 2.0, initialSpringVelocity: 1.0, options: [], animations: {
                self.frame = toPosition
                self.layoutIfNeeded()
            }) { (_: Bool) in
                if !show {
                    self.frame = self.initialEntryPosition
                }
                self.notifyDelegateDidAppear(isViewVisible: show)
                self.animationQueue.animationDidFinish(animation: a)
            }
        }
        self.animationQueue.addAnimation(a)
    }
    
    fileprivate func notifyDelegateDidAppear(isViewVisible visible: Bool) {
        if visible {
            self.delegate?.floatingButtonDidAppear?(floatingButton: self)
        } else {
            self.delegate?.floatingButtonDidDisappear?(floatingButton: self)
        }
    }
    
    // MARK: - Scroll view delegates -
    
    /// Scrollview's callback: called on any offset changes.
    ///
    /// - Parameter scrollView: scrollView
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.properties.animateWithScrollView, scrollView.contentOffset.y >= 0 else {
            return
        }
        let previousDirection = self.scrollDirection
        let currentVerticalOffset = scrollView.contentOffset.y
        if (self.lastContentOffset > currentVerticalOffset) {
            self.scrollDirection = .up
            if previousDirection != self.scrollDirection {
                self.show(animated: true)
            }
        } else if (self.lastContentOffset < currentVerticalOffset) {
            self.scrollDirection = .down
            if previousDirection != self.scrollDirection {
                self.hide(animated: true)
            }
        }
        self.lastContentOffset = currentVerticalOffset
    }
    
}
