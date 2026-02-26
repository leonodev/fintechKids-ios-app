//
//  CameraPermissionService.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import AVFoundation
import UIKit
import Combine
import FHKUtils
import FHKCore
import FHKDomain

final class CameraPermissionService: NSObject, ApplicationService, FHKPermissionProtocol, ObservableObject {
    @Published private(set) var status: PermissionStatus = .notDetermined
    
    // Propiedades del protocolo
    let title: String = "access_camera_title_permission".localized().uppercased()
    let message: String = "access_camera_msn_permission".localized().capitalizingFirstLetter()
    let titleButtonSetting: String = "access_camera_btn_open_setting_permission".localized().capitalizingFirstLetter()
    let titleButtonLater: String = "access_camera_btn_open_skin_permission".localized().capitalizingFirstLetter()

    // MARK: - Initializer
    override init() {
        super.init()
        checkCurrentStatus()
    }

    // MARK: - ApplicationService Lifecycle
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Importante: Re-chequear cuando el usuario vuelve de Ajustes
        checkCurrentStatus()
    }
    
    @MainActor // Asegura que solo se ejecute en el hilo principal
    func checkCurrentStatus() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            self.status = .authorized
        case .denied, .restricted:
            self.status = .denied
        default:
            self.status = .notDetermined
        }
    }
    
    func requestPermission(completion: @escaping (PermissionStatus) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.checkCurrentStatus()
                completion(self.status)
            }
        }
    }
}
