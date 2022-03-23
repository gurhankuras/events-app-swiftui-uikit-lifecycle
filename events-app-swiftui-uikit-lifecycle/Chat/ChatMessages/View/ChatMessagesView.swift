//
//  ChatLogs.swift
//  websocket-demo
//
//  Created by Gürhan Kuraş on 3/3/22.
//

import SwiftUI

struct ChatMessagesView: View {
    @State private var showOptions: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ChatMessagesViewModel
    @State var height: CGFloat = 0

    init(viewModel: ChatMessagesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        print("ChatLogsView init")
    }
    
    
    
    var body: some View {
        let _ = print("ChatLogsView CALISTI")
        VStack(spacing: 0) {
            ChatMessagesList(viewModel.messages,
                             scrollPublisher: viewModel.scrollToEnd,
                             onMessageAppear: handle,
                             belongsToUser: viewModel.belongsToCurrentUser)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .overlay(
                    ImagePreview(image: $viewModel.image)
                      
                    ,
                    
                    alignment: .bottom
                )
            textBar
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
            ToolbarItem(placement: .navigation) {
                HStack {
                    Button {
                        // TODO: Show fullscreen profile image
                    } label: {
                        
                        Image(viewModel.chat.imageUrl)
                            .resizable()
                            .scaledToFill()
                            .size(40)
                            .clipped()
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                        
                    .padding(.trailing, 5)
                    Text(viewModel.chat.name)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
            }
        }
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

            ResizableTextField(text: $viewModel.text, height: $height)
                .frame(height: min(height, 100))
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(15)
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

/*
struct ChatLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(viewModel: .init(roomId: "1234"))
    }
}
 */



struct ImagePreview: View {
    @Binding var image: UIImage?
    
    var body: some View {
        if let im = image {
            HStack {
                Image(uiImage: im)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 155)
                    //.transition(.move(edge: .bottom))
                    //.animation(.default)
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: 175)
            .background(image != nil ? Color.black.opacity(0.5) : .clear)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 15))
            .overlay(
                
                CloseButton(action: {
                    withAnimation {
                        image = nil
                    }
                })
                    .padding(5)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Circle())
                    .offset(x: -5, y: 5)
                ,
                alignment: .topTrailing
            )
            .transition(.move(edge: .bottom))
            .animation(.default)
            //.animation(.default)
        }
        else {
            EmptyView()
        }
        
        
    }
}
