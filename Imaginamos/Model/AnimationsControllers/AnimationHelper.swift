//
//  AnimationHelper.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/14/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit

// MARK: Frame Extensions

struct AnimationHelper{
    static func yRotation(angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(forContainerView containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}
