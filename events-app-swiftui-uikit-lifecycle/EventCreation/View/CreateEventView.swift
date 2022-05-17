//
//  CreateEventView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import SwiftUI

struct CreateEventView: View {

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var birthDate = Date()
    @State private var height: CGFloat = 150
    @State private var hasCertification: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            viewTitle
            HStack(alignment: .top) {
                ImageUploadView()
                    .cornerRadius(5)
                VStack {
                    TextField("Title", text: $title)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .textFieldStyle(.roundedBorder)
                    datePicker
                }
            }
            .padding(.bottom)
            
            descriptionTextView
            Toggle(isOn: $hasCertification) {
                Text("Has certification programme?")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
            }
            .tint(.appPurple)
            Spacer()
            LongRoundedButton(text: "Continue",
                              active: .constant(true),
                              action: proceed)
        }
        .padding(.all)
    }
    
    private func proceed() {
        print("Click")
    }
    
    var viewTitle: some View {
        Text("Create a Event")
            .font(.system(size: 21, weight: .semibold, design: .rounded))
    }
    
    var datePicker: some View {
        DatePicker(selection: $birthDate,
                   in: Date()...,
                   displayedComponents: .date) {
                        Text("Select a date")
        }
    }
    
    var descriptionTextView: some View {
        ResizableTextField(text: $description,
                           height: $height,
                           font: .systemFont(ofSize: 14, weight: .regular))
            .frame(height: 150)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(5)
            .font(.system(size: 12, weight: .regular, design: .rounded))
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
            .preferredColorScheme(.dark)
    }
}
