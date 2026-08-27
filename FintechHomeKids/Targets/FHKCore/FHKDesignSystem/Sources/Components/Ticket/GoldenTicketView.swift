//
//  GoldenTicketView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 28/3/26.
//

import SwiftUI

public struct GoldenTicketView: View {
    private var appName: String  = "FINTECHKIDS"
    
    // MARK: Parámetros personalizables
    var recipientName: String
    var taskDescription: String
    var reward: String
    var ticketCode: String
   
    // MARK: Colores dorados (Tus definiciones)
    private let goldHighlight   = Color(hex: "FFF0A0")
    private let goldLight       = Color(hex: "F5D050")
    private let goldMid         = Color(hex: "D4A017")
    private let goldDeep        = Color(hex: "A0760A")
    private let goldDark        = Color(hex: "6B4C05")
    private let brown           = Color(hex: "4A3000")
    private let borderColor     = Color(hex: "3A2200") // Color base café para sombras
    
    
    public init(recipientName: String,
                taskDescription: String,
                reward: String,
                ticketCode: String
    ) {
        self.recipientName = recipientName
        self.taskDescription = taskDescription
        self.reward = reward
        self.ticketCode = ticketCode
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // — Sombra exterior
            TicketShape()
                .fill(Color.black.opacity(0.35))
                .blur(radius: 14)
                .offset(y: 8)

            // — Fondo dorado degradado
            TicketShape()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: goldHighlight,   location: 0.00),
                            .init(color: goldLight,       location: 0.12),
                            .init(color: goldMid,         location: 0.35),
                            .init(color: goldLight,       location: 0.52),
                            .init(color: goldMid,         location: 0.70),
                            .init(color: goldDeep,        location: 0.88),
                            .init(color: goldDark,        location: 1.00),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // — Brillo diagonal sutil
            TicketShape()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.30), location: 0.0),
                            .init(color: Color.white.opacity(0.00), location: 0.5),
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
            // — Borde interior dorado (Mantenemos tu original)
            TicketShape()
                .stroke(borderColor.opacity(0.6), lineWidth: 3)
                .padding(10) // Ajustado ligeramente para acomodar el borde exterior más ancho

            // — Contenido
            VStack(spacing: 0) {
                headerSection
                titleSection
                contentCard
            }
            .padding(.horizontal, 22)
        }
        .frame(width: 310, height: 540)
    }

    // MARK: - Header (Tu versión)

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("\(appName) PRESENTA:")
                .font(.system(size: 12, weight: .heavy, design: .default))
                .kerning(1.5)
                .foregroundColor(brown)
                .shadow(color: goldHighlight.opacity(0.6), radius: 1, x: 0, y: 1)

            // Icono de monedas (Tu versión)
            ZStack {
                Circle()
                    .fill(goldMid)
                    .frame(width: 22, height: 22)
                    .overlay(Circle().stroke(brown, lineWidth: 1.5))
                    .offset(x: -7)
                Circle()
                    .fill(goldDeep)
                    .frame(width: 22, height: 22)
                    .overlay(Circle().stroke(brown, lineWidth: 1.5))
                    .offset(x: 7)
            }
            .frame(width: 40, height: 24)
        }
        .padding(.top, 22)
        .padding(.bottom, 10)
    }

    // MARK: - Título principal (Tu versión)

    private var titleSection: some View {
        VStack(spacing: 0) {
            Text("¡TICKET DORADO")
                .font(.system(size: 27, weight: .heavy))
                .foregroundColor(brown)
                .shadow(color: goldHighlight.opacity(0.5), radius: 1, x: 0, y: 1)
            Text("DE RECOMPENSA!")
                .font(.system(size: 27, weight: .heavy))
                .foregroundColor(brown)
                .shadow(color: goldHighlight.opacity(0.5), radius: 1, x: 2, y: 1)
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 14)
    }

    // MARK: - Tarjeta blanca con los campos (Tu versión)
    private var contentCard: some View {
        VStack(spacing: 0) {
            // PARA
            fieldBlock(label: "PARA:", content: {
                Text(recipientName)
                    .font(.system(size: 21, weight: .heavy))
                    .foregroundColor(brown)
                    .frame(maxWidth: .infinity, alignment: .center)
            })

            solidDivider

            // TAREA
            fieldBlock(label: "POR COMPLETAR LA TAREA:", content: {
                Text(taskDescription)
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(brown)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .frame(maxWidth: .infinity, alignment: .center)
            })

            solidDivider

            // RECOMPENSA
            fieldBlock(label: "RECOMPENSA SELECCIONADA:", content: {
                HStack(spacing: 6) {
                    Spacer()
                    Text(reward)
                        .font(.system(size: 21, weight: .heavy))
                        .foregroundColor(brown)
                    Text("🎁")
                        .font(.system(size: 20))
                    Spacer()
                }
            })

            solidDivider

            // Línea punteada de corte (Tu versión)
            DashedDivider()
                .padding(.horizontal, 2)

            // Código de barras + código (Tu versión)
            VStack(spacing: 4) {
                SimulatedBarcode()
                    .frame(height: 38)
                    .padding(.horizontal, 14)
                    .padding(.top, 8)

                Text(ticketCode)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .kerning(2.5)
                    .foregroundColor(brown.opacity(0.85))
                    .padding(.bottom, 12)
            }
        }
        .background(
            ZStack {
                // Tarjeta blanca base
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.82))
                
                // Efecto de relieve sutil café en los bordes de la tarjeta blanca (inspirado en Image 0)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor.opacity(0.5), lineWidth: 1.5)
                    .blur(radius: 0.5)
                    .offset(x: 1, y: 1)
            }
        )
        .padding(.bottom, 22)
    }

    // MARK: - Field block genérico (Tu versión)

    @ViewBuilder
    private func fieldBlock<Content: View>(label: String,
                                           @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .kerning(0.5)
                .foregroundColor(brown.opacity(0.6))
            content()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private var solidDivider: some View {
        Rectangle()
            .fill(brown.opacity(0.15))
            .frame(height: 1)
            .padding(.horizontal, 6)
    }
}

#Preview {
    VStack {
        GoldenTicketView(recipientName: "Isaac Leon",
                         taskDescription: "Hacer sus deberes",
                         reward: "Ir a Burger King",
                         ticketCode: "34534545345345")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}


