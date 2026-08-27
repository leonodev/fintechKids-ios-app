//
//  ModalWrapper.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import SwiftUI

public struct ModalWrapper<Destination: NavigationDestination>: View {
    let destination: Destination
    let router: NavigationRouter<Destination>
    
    public init(destination: Destination, router: NavigationRouter<Destination>) {
        self.destination = destination
        self.router = router
    }
    
    public var body: some View {
        NavigationStack {
            destination.view()
                .navigationTitle(destination.title ?? "")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { router.dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.primary)
                        }
                    }
                }
        }
        .environment(router)
    }
}
