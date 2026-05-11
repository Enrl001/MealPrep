//
//  CreatePotluckSheet.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct CreatePotluckSheet: View {
    @Environment(\.dismiss) private var dismiss

    let hostName: String
    let onCreate: (PotluckEvent) -> Void

    @State private var title = ""
    @State private var category = "Meal Prep"
    @State private var location = ""
    @State private var date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Potluck Details") {
                    TextField("Title", text: $title)
                    TextField("Category", text: $category)
                    TextField("Location", text: $location)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("Create Potluck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onCreate(
                            PotluckEvent(
                                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                category: category.trimmingCharacters(in: .whitespacesAndNewlines),
                                location: location.trimmingCharacters(in: .whitespacesAndNewlines),
                                hostName: hostName,
                                date: date
                            )
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
