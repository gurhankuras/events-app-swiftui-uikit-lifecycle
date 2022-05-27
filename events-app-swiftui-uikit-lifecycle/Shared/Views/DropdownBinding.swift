//
//  DropdownBinding.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/27/22.
//

import Foundation
import SwiftUI

struct DropdownRowBinding: View {
    var option: DropdownOption
    @Binding var current: DropdownOption?

    var body: some View {
        Button(action: {
            current = option
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

struct DropdownBinding: View {
    var options: [DropdownOption]
    @Binding var current: DropdownOption?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRowBinding(option: option, current: $current)
                }
            }
        }
        .frame(minHeight: min(CGFloat(options.count) * 30, 200), maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}


struct DropdownSelectorBinding: View {
    var placeholder: String
    var options: [DropdownOption]
    
    @Binding var isOpen: Bool
    @Binding var current: DropdownOption?
    //var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    
    private let buttonHeight: CGFloat = 45

    var body: some View {
        Button(action: {
            self.isOpen.toggle()
        }) {
            HStack {
                Text(current == nil ? placeholder : current!.value)
                    .font(.system(size: 14))
                    .foregroundColor(current == nil ? Color.gray: Color.black)

                Spacer()

                Image(systemName: self.isOpen ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(Color.black)
            }
        }
        .padding(.horizontal)
        .cornerRadius(5)
        .frame(maxWidth: .infinity)
        .frame(height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
        .overlay(
            VStack {
                if self.isOpen {
                    Spacer(minLength: buttonHeight + 10)
                    Dropdown(options: self.options, onOptionSelected: { option in
                        isOpen = false
                        //self.onOptionSelected?(option)
                        current = option
                    })
                }
            }
                , alignment: .topLeading
        )
        
        .background(
            RoundedRectangle(cornerRadius: 5).fill(Color.white)
        )
    }
}
