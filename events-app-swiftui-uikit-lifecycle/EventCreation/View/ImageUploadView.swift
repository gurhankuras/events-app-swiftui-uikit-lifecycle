//
//  ImageUploadView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import SwiftUI

struct ImageUploadView: View {
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    var body: some View {
        Rectangle()
            .fill(Color.appPurple)
            .frame(width: 100, height: 100)
            .overlay(content: {
                content
            })
            .onTapGesture {
                showingImagePicker = true
            }
            .onChange(of: selectedImage, perform: setImage(_:))
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
    }
    
    private func setImage(_ newUIImage: UIImage?) {
        guard let selectedImage = newUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    @ViewBuilder
    var content: some View {
        if let image = image {
            GeometryReader { geo in
                let size = geo.size
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            }
            
        }
        else {
            Image(systemName: "plus")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}
