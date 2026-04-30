import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedNPC: AlienNPC?
    @State private var messageText = ""
    @State private var scrollToBottom = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // NPC Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(appState.npcs) { npc in
                            NPCAvatarButton(npc: npc, isSelected: selectedNPC?.id == npc.id) {
                                selectedNPC = npc
                            }
                        }
                    }
                    .padding()
                }
                .background(AlienTheme.deepSpace)

                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if let npc = selectedNPC {
                                ForEach(filteredMessages(for: npc.id)) { msg in
                                    ChatBubble(message: msg)
                                        .id(msg.id)
                                }
                            } else {
                                VStack(spacing: 16) {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .font(.largeTitle)
                                        .foregroundColor(AlienTheme.accentPurple)
                                    Text("Select an alien to start chatting")
                                        .foregroundColor(AlienTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 60)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: appState.chatMessages.count) { _, _ in
                        if let lastId = filteredMessages(for: selectedNPC?.id ?? "").last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input
                if selectedNPC != nil {
                    HStack(spacing: 12) {
                        TextField("Message...", text: $messageText)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(AlienTheme.surface)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                        Button {
                            if !messageText.isEmpty, let npcId = selectedNPC?.id {
                                appState.sendChatMessage(messageText, npcId: npcId)
                                messageText = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(messageText.isEmpty ? AlienTheme.textSecondary : AlienTheme.accentGreen)
                        }
                        .disabled(messageText.isEmpty)
                    }
                    .padding()
                    .background(AlienTheme.deepSpace)
                }
            }
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Alien Chat")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if selectedNPC == nil {
                    selectedNPC = appState.npcs.first
                }
            }
        }
    }

    private func filteredMessages(for npcId: String) -> [ChatMessage] {
        appState.chatMessages.filter { $0.npcId == npcId }
    }
}

struct NPCAvatarButton: View {
    let npc: AlienNPC
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(npc.avatar)
                    .font(.largeTitle)
                    .padding(12)
                    .background(isSelected ? AlienTheme.accentPurple.opacity(0.3) : AlienTheme.surface)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? AlienTheme.accentPurple : Color.clear, lineWidth: 2)
                    )
                Text(npc.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : AlienTheme.textSecondary)
            }
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 60) }
            Text(message.text)
                .padding(12)
                .background(message.isFromUser ? AlienTheme.accentPurple : AlienTheme.surface)
                .foregroundColor(.white)
                .cornerRadius(16)
            if !message.isFromUser { Spacer(minLength: 60) }
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}