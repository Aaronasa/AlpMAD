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
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with title and buttons
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                
                Spacer()
                
                Text("Edit Post")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Save") {
                    onSave()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(NSColor.controlBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(NSColor.separatorColor)),
                alignment: .bottom
            )
            
            // Content area
            VStack(alignment: .leading, spacing: 16) {
                // Text editor
                TextEditor(text: $content)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isTextEditorFocused ? Color.blue.opacity(0.5) : Color(NSColor.separatorColor),
                                lineWidth: 1
                            )
                    )
                    .cornerRadius(8)
                    .frame(minHeight: 150)
                    .focused($isTextEditorFocused)
                    .scrollContentBackground(.hidden)
                
                Spacer()
            }
            .padding(20)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .background(Color(NSColor.windowBackgroundColor))
        .alert("Failed to Save Changes", isPresented: $showErrorAlert) {
            Button("OK") {
                // Alert will dismiss automatically
            }
        } message: {
            Text(errorMessage ?? "")
        }
        .onChange(of: errorMessage) { error in
            if error != nil {
                showErrorAlert = true
            }
        }
        .onAppear {
            // Auto-focus the text editor when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextEditorFocused = true
            }
        }
    }
}

#Preview {
    @State var sampleContent = "This is a sample post content that can be edited. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    
    return EditPostView(
        content: $sampleContent,
        onSave: {
            print("Save tapped")
        },
        onCancel: {
            print("Cancel tapped")
        },
        errorMessage: nil
    )
    .frame(width: 500, height: 400)
}
