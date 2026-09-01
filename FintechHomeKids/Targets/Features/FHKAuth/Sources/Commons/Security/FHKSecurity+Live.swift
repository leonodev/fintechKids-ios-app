//
//  FHKSecurity+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import CommonCrypto
import CryptoKit
import LocalAuthentication
import FHKCore

// MARK: - Live Implementation
public extension FHKSecurity {
    static var live: Self {
        var manager = Self()
        
        manager.getBiometryType = {
            Self.liveGetBiometryType()
        }
        
        manager.biometryIcon = {
            Self.liveBiometryIcon()
        }
        
        manager.getAnonKey = {
            try Self.liveGetAnonKey()
        }
        
        return manager
    }
    
    // MARK: - Private Helpers (Lógica Real)
    static func liveGetBiometryType() -> BiometryType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }
    
    static func liveBiometryIcon() -> String {
        switch liveGetBiometryType() {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return ""
        }
    }
    
    static func liveGetAnonKey() throws -> String {
        let xorKey = FHKSecurityConstants.XOR_KEY
        
        // Des-ofuscar key Root
        let rootKeyBytes = deobfuscate(bytes: FHKSecurityConstants.OBSCURED_KEY_BYTES, key: xorKey)
        let rootKey = SymmetricKey(data: rootKeyBytes)
        
        // Des-ofuscar el IV y el Tag
        let ivBytes = deobfuscate(bytes: FHKSecurityConstants.OBSCURED_IV_BYTES, key: xorKey)
        let tagBytes = deobfuscate(bytes: FHKSecurityConstants.OBSCURED_TAG_BYTES, key: xorKey)
        
        // Creando el CryptoKit Nonce (IV)
        guard let iv = try? AES.GCM.Nonce(data: ivBytes) else {
            throw FHKSecurityError.cryptoError("Error to create Nonce/IV.")
        }
        
        // Crear el SealedBox
        let sealedBox = try AES.GCM.SealedBox(
            nonce: iv,
            ciphertext: Data(FHKSecurityConstants.ENCRYPTED_DATA_BYTES),
            tag: Data(tagBytes)
        )
                
        // Desencriptar
        let decryptedData = try AES.GCM.open(sealedBox, using: rootKey)
                
        // Convertir a texto plano
        guard let anonKey = String(data: decryptedData, encoding: .utf8) else {
            throw FHKSecurityError.cryptoError("Text decoding error.")
        }
        
        return anonKey
    }
    
    // Función auxiliar XOR
    static func deobfuscate(bytes: [UInt8], key: UInt8) -> [UInt8] {
        return bytes.map { $0 ^ key }
    }
}
