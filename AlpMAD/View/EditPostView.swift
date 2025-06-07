//
//  EditPostView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 22/05/25.
//

import SwiftUI

struct EditPostView: View {
    @Binding var content: String
    let onSave: () -> Void
    let onCancel: () -> Void
    let errorMessage: String?
    
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Edit Post")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextEditor(text: $content)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(minHeight: 120)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button("Save") {
                    onSave()
                }
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
            .alert("Failed to Save Changes", isPresented: $showErrorAlert) {
                Button("OK") {
                }
            } message: {
                Text(errorMessage ?? "")
            }
            .onChange(of: errorMessage) { error in
                if error != nil {
                    showErrorAlert = true
                }
            }
        }
    }
}
