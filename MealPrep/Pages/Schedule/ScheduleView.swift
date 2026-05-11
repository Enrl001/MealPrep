//
//  ScheduleView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderView()

                Divider()

                Text("ScheduleView")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Theme.Colors.background)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
