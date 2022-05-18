//
//  CreateEventView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import SwiftUI

struct CreateEventView: View {
    
    let onContinued: () -> ()
    let dismiss: () -> ()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var birthDate = Date()
    @State private var height: CGFloat = 150
    @State private var hasCertification: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            CloseButton {
                dismiss()
            }
            .padding(.bottom)
            viewTitle
            HStack(alignment: .top) {
                ImageUploadView()
                    .cornerRadius(5)
                VStack {
                    TextField("title-form-field-placeholder", text: $title)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .textFieldStyle(.roundedBorder)
                    datePicker
                }
            }
            .padding(.bottom)
            
            descriptionTextView
            Toggle(isOn: $hasCertification) {
                Text("certification-question")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
            }
            .tint(.appPurple)
            Spacer()
            LongRoundedButton(text: "continue-button",
                              active: .constant(true),
                              action: proceed)
        }
        .padding(.all)
        //.navigationBarHidden(true)
        //.overlay(alignment: .topLeading, content: {
            
        //})
    }
    
    private func proceed() {
        onContinued()
    }
    
    var viewTitle: some View {
        Text("create-event-title")
            .font(.system(size: 21, weight: .semibold, design: .rounded))
    }
    
    var datePicker: some View {
        DatePicker(selection: $birthDate,
                   in: Date()...,
                   displayedComponents: .date) {
                        Text("date-picker")
        }
    }
    
    var descriptionTextView: some View {
        ResizableTextField(text: $description,
                           height: $height,
                           font: .systemFont(ofSize: 14, weight: .regular),
                           maxLength: 400)
            .frame(height: 150)
            .padding(.horizontal)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(5)
            .font(.system(size: 12, weight: .regular, design: .rounded))
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView(onContinued: {}, dismiss: {})
            .preferredColorScheme(.dark)
    }
}
