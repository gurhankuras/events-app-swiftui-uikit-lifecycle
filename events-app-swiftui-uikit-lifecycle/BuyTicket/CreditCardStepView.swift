//
//  CreditCardStepView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/26/22.
//

import SwiftUI
import Combine

public protocol TextFieldInterceptor {
    func intercept(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool
    
}

extension TextFieldInterceptor {
    static func numeric() -> NumberTextFieldInterceptor {
        return NumberTextFieldInterceptor()
    }

}

class NumberTextFieldInterceptor: TextFieldInterceptor {
    func intercept(_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> Bool {
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementString)) {
            return false
        }
        return true
    }
}

struct SecurityCode {
    
    let value: String
    
    var isValid: Bool {
        value.count == 3
    }
}

class CreditCardFormViewModel: ObservableObject {
    let billingAddressStep: BillingAddressStep
    var cancellables = Set<AnyCancellable>()
    
    @Published var cardHolderName: String = ""
    @Published var cardNumber: String = ""
    @Published var securityCode: String = ""
    @Published private var expirationMonth: Int? = nil
    @Published private var expirationYear: Int? = nil
    
    @Published var expirationMonthOption: DropdownOption?
    @Published var expirationYearOption: DropdownOption?

    
    @Published var isFormValid: Bool = false
    
    private let currentYear: Int
    private let currentMonth: Int
    let service: ThreeDSPaymentService

    init(billingAddressStep: BillingAddressStep) {
        self.billingAddressStep = billingAddressStep
        self.service = ThreeDSPaymentService(client: HttpAPIClient(session: .shared, options: .init(contentType: "application/json")))
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        currentMonth = components.month!
        currentYear = components.year!
        
        $expirationYear.filter({ $0 == self.currentYear })
            .sink { [weak self] _ in
                self?.expirationMonthOption = nil
            }
            .store(in: &cancellables)
        
        subscribeToExpirationOptions()
        
        $cardHolderName.combineLatest($cardNumber, $securityCode, $expirationMonth.combineLatest($expirationYear))
            .map { name, num, code, date in
                return !name.isEmpty && num.count == 16 && code.count == 3 && date.0 != nil && date.1 != nil
            }
            .assign(to: &$isFormValid)
    }
    
    private func subscribeToExpirationOptions() {
        $expirationMonthOption
            .compactMap { opt in
                guard let option = opt,
                      let month = Int(option.value) else {
                    return nil
                }
                return month
            }
            .assign(to: &$expirationMonth)
        
        $expirationYearOption
            .compactMap { opt in
                guard let option = opt,
                      let year = Int(option.value) else {
                    return nil
                }
                return year
            }
            .assign(to: &$expirationYear)
    }
    
    
    
    func years() -> Range<Int> {
        return currentYear..<currentYear + 30
    }
    
    func months() -> ClosedRange<Int> {
        if expirationYear == currentYear {
            return currentMonth...12
        }
        return 1...12
    }
    
    var yearOptions: [DropdownOption] {
        years().map { DropdownOption(key: "\($0)", value: "\($0)") }
    }
    
    var monthOptions: [DropdownOption] {
        months().map { DropdownOption(key: "\($0)", value: "\($0)") }
    }
    
    var isValid: Bool {
        return false
    }
}

struct CreditCardStepView: View {
    @StateObject var viewModel: CreditCardFormViewModel
    let onNext: ((String) -> ())?
    let back: () -> ()
    
    @State var isOpen = false
    @State var isOpen2 = false

    var body: some View {
        VStack(spacing: 0) {
            RegularAppBar(title: "Credit Card", back: back)
                .padding(.bottom, 10)
            formSectionBody
            .padding(.horizontal)

            .onChange(of: isOpen) { opened in
                if opened {
                    isOpen2 = false
                }
            }
            .onChange(of: isOpen2) { opened in
                if opened {
                    isOpen = false
                }
            }
            Spacer()
            LongRoundedButton(text: "Checkout", active: $viewModel.isFormValid) {
                viewModel.service.startHandshake { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let content):
                        onNext?(content)
                    }
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .navigationBarHidden(true)

    }
    
    private var formSectionBody: some View {
        VStack(alignment: .leading) {
            
            cardHolderView
            VStack(alignment: .leading, spacing: 4) {
                Text("Credit Card Number")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                CustomFormatTextField(unformattedText: $viewModel.cardNumber,
                                      placeholder: "9999 9999 9999 9999",
                                      textPattern: "#### #### #### ####",
                                      patternSymbol: "#",
                                      interceptor: NumberTextFieldInterceptor())
                .autocapitalization(.none)
                .keyboardType(.default)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 1)
                )
                .font(.system(size: 13))
                .foregroundColor(Color.black)
                .padding(.vertical, 5)
            }
            HStack {
                expirationFields
                securityCodeView
            }
        }
    }
    
    
    private var cardHolderView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Card Holder Name")
                .font(.system(size: 14, weight: .medium, design: .rounded))
            SigningTextField(placeholder: "", text: $viewModel.cardHolderName)
        }
    }
    
    private var expirationFields: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Expiration Date")
            .font(.system(size: 14, weight: .medium, design: .rounded))
            HStack {
                DropdownSelectorBinding(placeholder: "MM",
                                        options: viewModel.monthOptions,
                                        isOpen: $isOpen,
                                        current: $viewModel.expirationMonthOption)
                DropdownSelectorBinding(placeholder: "YYYY",
                                        options: viewModel.yearOptions,
                                        isOpen: $isOpen2,
                                        current: $viewModel.expirationYearOption)
            }
        }
    }
    
    private var securityCodeView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Security Code")
                .font(.system(size: 14, weight: .medium, design: .rounded))
            
            CustomFormatTextField(unformattedText: $viewModel.securityCode,
                                  placeholder: "CVC",
                                  textPattern: "###",
                                  patternSymbol: "#",
                                  interceptor: NumberTextFieldInterceptor())
            .autocapitalization(.none)
            .keyboardType(.default)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    //.stroke(!text.isEmpty ? .pink : Color.gray, lineWidth: 1)
                    .stroke(.gray, lineWidth: 1)
            )
            .font(.system(size: 13))
            .foregroundColor(Color.black)
            //.foregroundColor(.appTextColor)
            .padding(.vertical, 5)
        }
    }
}

struct CreditCardStepView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
