import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager: AuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var isRegisterMode = false

    // Register fields
    @State private var firstName = ""
    @State private var lastName = ""

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let isCompact = geometry.size.height < 700
                let isNarrow = geometry.size.width < 390
                let contentWidth = min(320.0, max(260.0, geometry.size.width - (isCompact ? 48.0 : 64.0)))

                ZStack {
                    Image("IMG_0227")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .ignoresSafeArea()

                    LinearGradient(
                        colors: [.black.opacity(0.25), .black.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 0) {
                        Spacer(minLength: 0)

                        VStack(spacing: 14) {
                            VStack(spacing: 6) {
                                Text("Sales Associate")
                                    .font(.system(size: isCompact ? 20 : 24, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.75)

                                if !isCompact {
                                    Text("Operations App")
                                        .font(.footnote)
                                        .foregroundStyle(.white.opacity(0.85))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)
                                }

                                Text(isRegisterMode ? "Create Account" : "Employee Login")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.75))
                            }

                            VStack(spacing: 14) {
                                if isRegisterMode {
                                    if isNarrow {
                                        VStack(spacing: 12) {
                                            TextField("First Name", text: $firstName)
                                                .textFieldStyle(.roundedBorder)
                                                .textContentType(.givenName)

                                            TextField("Last Name", text: $lastName)
                                                .textFieldStyle(.roundedBorder)
                                                .textContentType(.familyName)
                                        }
                                    } else {
                                        HStack(spacing: 12) {
                                            TextField("First Name", text: $firstName)
                                                .textFieldStyle(.roundedBorder)
                                                .textContentType(.givenName)
                                                .frame(maxWidth: .infinity)

                                            TextField("Last Name", text: $lastName)
                                                .textFieldStyle(.roundedBorder)
                                                .textContentType(.familyName)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                }

                                TextField("Email", text: $email)
                                    .textFieldStyle(.roundedBorder)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()

                                SecureField("Password", text: $password)
                                    .textFieldStyle(.roundedBorder)
                                    .textContentType(isRegisterMode ? .newPassword : .password)

                                if let error = authManager.error {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                        .multilineTextAlignment(.center)
                                }

                                Button(action: submit) {
                                    HStack(spacing: 10) {
                                        if authManager.isLoading {
                                            ProgressView()
                                                .tint(.white)
                                        }
                                        Text(isRegisterMode ? "Create Account" : "Login")
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        LinearGradient(
                                            colors: [Color(red: 0.2, green: 0.45, blue: 0.3), Color(red: 0.25, green: 0.55, blue: 0.35)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .opacity(isFormValid ? 1.0 : 0.5)
                                    )
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .disabled(!isFormValid || authManager.isLoading)

                                // Demo Mode Button
                                Button(action: { authManager.loginAsDemo() }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.caption)
                                        Text("Demo Mode")
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(.white.opacity(0.2))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }

                                Button(action: { isRegisterMode.toggle() }) {
                                    Text(isRegisterMode ? "Already have an account? Login" : "Don't have an account? Register")
                                        .font(.footnote)
                                        .foregroundStyle(.white)
                                        .underline()
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(isCompact ? 12 : 14)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .frame(width: contentWidth)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, isCompact ? 16 : 24)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password.count >= 6
    }

    private func submit() {
        Task {
            if isRegisterMode {
                await authManager.register(
                    email: email,
                    password: password,
                    firstName: firstName.isEmpty ? nil : firstName,
                    lastName: lastName.isEmpty ? nil : lastName,
                    storeId: nil
                )
            } else {
                await authManager.login(email: email, password: password)
            }
        }
    }
}

#Preview {
    LoginView(authManager: AuthManager.shared)
}
