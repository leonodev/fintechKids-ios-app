//
//  String+Time.swift.swift
//  fintechKids
//
//  Created by Fredy Leon on 4/4/26.
//

import Foundation

extension String {
    
    private static let timeUnits: [([String], Int)] = [
        (["month", "mes", "mois", "mesi"], 720),
        (["week", "seman", "semain", "settim"], 168),
        (["day", "día", "dia", "jour", "giorn"], 24),
        (["hour", "hora", "heur", "ore"], 1)
    ]
    
    /// Convierte un string tipo "3 hours", "1 day", etc., a un valor entero en horas.
    var asHours: Int {
        let time = self.lowercased()
        // Extraemos solo los números
        let value = Int(time.filter { $0.isNumber }) ?? 0
        
        // Buscamos la unidad y multiplicamos
        for (keywords, multiplier) in String.timeUnits where keywords.contains(where: { time.contains($0) }) {
            return value * multiplier
        }
        
        return value
    }
    
    var isTimeUnit: Bool {
        let text = self.lowercased()
        return String.timeUnits.contains { (keywords, _) in
            keywords.contains { text.contains($0) }
        }
    }
}
