//
//  ContentView.swift
//  Myke.Honk
//
//  Created by Justin Hamilton on 9/3/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var honkController: HonkController = HonkController()
    @StateObject private var animationController: AnimationController = AnimationController()
    private let maxDimConstant: CGFloat = 500
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(uiImage: UIImage(named: "BackgroundTileBlue")!)
                .resizable(resizingMode: .tile)
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            Image(uiImage: UIImage(named: "dormant")!)
                .resizable()
                .padding(.all, 50)
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxWidth: self.maxDimConstant, maxHeight: self.maxDimConstant)
                .shadow(radius: 10)
                .rotationEffect(Angle(degrees: self.animationController.rotationOffset))
                .rotationEffect(Angle(degrees: self.animationController.flipRotation))
                .offset(x: 0, y: self.animationController.floatOffset)
                .scaleEffect(self.animationController.bounceAnimationCurrentScaleFactor)
                .opacity((self.animationController.introIsOpaque) ? 1.0 : 0.0)
                .onTapGesture {
                    self.animationController.runBounce()
                    self.honkController.forceStartPlayer()
                }
                .onLongPressGesture {
                    self.animationController.runFlip()
                }
        }
        .onAppear(perform: {
            self.animationController.start()
        })
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil), perform: {(output) in
            self.honkController.resetPlayer()
        })
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
