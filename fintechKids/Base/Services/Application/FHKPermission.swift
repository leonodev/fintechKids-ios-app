//
//  FHKPermission.swift
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
import FHKDesignSystem

@MainActor
public extension FHKPermission {
    
    static var liveCamera: Self {
        var camera = Self()
        
        camera.title = {
            "access_camera_title_permission".localized().uppercased()
        }
        
        camera.message = {
            "access_camera_msn_permission".localized().capitalizingFirstLetter()
        }
        
        camera.titleButtonSetting = {
            "access_camera_btn_open_setting_permission".localized().capitalizingFirstLetter()
        }
        
        camera.titleButtonLater = {
            "access_camera_btn_open_skin_permission".localized().capitalizingFirstLetter()
        }
        
        camera.status = {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                return .authorized
            case .denied, .restricted:
                return .denied
            default:
                return .notDetermined
            }
        }
        
        camera.requestPermission = {
            _ = await AVCaptureDevice.requestAccess(for: .video)
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                return .authorized
            default:
                return .denied
            }
        }
        
        return camera
    }
}
