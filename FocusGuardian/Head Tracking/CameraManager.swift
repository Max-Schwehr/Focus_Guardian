import Foundation
import AVFoundation
import Vision
import Combine
import CoreMedia;
import SwiftUI

enum YawDirection {
    case humanLeft
    case humanCenter
    case humanRight
}

/// Manages camera capture and face orientation detection.
///
/// - Starts/stops an AVCaptureSession on a background queue.
/// - Provides yaw, pitch, and roll (in degrees) via `@Published` properties for UI consumption.
/// - Publishes `hasFace` to indicate whether a face is currently detected.
///
/// Usage:
/// ```swift
/// @StateObject private var camera = CameraManager()
/// // In a SwiftUI view:
/// .onAppear { camera.requestAccessAndConfigure() }
/// .onDisappear { camera.stop() }
/// ```
final class CameraManager: NSObject, ObservableObject {
    private var frameCount = 0

    @Published var yawDirection: YawDirection? = nil
    /// Pitch angle in degrees (looking up is positive). `nil` if unavailable.

    @Published var hasFace: Bool = false
    /// Current camera authorization status. Updated on the main thread.

    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private let videoOutputQueue = DispatchQueue(label: "VideoOutputQueue")
    
    /// Requests camera access if needed and configures/starts the capture session when authorized.
    /// Safe to call multiple times; configuration occurs on a background queue.
    func requestAccessAndConfigure() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.authorizationStatus = granted ? .authorized : .denied
                }
                if granted {
                    self.sessionQueue.async {
                        self.configureSession()
                    }
                }
            }
        case .authorized:
            sessionQueue.async {
                self.configureSession()
            }
        default:
            break
        }
    }
    
    // MARK: - Session Configuration
    /// Configures the AVCaptureSession with the front wide-angle camera when available,
    /// sets up a video data output, and starts the session.
    ///
    /// The output delivers frames to `captureOutput(_:didOutput:from:)` on `videoOutputQueue`.
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high
        
        let device: AVCaptureDevice?
        if let frontDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            device = frontDevice
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        }
        
        guard let camera = device else {
            session.commitConfiguration()
            return
        }
        
        session.inputs.forEach { input in
            session.removeInput(input) // Clean up previous inputs if any
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                session.commitConfiguration()
                return
            }
        } catch {
            session.commitConfiguration()
            return
        }
        
        session.outputs.forEach { output in
            session.removeOutput(output) // Clean up previous outputs if any
        }
        
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        } else {
            session.commitConfiguration()
            return
        }
        
        if let connection = videoOutput.connection(with: .video) {
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = (camera.position == .front)
            }
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    /// Stops the capture session if it is running. Executed on the session queue.
    func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                self.hasFace = false
            }
        }
    }
}

// MARK: - Process and Output Camera Feed
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func faceOrientation(in pixelBuffer: CVPixelBuffer) -> (yaw: Double?, hasFace: Bool) {
         let sequenceHandler = VNSequenceRequestHandler()

        let request = VNDetectFaceLandmarksRequest()
        do {
            try sequenceHandler.perform([request], on: pixelBuffer)
        } catch {
            return (nil, false)
        }
        guard let face = request.results?.first as? VNFaceObservation else {
            return (nil, false)
        }

        return (face.yaw?.doubleValue, true)
    }

    
    /// Receives frames from the capture session, runs Vision face detection, and publishes results.
    /// - Note: Vision returns angles in radians. We convert to degrees for UI readability.
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // Extract the CVPixelBuffer from the CMSampleBuffer; skip if unavailable.
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        frameCount += 1
        if frameCount % 45 != 0 {
            return
        }

        // Detect face orientation in radians using Vision.
        let facing = faceOrientation(in: pixelBuffer)

        // Convert radians to degrees for presentation.
        let yawDegrees: Double? = facing.yaw.map { $0 * 180.0 / .pi }
        
        var yawDirection: YawDirection? = nil
        if let yawDegreesUnwrapped = yawDegrees {
            if (yawDegreesUnwrapped > 30) {
                yawDirection = .humanLeft
            } else if (yawDegreesUnwrapped < -30) {
                yawDirection = .humanRight
            } else {
                yawDirection = .humanCenter
            }
        }
       
        // Publish to observers on the main thread.
        DispatchQueue.main.async {
            self.yawDirection = yawDirection
//            withAnimation {
                self.hasFace = facing.hasFace
//            }
        }
    }
}

