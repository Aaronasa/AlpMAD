//
//  EditReplyView.swift
//  AlpMADMac
//
//  Created by student on 03/06/25.
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
        VStack(spacing: 20) {
            Text("Edit Reply")
                .font(.title2)
                .fontWeight(.bold)

            Text("You can edit your reply as many times as you like.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            TextEditor(text: $content)
                .padding(8)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
                .frame(minHeight: 150)

            HStack {
                Spacer()
                Text("\(content.count)/1000")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack(spacing: 12) {
                Button("Cancel", action: onCancel)
                    .keyboardShortcut(.cancelAction)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                Button("Save Changes", action: onSave)
                    .keyboardShortcut(.defaultAction)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
            }
        }
        .padding(24)
        .frame(minWidth: 400)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(radius: 10)
        )
        .padding()
        .alert("Failed to Save Changes", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
        .onChange(of: errorMessage) { newValue in
            showErrorAlert = newValue != nil
        }
    }
}

#Preview {
    EditReplyView(
        content: .constant("Lorem ipsum dolor sit amet."),
        onSave: {},
        onCancel: {},
        errorMessage: "Sample error"
    )
    .frame(width: 500, height: 350)
}
