//
//  EditReplyView.swift
//  AlpMAD
//
//  Created by student on 27/05/25.
//

import SwiftUI

struct EditReplyView: View {
    @Binding var content: String
    let onSave: () -> Void
    let onCancel: () -> Void
    let errorMessage: String?

    @State private var showErrorAlert = false


    private let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)

    var body: some View {
        VStack(spacing: 16) {
            Text("Edit Reply")
                .font(.headline)

            Text("You can edit your reply as many times as you like")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            TextEditor(text: $content)
                .background(Color(.systemGray6).opacity(0.0))
                .cornerRadius(10)
                .frame(height: 150)

            HStack {
                Spacer()
                Text("\(content.count)/1000")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack(spacing: 12) {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }

                Button(action: {
                    onSave()
                }) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryBlue)
                        .cornerRadius(8)
                }
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding()
        .alert("Failed to Save Changes", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .onChange(of: errorMessage) { newValue in
            showErrorAlert = newValue != nil
        }
    }
}

struct EditReplyView_Previews: PreviewProvider {
    static var previews: some View {
        EditReplyView(
            content: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
            onSave: {},
            onCancel: {},
            errorMessage: nil
        )
    }
}
