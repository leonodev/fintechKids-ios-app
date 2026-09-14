//
//  FHKPermission+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 11/9/26.
//

import AVFoundation
import UIKit
import Combine
import FLibUtils

@MainActor
public extension FHKPermission {
    
    static var live: Self {
        var camera = Self()
        
        camera.title = {
            "access_camera_title_permission"
        }
        
        camera.message = {
            "access_camera_msn_permission"
        }
        
        camera.titleButtonSetting = {
            "access_camera_btn_open_setting_permission"
        }
        
        camera.titleButtonLater = {
            "access_camera_btn_open_skin_permission"
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
