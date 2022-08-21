//
//  CardView.swift
//  PlayfulAnimations
//
//  Created by Sube Barkhasbadi on 8/21/22.
//

import SwiftUI
import CoreMotion

struct CardView: View {
    @Binding var dragLocation: CGPoint? // Coordinates of the drag gesture
    @Binding var isDragging: Bool?
    @Binding var isAirpodEnabled: Bool?
    private var width: CGFloat
    private var height: CGFloat
    private var offset: CGFloat
    private var intensity: CGFloat
    private var motionManager: CMHeadphoneMotionManager

    init(dragLocation: Binding<CGPoint>, isDragging: Binding<Bool>, isAirpodEnabled: Binding<Bool>, width: CGFloat, height: CGFloat, offset: CGFloat, intensity: CGFloat, motionManager: CMHeadphoneMotionManager) {
        _dragLocation = Binding(dragLocation)
        _isDragging = Binding(isDragging)
        _isAirpodEnabled = Binding(isAirpodEnabled)
        self.width = width
        self.height = height
        self.offset = offset
        self.intensity = intensity
        self.motionManager = motionManager
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2)
                .rotation3DEffect(.degrees(Double(dragLocation?.x ?? 0.0)), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(Double(dragLocation?.y ?? 0.0)), axis: (x: 1, y: 0, z: 0))

            VStack(alignment: .trailing) {
                VStack(alignment: .trailing) {
                    Text("🇲🇳")
                }
                .font(Font.system(size: 18, weight: .light, design: .rounded))
                .foregroundColor(Color.white)
                Spacer()
                HStack(alignment: .top) {
                    Image("sube")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading) {
                        Text("Sube Barkhasbadi")
                            .font(Font.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        Text("Designer and Developer")
                            .font(Font.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(Color(UIColor.systemGray2))
                    }
                    Spacer()
                }
            }
            .rotation3DEffect(.degrees(Double(dragLocation?.y ?? 0.0)), axis: (x: 0, y: 1, z: 0))
            .padding()
        }
        .frame(width: width-offset, height: height-offset)
        .onAppear {
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { motionData, error in
                if error != nil {
                    print("error")
                }
                if let motionData = motionData {
                    if isAirpodEnabled ?? false {
                        dragLocation = CGPoint(x: motionData.attitude.yaw * 35, y: -motionData.attitude.pitch * 35)
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let normalizedX = linearScale(
                        inMin: 0,
                        inMax: width - offset,
                        outMin: -intensity,
                        outMax: intensity,
                        value: gesture.location.x
                    )
                    let normalizedY = linearScale(
                        inMin: 0,
                        inMax: height - offset,
                        outMin: intensity,
                        outMax: -intensity,
                        value: gesture.location.y
                    )
                    vibrate()
                    withAnimation((isDragging ?? false) ? .interactiveSpring() : .spring()) {
                        dragLocation = CGPoint(x: normalizedX, y: normalizedY)
                    }
                    isDragging = true
                }
                .onEnded { _ in
                    isDragging = false
                    withAnimation(.spring()) {
                        dragLocation = .zero
                    }
                }
        )

    }

    private func linearScale(inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat, value: CGFloat) -> CGFloat {
        return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
    }

    private func vibrate() {
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
    }
}
