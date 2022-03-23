//
//  ImageAttachmentPreview.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 3/23/22.
//

import SwiftUI


struct ImageAttachmentPreview: View {
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

struct ImageAttachmentPreview_Previews: PreviewProvider {
    static var previews: some View {
        ImageAttachmentPreview(image: .constant(nil))
    }
}
