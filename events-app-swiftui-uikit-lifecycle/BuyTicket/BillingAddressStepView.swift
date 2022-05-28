//
//  BillingAddressStepView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/26/22.
//

import SwiftUI

struct BillingAddressStep {
    let country: String
    let city: String
    let contactName: String
    let addressLine: String
    let zipCode: String
}

class PaymentFormViewModel: ObservableObject {
    
    @Published var contactName: String = ""
    @Published var addressLine: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    
    @Published var isCountryDropdownOpen = false
    @Published var isCityDropdownOpen = false
    
    
   
    
    func cities() -> [String] {
        let cities = ["-","Adana", "Adıyaman", "Afyon", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin",
        "Aydın", "Balıkesir", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale",
        "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
        "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin", "İstanbul", "İzmir",
        "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya",
        "Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya",
        "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak",
        "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak",
                      "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"]
        if country == "-" || country.isEmpty {
            return ["-"]
        }
        let trLocale = Locale(identifier: "tr")
        return cities.sorted {
            $0.compare($1, locale: trLocale) == .orderedAscending
        }
    }
    
    func completeStep() -> BillingAddressStep {
        return BillingAddressStep(country: country,
                                  city: city,
                                  contactName: contactName,
                                  addressLine: addressLine,
                                  zipCode: zipCode)
    }
    
    
}

struct RegularAppBar: View {
    let title: LocalizedStringKey
    let back: () -> ()
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                backButton
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity)
                backButton.hidden().disabled(true)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            Divider().ignoresSafeArea()
        }
        
    }
    
    private var backButton: some View {
        Image(systemName: "arrow.backward")
            .foregroundColor(.appTextColor)
            .padding(.all, 5)
            .onTapGesture {
                back()
            }
    }
}

struct BillingAddressStepView: View {
    @StateObject var formViewModel: PaymentFormViewModel = PaymentFormViewModel()
    let onClickedNext: ((BillingAddressStep) -> ())?
    let dismiss: () -> ()
    
    static private var uniqueKey: String {
        UUID().uuidString
    }

    private let countryOptions: [DropdownOption] = [
        DropdownOption(key: Self.uniqueKey, value: "-"),
        DropdownOption(key: Self.uniqueKey, value: "Turkey"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            RegularAppBar(title: "Payment", back: dismiss)
            billingAddressSection
            .padding(.horizontal)

            Spacer()
            LongRoundedButton(text: "Next", active: .constant(true), action: next)
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
            SigningTextField(placeholder: "Contact Name", text: $formViewModel.contactName)
            SigningTextField(placeholder: "Address", text: $formViewModel.addressLine)
            SigningTextField(placeholder: "Zip Code", text: $formViewModel.zipCode)
    }
    
    func next() {
        onClickedNext?(formViewModel.completeStep())
    }
}


struct BillingAddressStepView_Previews: PreviewProvider {
    static var previews: some View {
        BillingAddressStepView(onClickedNext: {_ in }, dismiss: {})
    }
}
