//
//  FaceRotationChart.swift
//
//  Created by Maximiliaen Schwehr on 10/17/25.
//

import SwiftUI
import Charts

struct FaceRotationChart: View {
    let chartWidth = 400
    let chartHeight = 75
    let verticalBar1x: CGFloat = 400
    let xPositions: [Double] = [-45, 0, 45]
    @StateObject private var camera = CameraManager()
    @State var dotXPosition = 0.0
    @State var isRunning = false
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Chart {
                        PointMark(
                            x: .value("X", dotXPosition),
                            y: .value("Y", 0.0)
                        )
                        .foregroundStyle(.clear) // hide default point rendering
                        .annotation(position: .overlay, alignment: .center) {
                            FaceMarkView()
                        }
                    }
                    .frame(height: CGFloat(chartHeight))
                    .onAppear {  }
                    .onDisappear { camera.stop() }
                    .onChange(of: camera.yawDirection) { oldValue, newValue in
                        withAnimation {
                            switch newValue {
                            case .humanCenter:
                                dotXPosition = 0.0
                            case .humanLeft:
                                dotXPosition = -45
                            case .humanRight:
                                dotXPosition = 45
                            default:
                                dotXPosition = 0.0
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom, values: .stride(by: 45)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            AxisValueLabel(anchor: .top) {
                                if let number = value.as(Double.self) {
                                    switch Int(number) {
                                    case -45:
                                        Image(systemName: "arrow.up.backward.circle")
                                            .imageScale(.medium)
                                            .frame(width: 20, height: 20, alignment: .center)
                                    case 0:
                                        Image(systemName: "arrow.up.circle")
                                            .imageScale(.medium)
                                            .frame(width: 20, height: 20, alignment: .center)
                                    case 45:
                                        Image(systemName: "arrow.up.forward.circle")
                                            .imageScale(.medium)
                                            .frame(width: 20, height: 20, alignment: .center)
                                    default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .chartXScale(domain: -45.0...45.0, range: .plotDimension(startPadding: 16, endPadding: 16))            .chartYAxis {
                        AxisMarks(position: .leading) { _ in
                            AxisGridLine(stroke: StrokeStyle(dash: [2, 6]))
                                .foregroundStyle(.gray.opacity(0.3))
                            AxisTick()
                            // No AxisValueLabel to hide y-axis numbers
                        }
                    }
                    .chartPlotStyle { plotArea in
                        plotArea.padding(.horizontal, 0)
                    }
                    .chartYScale(domain: -0...0)
                    .frame(width: CGFloat(chartWidth), height: CGFloat(chartHeight))
                }
                .blur(radius: camera.hasFace ? 0.0 : 10.0)
                .animation(.default, value: camera.hasFace)
                
                if isRunning {
                    Button(action: {
                        isRunning = false
                        camera.stop()
                    }) {
                        Label("Pause", systemImage: "pause.fill")
                    }
                    .buttonStyle(.glass) // Apply the system's 'glass' button style
                }
            }
            
            VStack {
                if (!isRunning) {
                    Button(action: {
                        isRunning = true
                        camera.requestAccessAndConfigure()
                    }, label: {
                        Text("Start Head tracking")
                    })
                    .animation(.default, value: camera.hasFace)
                } else if (!camera.hasFace) {
                    Text("No Face Found")
                        .animation(.default, value: camera.hasFace)
                }
            }
        }
        
    }
}

struct FaceMarkView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemBlue))
                .shadow(color: .blue.opacity(0.25), radius: 6, x: 0, y: 3)
        }
        .frame(width: 20, height: 20)
        .overlay(
            Circle()
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
        )
        .accessibilityHidden(true)
    }
}

#Preview {
    FaceRotationChart()
        .padding()
}

#Preview {
    FaceMarkView()
        .padding()
}

