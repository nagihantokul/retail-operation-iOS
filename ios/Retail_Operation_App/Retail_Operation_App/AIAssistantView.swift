import SwiftUI

// MARK: - AI Assistant View (Associate AI)

struct AIAssistantView: View {
    let storeId: Int

    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isTyping = false

    private let quickPrompts = [
        "What pairs well with a black blazer?",
        "Suggest outfits for a job interview",
        "What's trending this season?",
        "Recommend alternatives for out-of-stock items"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Welcome Message
                        if messages.isEmpty {
                            welcomeSection
                        }

                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }

                        if isTyping {
                            TypingIndicator()
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input Bar
            inputBar
        }
        .navigationTitle("AI Assistant")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var welcomeSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(colors: [Color(red: 0.55, green: 0.75, blue: 0.75), Color(red: 0.65, green: 0.78, blue: 0.68)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )

            Text("Associate AI")
                .font(.title2)
                .fontWeight(.bold)

            Text("I can help you with product recommendations,\nstyling tips, and customer assistance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Try asking:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)

                ForEach(quickPrompts, id: \.self) { prompt in
                    Button {
                        sendMessage(prompt)
                    } label: {
                        HStack {
                            Text(prompt)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 20)
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask me anything...", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...4)

            Button {
                sendMessage(inputText)
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .foregroundStyle(inputText.isEmpty ? .gray : .blue)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .top)
    }

    private func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        // Add user message
        messages.append(ChatMessage(role: .user, content: trimmed))
        inputText = ""

        // Simulate AI response
        isTyping = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run {
                isTyping = false
                messages.append(ChatMessage(role: .assistant, content: generateResponse(for: trimmed)))
            }
        }
    }

    private func generateResponse(for query: String) -> String {
        let lowercased = query.lowercased()

        if lowercased.contains("blazer") {
            return """
            Great choice! A black blazer is incredibly versatile. Here are some styling suggestions:

            **For a Professional Look:**
            • Pair with slim fit jeans and a white cotton t-shirt
            • Add leather loafers for polish

            **For Casual Elegance:**
            • Layer over a cashmere sweater
            • Match with chino pants in khaki

            **Available in Store:**
            • Wool Blend Blazer - Black (25 in stock)
            • Cotton T-Shirt - White (85 in stock)
            • Slim Fit Jeans - Indigo (42 in stock)

            Would you like me to check sizes for any of these items?
            """
        } else if lowercased.contains("interview") || lowercased.contains("job") {
            return """
            For a job interview, I recommend a polished yet comfortable outfit:

            **Classic Option:**
            • Wool Blend Blazer in Black
            • Crisp white or light blue button-down
            • Tailored chinos or dress pants

            **Modern Option:**
            • Cashmere Sweater in Grey
            • Dark slim-fit jeans
            • Clean leather shoes

            **Key Tips:**
            ✓ Stick to neutral colors
            ✓ Ensure proper fit
            ✓ Iron clothes the night before

            Want me to pull some specific items for your customer to try?
            """
        } else if lowercased.contains("trending") || lowercased.contains("season") {
            return """
            Here's what's trending this season:

            **Colors:**
            🔥 Camel and earth tones
            🔥 Rich burgundy
            🔥 Classic navy

            **Styles:**
            • Oversized blazers
            • Layered looks
            • Statement outerwear

            **Top Sellers This Week:**
            1. Winter Coat - Camel
            2. Cashmere Sweater - Grey
            3. Leather Jacket - Brown

            Would you like details on any of these items?
            """
        } else if lowercased.contains("out of stock") || lowercased.contains("alternative") {
            return """
            I can help find alternatives! Here are some strategies:

            **Endless Aisle:**
            Check other store locations and request transfers for items not available here.

            **Similar Items:**
            I can suggest comparable products based on style, fit, and price point.

            **Ship to Home:**
            Offer to order the item and ship directly to the customer.

            Which product is the customer looking for? I'll find the best alternatives.
            """
        } else {
            return """
            I'm here to help! I can assist with:

            • **Product Recommendations** - Outfit suggestions and pairings
            • **Styling Tips** - Help customers find their perfect look
            • **Inventory Check** - Find items across store locations
            • **Alternatives** - Suggest similar products

            What would you like help with?
            """
        }
    }
}

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp = Date()

    enum Role {
        case user, assistant
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer() }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                if message.role == .assistant {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundStyle(Color(red: 0.55, green: 0.75, blue: 0.75))
                        Text("AI Assistant")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(LocalizedStringKey(message.content))
                    .font(.subheadline)
                    .padding(12)
                    .background(message.role == .user ? Color(red: 0.55, green: 0.75, blue: 0.68) : Color(.systemGray6))
                    .foregroundStyle(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(maxWidth: 300, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .assistant { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var opacity: Double = 0.3

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                        .opacity(opacity)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: opacity
                        )
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()
        }
        .onAppear { opacity = 1.0 }
    }
}

#Preview {
    NavigationStack {
        AIAssistantView(storeId: 1)
    }
}
