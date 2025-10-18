import Foundation
import AVFoundation
import Vision
import Combine
import CoreMedia

// macOS target: use NSViewRepresentable for preview layer

final class CameraManager: NSObject, ObservableObject {
    @Published var roll : Double? = nil
    @Published var yaw : Double? = nil
    @Published var pitch: Double? = nil
    @Published var hasFace : Bool = false
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
    private let videoOutput = AVCaptureVideoDataOutput()
    private let faceDetector = FaceDetector()
    
    private let videoOutputQueue = DispatchQueue(label: "VideoOutputQueue")
    
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
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = (camera.position == .front)
            }
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            // Could not get pixel buffer; skip this frame
            return
        }
        let facing = faceDetector.faceOrientation(in: pixelBuffer) // (yaw, roll, hasFace)
        
        // Estimate pitch (not directly provided by Vision). Heuristic: vertical offset of face center from image center.
        // VNFaceObservation returns roll and yaw; to approximate pitch, we use the boundingBox's center.y relative to frame center.
        // boundingBox is in normalized coordinates (0..1), origin at bottom-left.
        var pitchDegrees: Double? = nil
        do {
            let request = VNDetectFaceRectanglesRequest()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            try handler.perform([request])
            if let face = request.results?.first as? VNFaceObservation {
                let centerY = face.boundingBox.midY // 0..1
                let offset = (centerY - 0.5) // positive if above center
                // Map offset to degrees; scale factor chosen empirically
                let scale: Double = -60.0 // negative so face higher => looking down (positive pitch down)
                pitchDegrees = offset * scale
            }
        } catch {
            // ignore pitch estimate errors
        }

        // Convert radians to degrees if available
        // Use values from faceDetector.faceOrientation for yaw and roll.
        // Note: Accuracy limited by Vision, lighting, and camera quality.
        let yawDegrees: Double? = facing.yaw.map { $0 * 180.0 / .pi }
        let rollDegrees: Double? = facing.roll.map { $0 * 180.0 / .pi }

        DispatchQueue.main.async {
            self.roll = rollDegrees
            self.yaw = yawDegrees
            self.pitch = pitchDegrees
            self.hasFace = facing.hasFace
        }
    }
}
