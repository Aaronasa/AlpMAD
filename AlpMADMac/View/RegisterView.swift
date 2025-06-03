//
//  RegisterView.swift
//  AlpMAD
//
//  Created by Aaron Asa Soelistiono on 01/06/25.
//

//
//  RegisterView.swift
//  AlpMADMac
//
//  Created by Aaron Asa Soelistiono on 01/06/25.
//

import SwiftUI

struct RegisterView: View {
    @Binding var showLogin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var age = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false

    @EnvironmentObject var authVM: AuthViewModel

    let textColor = Color(red: 45 / 255, green: 55 / 255, blue: 72 / 255)
    let primaryBlue = Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255)
    let backgroundColor = Color(
        red: 244 / 255,
        green: 246 / 255,
        blue: 249 / 255
    )

    var body: some View {
        HStack(spacing: 0) {
            // Left side - Logo and branding
            VStack {
                Spacer()

                Image("Messages 4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 350, maxHeight: 350)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)

            // Right side - Register form
            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 20) {
                    Text("Let's Get Started")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(textColor)
                    Text("No judgment, just honesty.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)

                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(textColor)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(.plain)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(primaryBlue, lineWidth: 1)
                                )
                                .foregroundColor(.black)
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(textColor)

                            ZStack {
                                Group {
                                    if isPasswordVisible {
                                        TextField(
                                            "Enter your password",
                                            text: $password
                                        )
                                        .textFieldStyle(.plain)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(primaryBlue, lineWidth: 1)
                                        )
                                        .foregroundColor(textColor)
                                    } else {
                                        SecureField(
                                            "Enter your password",
                                            text: $password
                                        )
                                        .textFieldStyle(.plain)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(primaryBlue, lineWidth: 1)
                                        )
                                        .foregroundColor(textColor)
                                    }
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(
                                        systemName: isPasswordVisible
                                            ? "eye.slash.fill" : "eye.fill"
                                    )
                                    .foregroundColor(primaryBlue)
                                    .frame(width: 20, height: 20)
                                }
                                .buttonStyle(.plain)
                                .padding(.leading, 280)

                            }
                            .frame(height: 40)
                        }

                        // Age Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(textColor)
                            
                            TextField("Age", text: $age)
                                .textFieldStyle(.plain)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(primaryBlue, lineWidth: 1)
                                )
                                .foregroundColor(.black)
                        }
                    }

                    Button(action: {
                        guard !email.isEmpty else {
                            alertMessage = "Email tidak boleh kosong"
                            showAlert = true
                            return
                        }
                        guard !password.isEmpty else {
                            alertMessage = "Password tidak boleh kosong"
                            showAlert = true
                            return
                        }
                        guard let ageInt = Int(age), ageInt > 0 else {
                            alertMessage = "Age harus berupa angka dan lebih dari 0"
                            showAlert = true
                            return
                        }

                        Task {
                            authVM.myUser.email = email
                            authVM.myUser.password = password
                            authVM.myUser.age = ageInt
                            await authVM.signUp()
                            
                            // Check if user is authenticated after signup (indicates success)
                            if authVM.isSignedIn {
                                // Registration successful, show success message and navigate to login
                                showSuccessAlert = true
                            } else {
                                // Registration failed, show error message
                                alertMessage = "Registrasi gagal. Silakan coba lagi."
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Register")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(primaryBlue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)

                    // Login Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            showLogin = true
                        }) {
                            Text("Login")
                                .fontWeight(.semibold)
                                .foregroundColor(primaryBlue)
                        }
                        .buttonStyle(.plain)
                    }
                    .font(.system(size: 14))
                    .padding(.top, 16)
                }
                .frame(maxWidth: 360)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            .background(Color.white)
        }
        .frame(minWidth: 800, minHeight: 600)
        .alert("Invalid Input", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .alert("Registrasi Berhasil!", isPresented: $showSuccessAlert) {
            Button("OK") {
                email = ""
                password = ""
                age = ""
                showLogin = true
            }
        } message: {
            Text("Akun Anda telah berhasil dibuat. Silakan login dengan akun yang baru dibuat.")
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showLogin: .constant(false))
            .environmentObject(AuthViewModel())
    }
}
