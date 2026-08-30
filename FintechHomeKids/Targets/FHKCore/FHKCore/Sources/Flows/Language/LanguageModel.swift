//
//  LanguageModel.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import Foundation

public struct LanguageModel: Codable {
    let es: Bool
    let fr: Bool
    let en: Bool
    let it: Bool
    
    public init(es: Bool = true, fr: Bool = false, en: Bool = false, it: Bool = false) {
        self.es = es
        self.fr = fr
        self.en = en
        self.it = it
    }
    
    public var enabledCodes: [String] {
        var codes: [String] = []
        if es { codes.append(LanguageType.es.code) }
        if fr { codes.append(LanguageType.fr.code) }
        if en { codes.append(LanguageType.en.code) }
        if it { codes.append(LanguageType.it.code) }
        return codes
    }
}
