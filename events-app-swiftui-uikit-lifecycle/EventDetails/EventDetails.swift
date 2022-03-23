//
//  Events.swift
//  play
//
//  Created by Gürhan Kuraş on 2/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventDetails: View {
    private let urlStr = "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80"
    private let text = "PreviewProvider.longText"

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                GeometryReader { proxy in
                    
                    EventHeaderImage(url: urlStr,
                                     height: UIScreen.main.bounds.height * 0.3)
                }

                .frame(height: UIScreen.main.bounds.height * 0.3)
                //.background(.green)
                //InterestedUsers(gap: 50)
                InterestedUsers(users: ["concert", "concert", "concert"], gap: 20)
                .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ExpandableText(text: longText, initial: .closed)
                    .lineLimit(4)
                watchButton
                joinButton
                
            }
            
            

        }
        
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private var joinButton: some View {
        Button {
            print("Click")
        } label: {
            Text("Join")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    Capsule()
                        .fill(.pink)
                )
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var watchButton: some View {
        NavigationLink {
            LazyView {
                VideoPage()
            }
        } label: {
            Text("Join")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    Capsule()
                        .fill(.pink)
                )
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
    
    struct EventDetailsImageOverlay: View {
        let text: String

        var body: some View {
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .background(LinearGradient(colors: [.black, .black.opacity(0.3)], startPoint: .bottom, endPoint: .top))
        }
    }

}



struct EventDetails_Previews: PreviewProvider {
    static var previews: some View {
        EventDetails()
            //.previewInterfaceOrientation(.portrait)
    }
}


struct EventHeaderImage: View {
    @Environment(\.presentationMode) var presentationMode
    
    let url: String
    let height: CGFloat
    
    var body: some View {
        
        WebImage(url: URL(string: url))
            .resizable()
            .scaledToFill()
            .frame(height: height)
            .clipped()
            .background(Color.pink)
            .overlay(
                Text("VENDEX TURKEY - Vending Techonologies & Self Service Systems Exhibition")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                    .background(LinearGradient(colors: [.black, .black.opacity(0.3)],
                                               startPoint: .bottom,
                                               endPoint: .top))
                ,
                alignment: .bottom
            )
            .overlay(
                Image(systemName: "arrow.backward")
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                , alignment: .topLeading
            )
        Text("sadsadsad")
    }
}


let longText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pharetra est nunc. Suspendisse tincidunt vestibulum augue, eget auctor arcu euismod ac. Aliquam id commodo dui. Pellentesque porttitor hendrerit neque non semper. Sed lobortis quis leo ut tempor. Phasellus quis mi diam. Quisque non enim dolor. Nulla eleifend risus sit amet lectus eleifend tincidunt. Nulla eget quam ligula. Sed vel mi lacus. Proin non semper mauris, ut sodales velit. Curabitur non egestas enim. Vivamus ac rhoncus mi. Nam leo purus, faucibus sagittis blandit quis, rhoncus non ex. Ut sit amet nibh sed purus consequat dignissim. Proin lobortis nisi mi, at pretium purus vestibulum nec.

Fusce volutpat dui arcu, ut accumsan nibh ultricies sed. Quisque varius molestie maximus. Cras a nulla odio. Integer urna nunc, molestie vitae eleifend quis, sagittis eu purus. Etiam semper a tortor eu mattis. Aliquam cursus aliquet viverra. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi placerat lacus et odio dictum blandit. Nulla egestas, turpis eget cursus feugiat, tortor orci aliquam velit, eget tincidunt dui ipsum ac neque. Cras faucibus est vel urna varius, non pulvinar leo blandit. Sed scelerisque sollicitudin consequat. Donec blandit justo in ex iaculis vehicula. Suspendisse vulputate mattis nunc, nec molestie enim consequat sed.
"""

struct InterestedUsers: View {
    let gap: Double
    let users: [String]
    
    init(users: [String], gap: Double)
    {
        self.gap = gap
        self.users = users
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Interested")
                .bold()
            ImageStack(gap: 50/2, imageUrls: users, content: { image in
                    image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.appPurple)
                            .shadow(radius: 5)
                    )
                    
            }) {
                Text("+5")
                    .foregroundColor(.white)
            }
        }
        
    }
}

struct ImageStack<Content: View, AdditionalContent: View> : View {
    let gap: Double
    let imageUrls: [String]
    let content: (Image) -> Content
    @ViewBuilder let additionalContent: () -> AdditionalContent
    
    
    init(gap: Double,
         imageUrls: [String],
         content: @escaping (Image) -> Content,
         additionalContent: @escaping () -> AdditionalContent
    ) {
        self.gap = gap
        self.imageUrls = imageUrls
        self.content = content
        self.additionalContent = additionalContent
    }
    
    
    var body: some View {
        ZStack {
            ForEach(0..<imageUrls.count, id: \.self) { index in
                content(Image(imageUrls[index]))
                    .offset(x: CGFloat(Double(index) * Double(gap)))
            }
            additionalContent()
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(Color.appPurple)
                    .shadow(radius: 5)
            )
            .offset(x: CGFloat(Double(imageUrls.count) * gap))
        }
    }
}



