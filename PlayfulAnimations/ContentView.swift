//
//  ContentView.swift
//  PlayfulAnimations
//
//  Created by Sube Barkhasbadi on 8/21/22.
//

import CameraView
import CoreMotion
import SwiftUI
import UIKit


struct ContentView: View {
    @State private var dragLocation = CGPoint(x: 0, y: 0) // Coordinates of the drag gesture
    @State private var isDragging = false
    @State private var isAirpodEnabled = false
    private let width: CGFloat = 350
    private let height: CGFloat = 250
    private let offset: CGFloat = 4
    private var intensity: CGFloat = 8
    @State var motionManager = CMHeadphoneMotionManager()

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(AngularGradient(gradient: Gradient(colors: [Color("red"), Color("yellow"),Color("green"),Color("teal"),Color("blue"),Color("pink"),Color("red")]), center: .center))
                Color.black
                    .opacity(isDragging || isAirpodEnabled ? 1 : 0.9)
            }
            .ignoresSafeArea()

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(AngularGradient(gradient: Gradient(colors: [Color("red"), Color("yellow"),Color("green"),Color("teal"),Color("blue"),Color("pink"),Color("red")]), center: .center))
                        .frame(width: width, height: height)
                    CardView(dragLocation: $dragLocation, isDragging: $isDragging, isAirpodEnabled: $isAirpodEnabled, width: width, height: height, offset: offset, intensity: intensity, motionManager: motionManager)
                }
                .padding()

                HStack {
                    Spacer()
                    if motionManager.isDeviceMotionAvailable {
                        Button(action: {
                            withAnimation {
                                isAirpodEnabled.toggle()
                            }
                            if isAirpodEnabled == false {
                                dragLocation = .zero
                            }
                        }) {
                            Image(systemName: "airpodspro")
                                .font(.title3)
                                .padding()
                                .background(isAirpodEnabled ? Color.primary : .clear)
                                .clipShape(Circle())
                                .tint(isAirpodEnabled ? .black : .white)
                        }
                    }
                }
                if isAirpodEnabled {
                    CameraView(cameraPosition: .front)
                        .clipShape(Circle())
                        .frame(width: 180, height: 340)
                        .overlay(Circle().stroke(lineWidth: 3))
                }
                Spacer()
            }
            .padding()
        }
    }

    private func linearScale(inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat, value: CGFloat) -> CGFloat {
        return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
