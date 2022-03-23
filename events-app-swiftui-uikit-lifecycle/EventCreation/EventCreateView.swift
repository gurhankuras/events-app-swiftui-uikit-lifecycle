//
//  EventCreateView.swift
//  play
//
//  Created by Gürhan Kuraş on 2/18/22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct EventCreationView: View {
    
    @State private var image: Image?
    @State private var filterIntensity: Float = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?.resizable()
                        .scaledToFit()
                }
                .onChange(of: inputImage) { _ in loadImage() }
                .onTapGesture {
                    showingImagePicker = true
                }
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                    .onChange(of: filterIntensity) { newValue in
                        applyProcessing()
                    }
                }
                .padding(.vertical)
                HStack {
                    Button("Change Filter", action: changeFilter)
                    Spacer()
                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("Add Image")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear", action: clear)
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        //image = Image(uiImage: inputImage)
        //currentFilter.inputImage
    }
    
    func clear() {
        inputImage = nil
        image = nil        
    }
    
    func save() {
    }
    
    func changeFilter() {
        
    }
    
    func applyProcessing() {
        currentFilter.intensity = filterIntensity
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
        }
    }
}

struct EventCreationView_Previews: PreviewProvider {
    static var previews: some View {
        EventCreationView()
    }
}





/*
 func loadImage() {
 if image == nil {
 print("onAppear")
 guard let inputImage = UIImage(named: "concert") else { return }
 let beginImage = CIImage(image: inputImage)
 
 let context = CIContext()
 let currentFilter = CIFilter.twirlDistortion()
 currentFilter.inputImage = beginImage
 
 let inputKeys = currentFilter.inputKeys
 
 let amount = 1
 let center = CIVector(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
 let radius = 1300
 
 if inputKeys.contains(kCIInputIntensityKey) {
 currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
 }
 
 
 
 if inputKeys.contains(kCIInputCenterKey) {
 currentFilter.setValue(center, forKey: kCIInputCenterKey)
 }
 
 
 
 if inputKeys.contains(kCIInputRadiusKey) {
 currentFilter.setValue(radius, forKey: kCIInputRadiusKey)
 }
 
 print(inputKeys)
 
 guard let outputImage = currentFilter.outputImage else { return }
 
 if let cgimag = context.createCGImage(outputImage, from: outputImage.extent) {
 let uiImage = UIImage(cgImage: cgimag)
 image = Image(uiImage: uiImage)
 }
 }
 // image = Image(uiImage: UIImage(ciImage: beginImage))
 //image = Image("concert")
 }
 */
