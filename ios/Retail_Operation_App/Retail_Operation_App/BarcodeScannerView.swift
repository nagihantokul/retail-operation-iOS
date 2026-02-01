@preconcurrency import AVFoundation
import SwiftUI

enum BarcodeScannerError: LocalizedError {
	case cameraUnavailable
	case cameraPermissionDenied

	var errorDescription: String? {
		switch self {
		case .cameraUnavailable:
			return "Camera is not available on this device."
		case .cameraPermissionDenied:
			return "Camera permission is denied. Enable it in Settings to scan barcodes."
		}
	}
}

struct BarcodeScannerView: UIViewControllerRepresentable {
	var onCode: (String) -> Void
	var onError: (Error) -> Void

	func makeUIViewController(context: Context) -> ScannerViewController {
		let controller = ScannerViewController()
		controller.onCode = onCode
		controller.onError = onError
		return controller
	}

	func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

@MainActor
final class ScannerViewController: UIViewController {
    var onCode: ((String) -> Void)?
    var onError: ((Error) -> Void)?

    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var hasReportedResult = false
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            onError?(BarcodeScannerError.cameraUnavailable)
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [
                    .ean13, .ean8, .upce, .code128, .qr
                ]
            }

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(layer)
            previewLayer = layer
        } catch {
            onError?(error)
        }
    }

	    private func start() {
	        Task {
	            let status = AVCaptureDevice.authorizationStatus(for: .video)
	            switch status {
	            case .authorized:
	                startRunningSession()
	            case .notDetermined:
	                let granted = await AVCaptureDevice.requestAccess(for: .video)
	                if granted {
	                    startRunningSession()
	                } else {
	                    onError?(BarcodeScannerError.cameraPermissionDenied)
	                }
	            default:
	                onError?(BarcodeScannerError.cameraPermissionDenied)
	            }
	        }
	    }

	    private func startRunningSession() {
	        let captureSession = session
	        sessionQueue.async {
	            guard !captureSession.isRunning else { return }
	            captureSession.startRunning()
	        }
	    }

	    private func stop() {
	        let captureSession = session
	        sessionQueue.async {
	            guard captureSession.isRunning else { return }
	            captureSession.stopRunning()
	        }
	    }
	}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue, !value.isEmpty else { return }

        Task { @MainActor in
            guard !self.hasReportedResult else { return }
            self.hasReportedResult = true
            self.stop()
            self.onCode?(value)
        }
    }
}
