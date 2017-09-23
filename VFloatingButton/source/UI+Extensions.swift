//
//  UI+Extensions.swift
//  VFloatingButton
//
//  Created by Luca Davanzo on 30/06/16.
//  Copyright © 2017 Luca Davanzo. All rights reserved.
//

import UIKit

// MARK: - UIView Extension -

internal extension UIView {
    
    // MARK: Constraints
    
    func addGenericConstraint(_ innerView: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: innerView, attribute: attribute, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintsOnAllSides(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        self.addConstraintTop(innerView, multiplier: 1, constant: 0)
        self.addConstraintBottom(innerView, multiplier: 1, constant: 0)
        self.addConstraintLeading(innerView, multiplier: 1, constant: 0)
        self.addConstraintTrailing(innerView, multiplier: 1, constant: 0)
    }
    
    @discardableResult func addConstraintTop(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.top, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintBottom(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.bottom, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintCenterX(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.centerX, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintCenterY(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.centerY, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintLeading(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.leading, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintTrailing(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        return self.addGenericConstraint(innerView, attribute: NSLayoutAttribute.trailing, multiplier: multiplier, constant: constant)
    }
    
    @discardableResult func addConstraintWidth(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let attribute = NSLayoutAttribute.width
        let constraint = NSLayoutConstraint(item: innerView, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: attribute, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult func addConstraintHeight(_ innerView: UIView, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let attribute = NSLayoutAttribute.height
        let constraint = NSLayoutConstraint(item: innerView, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: attribute, multiplier: multiplier, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    // MARK: Layout
    
    func showAsCircle() {
        self.layer.cornerRadius = self.frame.height / 2.0
    }
    
}
