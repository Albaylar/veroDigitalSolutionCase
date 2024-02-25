//
//  QrVC.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 20.02.2024.
//

import UIKit
import AVFoundation
import SnapKit

class QrVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let scanButton = UIButton()
    let listVC = ListVC()
    let infoLabel = UILabel()
    var isCameraVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupQRScanner()
        if isCameraVisible {
            startQRScanning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopQRScanning()
    }
    
    func setupViews() {
        view.backgroundColor = .gray
        
        infoLabel.text = "Press to the Button to see your own work."
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = .boldSystemFont(ofSize: 40)
        view.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(600)
            
        }
        
        view.addSubview(scanButton)
        scanButton.setTitle("Scan QR Code", for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.layer.cornerRadius = 20
        scanButton.layer.zPosition = 1
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    func setupQRScanner() {
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error)
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.layer.addSublayer(previewLayer)
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            print(stringValue)
            
            
            let alert = UIAlertController(title: "QR Code Detected", message: "Would you like to navigate to the scanned QR code?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Go", style: .default) { _ in
                
                self.captureSession.stopRunning()
                self.performSearch(with: stringValue)
                self.listVC.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func startQRScanning() {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func stopQRScanning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func performSearch(with searchText: String) {
        listVC.searchBar.text = searchText
        listVC.searchForText(searchText)
        listVC.tableView.reloadData()
        listVC.searchBar.resignFirstResponder()
        listVC.modalPresentationStyle = .popover
        self.present(listVC, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            performSearch(with: searchText)
        }
    }
    
    @objc func dismissListVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func scanButtonTapped() {
        
        if isCameraVisible {
            stopQRScanning()
            scanButton.setTitle("Scan QR Code", for: .normal)
            
        } else {
            startQRScanning()
            scanButton.setTitle("Stop Scanning", for: .normal)
        }
        isCameraVisible.toggle()
        previewLayer.isHidden = !isCameraVisible
    }
}




