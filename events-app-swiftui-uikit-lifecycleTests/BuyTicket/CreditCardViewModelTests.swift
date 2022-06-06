//
//  CreditCardViewModelTests.swift
//  events-app-swiftui-uikit-lifecycleTests
//
//  Created by Gürhan Kuraş on 6/1/22.
//

import XCTest
import Combine

class CreditCardFormViewModel2: ObservableObject {
    let cardHolderField = CardHolderFieldViewModel()
    let cardNumberField = CardNumberFieldViewModel()
    let cvcNumberField = CVCFieldViewModel()
    
    let bag = Set<AnyCancellable>()
    
    @Published var isValid: Bool = false
    private let currentMonth: Int
    private let currentYear: Int

    init() {
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        currentMonth = components.month!
        currentYear = components.year!

        cardHolderField.$text
            .combineLatest(cardNumberField.$text, cvcNumberField.$text)
            .map { [cardHolderField, cardNumberField, cvcNumberField] _ in
                cardNumberField.isValid && cardHolderField.isValid && cvcNumberField.isValid
            }
            .assign(to: &$isValid)
    }
}

class CardHolderFieldViewModel: ObservableObject {
    @Published var text: String = ""
    
    var isValid: Bool {
        text.count <= 80
    }
}

class CVCFieldViewModel: ObservableObject {
    @Published var text: String = ""
    
    var isValid: Bool {
        text.count == 3
    }
}

class CardNumberFieldViewModel: ObservableObject {
    @Published var text: String = ""
    
    var isValid: Bool {
        text.count == 16
    }
}

class FormValiditySpy {
    private(set) var states: [Bool] = []
    
    var bag = Set<AnyCancellable>()
    
    init(_ publisher: AnyPublisher<Bool, Never>) {
        
        publisher.sink { [weak self] state in
            self?.states.append(state)
        }
        .store(in: &bag)
    }
    
    var last: Bool? {
        states.last
    }

}

class CreditCardViewModelTests: XCTestCase {
    func makeSUT() -> (sut: CreditCardFormViewModel2, spy: FormValiditySpy) {
        let form = CreditCardFormViewModel2()
        let spy = FormValiditySpy(form.$isValid.eraseToAnyPublisher())
        
        return (form, spy)
    }

    func test_initialState() throws {
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.states, [false])
    }
    
    func test_formStillInvalid_whenNumberFieldHas16Digits() throws {
        let (sut, spy) = makeSUT()
        
        //form.cardHolderField.text = "asdasd"
        sut.cardNumberField.text = "1234123412341234"
        XCTAssertEqual(spy.states, [false, false])
    }
    
    func test_formIsNotValid_whenCardNumberNotEnteredCorrectly() throws {
        let (sut, spy) = makeSUT()
        
        //form.cardHolderField.text = "asdasd"
        sut.cardHolderField.text = "Joe Doe"
        XCTAssertEqual(spy.states, [false, false])
    }
    
    func test_formIsNotValid_whenCVCNotEnteredCorrectly() throws {
        let (sut, spy) = makeSUT()
        
        sut.cardNumberField.text = "1234123412341234"
        sut.cardHolderField.text = "Joe Doe"
        
        XCTAssertEqual(spy.states, [false, false, false])
    }
    
    func test_formIsValid_AllFieldsSatisfies() throws {
        let (sut, spy) = makeSUT()
        
        sut.cardNumberField.text = "1234123412341234"
        sut.cvcNumberField.text = "123"
        sut.cardHolderField.text = "Joe Doe"
        
        print(spy.states)
        
        XCTAssertEqual(spy.states, [false, false, false, true])
    }
    
    
    
}
