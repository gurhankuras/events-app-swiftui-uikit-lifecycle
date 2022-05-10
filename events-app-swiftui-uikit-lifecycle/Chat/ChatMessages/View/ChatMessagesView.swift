//
//  ChatLogs.swift
//  websocket-demo
//
//  Created by Gürhan Kuraş on 3/3/22.
//

import SwiftUI

struct ChatMessagesView: View {
    let onDismiss: () -> Void
    @State private var showOptions: Bool = false
    @StateObject var viewModel: ChatMessagesViewModel

    init(viewModel: ChatMessagesViewModel, onDismiss: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }

    var body: some View {
        // let _ = print("ChatLogsView CALISTI")
        VStack {
            ChatToolbar(room: viewModel.room, onBack: onDismiss)
                .padding(.horizontal)
            ChatMessagesList(viewModel.messages,
                             scroller: viewModel.scroller,
                             onMessageAppear: handle,
                             userOwnsMessage: viewModel.userOwnsMessage)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .overlay(
                    ImageAttachmentPreview(image: $viewModel.image), alignment: .bottom
                )
            textBar
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.load()
        }
        
    }
    
    private func handle(_ message: ChatMessage) {
        DispatchQueue.main.async {
            viewModel.loadMoreIfNeeded(item: message)
         }
    }
    
    private var textBar: some View {
        HStack(alignment: .center) {
            AnimatedToolBox(isOpen: $showOptions, image: $viewModel.image)
            MessageTextField(text: $viewModel.text)
            Button {
                viewModel.send()
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.pink)
                    .opacity(viewModel.canSendMessage ? 1 : 0.5)
            }
            .disabled(!viewModel.canSendMessage)

            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(white: 0.95, opacity: 0.95))
    }
}




struct MessageTextField: View {
    @Binding var text: String
    @State var height: CGFloat = 0
    var body: some View {
        ResizableTextField(text: $text, height: $height)
            .frame(height: min(height, 100))
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(15)
    }
}
