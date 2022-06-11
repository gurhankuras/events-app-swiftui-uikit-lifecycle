//
//  AnimatedToolbar.swift
//  play
//
//  Created by Gürhan Kuraş on 3/4/22.
//

import SwiftUI

struct AnimatedToolBox: View {
    @Binding var isOpen: Bool
    @State var showingImagePicker: Bool = false
    @Binding var image: UIImage?
    
    
    var body: some View {
        VStack {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(Color.appTextColor)
                .font(.title2)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isOpen.toggle()
                    }
                }
                .opacity(isOpen ? 0 : 1)
                .background(
                    VStack {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    isOpen.toggle()
                                }
                            }
                        Image(systemName: "camera")
                            .font(.title2)
                            .padding(5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("Hello")
                            }
                        Image(systemName: "photo")
                            .font(.title2)
                            .padding(5)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                UIApplication.shared.endEditing()
                                showingImagePicker.toggle()
                            }
                    }
                        .padding(.vertical, 12)
                    
                        .background(Color(UIColor.systemPink))
                        .clipShape(Capsule())
                        .offset(y: 50)
                        .opacity(isOpen ? 1 : 0)
                )
                .offset(y: isOpen ? -50 : 0)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $image)
                }
               
            
        }
        .offset(y: isOpen ? -50: 0)
        .foregroundColor(isOpen ? .white : .black)
    }
}


struct AnimatedToolKit_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedToolBox(isOpen: .constant(true), image: .constant(nil))
    }
}
