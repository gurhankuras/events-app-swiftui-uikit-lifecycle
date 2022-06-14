//
//  AddressStepView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import SwiftUI

//
//  BillingAddressStepView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/26/22.
//
import Combine


struct NewEventBillingAddressStep {
    let country: String
    let city: String
    let addressLine: String
    let zipCode: String
    let categories: [EventCategoryType]
}




struct NewEventAddressStep: View {
    @StateObject var formViewModel: NewEventAddressStepViewModel = NewEventAddressStepViewModel()
    let onClickedNext: ((NewEventBillingAddressStep) -> ())?
    let dismiss: () -> ()
    
    static private var uniqueKey: String {
        UUID().uuidString
    }

    private let countryOptions: [DropdownOption] = [
        DropdownOption(key: Self.uniqueKey, value: "-"),
        DropdownOption(key: Self.uniqueKey, value: "Turkey"),
    ]
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    let deneme: Array<EventCategoryType> = [.business, .culture, .music, .technology]
    
    var body: some View {
        VStack(spacing: 0) {
            RegularAppBar(title: "Payment", back: dismiss)
            billingAddressSection
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                ForEach(deneme, id: \.self) { item in
                    EventTypeChip(type: item.name)
                        .backgroundColor(formViewModel.contains(item) ? .pink : .gray)
                        .onTapGesture {
                            formViewModel.toggleCategory(item)
                        }
                        .padding(.bottom, 5)
                }
            }
            Spacer()
            LongRoundedButton(text: "Next", active: $formViewModel.valid, action: next)
                .padding(.bottom)
                .padding(.horizontal)
        }
        .navigationBarHidden(true)

    }
    
    @ViewBuilder
    var billingAddressSection: some View {
            DropdownSelector(
                placeholder: "Country",
                options:  countryOptions,
                isOpen: $formViewModel.isCountryDropdownOpen,
                onOptionSelected: { option in
                    formViewModel.country = option.value
                })
                .zIndex(999)
                .padding(.vertical, 10)
            DropdownSelector(
                placeholder: "City",
                options: formViewModel.cities().map({ DropdownOption(key: $0, value: $0)}),
                isOpen: $formViewModel.isCityDropdownOpen,
                onOptionSelected: { option in
                    formViewModel.city = option.value
                })
                .zIndex(998)
                .padding(.bottom, 10)
            SigningTextField(placeholder: "Address", text: $formViewModel.addressLine)
            SigningTextField(placeholder: "Zip Code", text: $formViewModel.zipCode)
    }
    
    func next() {
        onClickedNext?(formViewModel.completeStep())
    }
}


struct NewEventAddressStepView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventAddressStep(onClickedNext: {_ in }, dismiss: {})
    }
}
