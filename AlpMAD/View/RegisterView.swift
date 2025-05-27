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
    
    let textColor = Color(red: 45/255, green: 55/255, blue: 72/255)
    let primaryBlue = Color(red: 74/255, green: 144/255, blue: 226/255)
    let backgroundColor = Color(red: 244/255, green: 246/255, blue: 249/255)
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("Messages 3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 70)
                .padding(.top, 60)
                .padding(.bottom, 100)
            
            Text("Let's Get Started")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(textColor)
            
            Text("No judgment, just honesty.")
                .foregroundStyle(.secondary)
                .padding(.top, -10)
            
        
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryBlue, lineWidth: 1)
                    )
                
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(primaryBlue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(primaryBlue, lineWidth: 1)
                )
                
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(primaryBlue, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 16)
            
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
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryBlue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(textColor)
                Button(action: {
                    showLogin = true
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(primaryBlue)
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .background(backgroundColor)
        .edgesIgnoringSafeArea(.all)
        .alert("Invalid Input", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .alert("Registrasi Berhasil!", isPresented: $showSuccessAlert) {
            Button("OK") {
                // Clear form and navigate to login
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
