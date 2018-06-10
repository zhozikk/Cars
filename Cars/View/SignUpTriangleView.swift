//
//  LoginView.swift
//  Cars
//
//  Created by Zho on 20.04.2018.
//  Copyright © 2018 Zho. All rights reserved.

import Foundation
import UIKit
class SignUpTriangleView : UIView {
    
    var move = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.minX), y: rect.minY))
        context.closePath()
        context.setFillColor(red: 94.0/255.0, green: 87.0/255.0, blue: 171.0/255.0, alpha: 1.0)
        context.fillPath()
    }
}

