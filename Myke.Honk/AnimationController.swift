//
//  AnimationController.swift
//  AnimationController
//
//  Created by Justin Hamilton on 9/3/21.
//

import Foundation
import SwiftUI

class AnimationController: ObservableObject {
    private let floatOffsetAmount: CGFloat = 7
    @Published var floatOffset: CGFloat = 0
    private let floatAnimationDuration: Double = 2.23
    
    private var startAnimationBounceFactor: CGFloat = 1.05
    private var startAnimationDuration: Double = 0.7
    @Published var introIsOpaque: Bool = false
    
    private let rotationOffsetAmount: Double = 5
    @Published var rotationOffset: Double = 0
    private let rotationAnimationDuration: Double = 1.97
    private var rotationAnimationCycle: Int = 0
    
    private var bounceAnimationScaleFactor: Double = 1.1
    private var bounceAnimationDuration: Double = 0.5
    @Published var bounceAnimationCurrentScaleFactor: CGFloat = 0.05
    
    func runRotation() {
        withAnimation(.easeInOut(duration: self.rotationAnimationDuration)) {
            if(self.rotationAnimationCycle == 4) {
                self.rotationOffset = 0
            } else {
                if(rotationOffset > 0) {
                    rotationOffset = -rotationOffsetAmount
                } else {
                    rotationOffset = rotationOffsetAmount
                }
            }
        }
        
        var durationOffset: Double = 0
        if(self.rotationAnimationCycle == 4) {
            durationOffset = 2.5
            self.rotationAnimationCycle = 0
        } else {
            self.rotationAnimationCycle+=1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+self.rotationAnimationDuration+durationOffset, execute: {
            self.runRotation()
        })
    }
    
    func runFloat() {
        withAnimation(.easeInOut(duration: self.floatAnimationDuration)) {
            if(floatOffset > 0) {
                self.floatOffset = -self.floatOffsetAmount
            } else {
                self.floatOffset = self.floatOffsetAmount
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+self.floatAnimationDuration, execute: {
            self.runFloat()
        })
    }
    
    func runBounce() {
        let leg1Percent = 0.5
        
        withAnimation(.easeOut(duration: self.bounceAnimationDuration*leg1Percent)) {
            self.bounceAnimationCurrentScaleFactor=self.bounceAnimationScaleFactor
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+self.bounceAnimationDuration*leg1Percent, execute: {
            withAnimation(.easeOut(duration: self.bounceAnimationDuration*(1-leg1Percent))) {
                self.bounceAnimationCurrentScaleFactor = 1.0
            }
        })
    }
    
    func runStartAnimation() {
        let leg1Percent = 0.7
        
        withAnimation(.easeOut(duration: self.startAnimationDuration*leg1Percent), {
            self.introIsOpaque = true
            self.bounceAnimationCurrentScaleFactor = self.startAnimationBounceFactor
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+self.startAnimationDuration*leg1Percent, execute: {
            withAnimation(.easeOut(duration: self.startAnimationDuration*(1-leg1Percent)), {
                self.bounceAnimationCurrentScaleFactor = 1.0
            })
        })
    }
    
    @Published var flipRotation: Double = 0.0
    
    func runFlip() {
        let flipDuration: Double = 1.25
        self.flipRotation = 0.0
        withAnimation(.easeInOut(duration: flipDuration)) {
            self.flipRotation = 360.0
        }
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
            self.runStartAnimation()
            self.runFloat()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                self.runRotation()
            })
        })
    }
}
