//
//  FHKWatchButton.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/3/26.
//

import SwiftUI

public struct FHKWatchButton: View {
    public var startTitle: String
    public var stopTitle: String
    public var resetTitle: String
    
    public var onStop: ((TimeInterval) -> Void)?
    
    @State private var isRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var startTime: Date?
    private let sizeButton: CGFloat = FHKSize.size152
    
    public init(startTitle: String,
                stopTitle: String,
                resetTitle: String,
                onStop: ((TimeInterval) -> Void)? = nil
    ) {
        self.startTitle = startTitle
        self.stopTitle = stopTitle
        self.resetTitle = resetTitle
        self.onStop = onStop
    }

    public var body: some View {
        VStack(spacing: FHKSpace.space20) {
            Text(formatTime(elapsedTime))
                .font(.PangramSans.bold(FHKSize.size48))
                .foregroundColor(FHKColor.pastelPink)
                .padding()

            Button(action: {
                toggleTimer()
            }) {
                HStack {
                    Image(systemName: isRunning ? "stop.fill" : "play.fill")
                        .resizable()
                        .frame(width: FHKSize.size24, height: FHKSize.size24)
                    Text(isRunning
                         ? stopTitle.uppercased()
                         : startTitle.uppercased()
                    )
                        .font(.PangramSans.bold(FHKSize.size28))
                        .foregroundColor(FHKColor.basicWhite)
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: sizeButton, height: sizeButton)
                .background(isRunning ? Color.red : Color.green)
                .cornerRadius(sizeButton / 2)
                .shadow(radius: FHKSize.size44)
            }
            
            // Reset button
            if !isRunning && elapsedTime > 0 {
                Button(resetTitle.uppercased()) {
                    elapsedTime = 0
                    onStop?(0)
                }
                .font(.PangramSans.bold(FHKSize.size28))
                .foregroundColor(FHKColor.basicWhite)
                .padding(.top, FHKSpace.space08)
            }
        }
    }

    // Lógica del Timer
    private func toggleTimer() {
        if isRunning {
            // STOP
            timer?.invalidate()
            timer = nil
            onStop?(elapsedTime)
        } else {
            // START
            startTime = Date() - elapsedTime
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let start = startTime {
                    elapsedTime = Date().timeIntervalSince(start)
                }
            }
        }
        isRunning.toggle()
    }

    // Time formatter (00:00.0)
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let tenths = Int((time * 10).truncatingRemainder(dividingBy: 10))
        return String(format: "%02d:%02d.%01d", minutes, seconds, tenths)
    }
}


#Preview {
    VStack {
        FHKWatchButton(startTitle: "start",
                       stopTitle: "stop",
                       resetTitle: "reset")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
