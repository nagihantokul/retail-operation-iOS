import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void

    @State private var currentPage = 0
    @State private var isAnimating = false

    private let features = [
        OnboardingFeature(
            icon: "barcode.viewfinder",
            title: "Smart Inventory",
            description: "Scan barcodes instantly to check stock levels across all stores"
        ),
        OnboardingFeature(
            icon: "creditcard.fill",
            title: "Mobile Checkout",
            description: "Process sales anywhere on the floor with seamless payments"
        ),
        OnboardingFeature(
            icon: "person.2.fill",
            title: "Clienteling",
            description: "Build customer relationships with personalized service"
        ),
        OnboardingFeature(
            icon: "shippingbox.fill",
            title: "BOPIS & Transfers",
            description: "Manage pickup orders and inter-store transfers efficiently"
        )
    ]

    var body: some View {
        ZStack {
            // Background image - centered
            Image("IMG_0227")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            // Overlay gradient
            LinearGradient(
                colors: [.black.opacity(0.3), .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Content - centered
            VStack(spacing: 0) {
                Spacer()

                // App Title
                VStack(spacing: 8) {
                    Image(systemName: "bag.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.5)

                    Text("Sales Associate")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Operations App")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding(.bottom, 40)

                // Feature Cards with PageView
                TabView(selection: $currentPage) {
                    ForEach(features.indices, id: \.self) { index in
                        FeatureCard(feature: features[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 180)
                .padding(.horizontal, 20)

                // Custom Page Indicator
                HStack(spacing: 8) {
                    ForEach(features.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: currentPage == index ? 10 : 8, height: currentPage == index ? 10 : 8)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.top, 16)

                Spacer()

                // Continue Button - centered
                VStack(spacing: 12) {
                    Button {
                        onStart()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Get Started")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.45, green: 0.65, blue: 0.55), Color(red: 0.55, green: 0.75, blue: 0.65)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.horizontal, 40)

                    Text("Swipe to explore features")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Onboarding Feature Model

struct OnboardingFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

// MARK: - Feature Card

struct FeatureCard: View {
    let feature: OnboardingFeature

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: feature.icon)
                .font(.system(size: 40))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.55, green: 0.75, blue: 0.68), Color(red: 0.65, green: 0.85, blue: 0.78)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(feature.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(feature.description)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}

#Preview {
    WelcomeView(onStart: {})
}
