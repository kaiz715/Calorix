//
//  CameraManager.swift
//  Calorix
//
//  Created by Kai Zheng on 5/13/25.
//


import AVFoundation
import CoreImage


class CameraManager: NSObject {
    
    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var photoOutput: AVCapturePhotoOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)

    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    private var addToPhotoStream: ((AVCapturePhoto) -> Void)?
    
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    lazy var photoStream: AsyncStream<AVCapturePhoto> = {
        AsyncStream { continuation in
            addToPhotoStream = { photo in
                continuation.yield(photo)
            }
        }
    }()
    
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    override init() {
        super.init()
        
        Task {
            await configureSession()
            await startSession()
        }
        
    }
    
    private func configureSession() async {
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }
        
        captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        let photoOutput = AVCapturePhotoOutput()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let videoOutput = AVCaptureVideoDataOutput()
       
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            return
        }
        
        guard captureSession.canAddOutput(photoOutput) else {
            print("cannot add photooutput")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(photoOutput)
        
        self.deviceInput = deviceInput
        self.videoOutput = videoOutput
        self.photoOutput = photoOutput
        
        photoOutput.maxPhotoQualityPrioritization = .quality
        

        //For a vertical orientation of the camera stream
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }
    
    
    private func startSession() async {
        guard await isAuthorized else { return }
        captureSession.startRunning()
    }
    
    private func rotate(by angle: CGFloat, from connection: AVCaptureConnection) {
        guard connection.isVideoRotationAngleSupported(angle) else { return }
        connection.videoRotationAngle = angle
    }
    
    func takePhoto() {
        guard let photoOutput = self.photoOutput else {
            print("no photo output")
            return
        }
        
        sessionQueue.async {
        
            var photoSettings = AVCapturePhotoSettings()

            if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
            photoSettings.flashMode = isFlashAvailable ? .auto : .off
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .balanced
            
//            if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
//                if photoOutputVideoConnection.isVideoOrientationSupported,
//                    let videoOrientation = self.videoOrientationFor(self.deviceOrientation) {
//                    photoOutputVideoConnection.videoOrientation = videoOrientation
//                }
//            }
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }

}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else {
            print("Can't translate to CGImage")
            return
        }
        addToPreviewStream?(currentFrame)
    }
    
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        addToPhotoStream?(photo)
    }
}


extension CMSampleBuffer {
    var cgImage: CGImage? {
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        guard let imagePixelBuffer = pixelBuffer else { return nil }
        return CIImage(cvPixelBuffer: imagePixelBuffer).cgImage
    }
}

extension CIImage {
    var cgImage: CGImage? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return cgImage
    }
}
