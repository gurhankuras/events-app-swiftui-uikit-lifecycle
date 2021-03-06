//
//  CreateEventView.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/17/22.
//

import SwiftUI

enum EventPlaceType: String {
    case physical = "physical"
    case online = "online"
    case both = "both"
}

struct EventGeneralInfoStep {
    let title: String
    let description: String
    let startAt: Date
    let certification: Bool
    let image: UIImage
    let placeType: EventPlaceType
}

import Combine
/*
func todayWithoutMilliseconds() -> Date {
   let date = Date()
   let calendar = Calendar.current
   var components = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: date as Date)
   let tempDate = calendar.date(from: components)!
   return tempDate
}
 */

class StepViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var startAt = Date()
    @Published var hasCertification: Bool = false
    @Published var placeType: EventPlaceType = .physical
    var bag = Set<AnyCancellable>()
    
    
    private var _next: ((EventGeneralInfoStep) -> ())
    
    init(next: @escaping ((EventGeneralInfoStep) -> ())) {
        self._next = next
        $startAt.sink { date in
            print(date)
        }
        .store(in: &bag)
    }
    
    func next(image: UIImage) {
        _next(.init(title: title,
                    description: description,
                    startAt: startAt,
                    certification: hasCertification,
                    image: image,
                    placeType: placeType
                   ))
    }
    
    lazy var allowedStartingDateRange: PartialRangeFrom<Date> = {
        let calender = Calendar.current
        guard let tomorrow = calender.date(byAdding: .day, value: 1, to: Date()) else {
            return Date.distantFuture...
        }
        let startingDateComponents = tomorrow
        return tomorrow...
    }()
}

struct NewEventView: View {
    @ObservedObject var step: StepViewModel
    let dismiss: () -> ()
    
    init(viewModel: StepViewModel, dismiss: @escaping () -> ()) {
        self.dismiss = dismiss
        self._step = ObservedObject(initialValue: viewModel)
    }
    @State var image: UIImage?
    @State var height: CGFloat = 150
    @State var selectionOpen: Bool = false
    @State var holdStatusOption: DropdownOption? = DropdownOption(key: "physical", value: "event-held-option-physical".localized())
    
    let options = [
        DropdownOption(key: "physical", value: "event-held-option-physical".localized()),
        DropdownOption(key: "online", value: "event-held-option-online".localized()),
        DropdownOption(key: "both", value: "event-held-option-both".localized())
    ]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    CloseButton {
                        dismiss()
                    }
                    .padding(.bottom)
                    viewTitle
                    HStack(alignment: .top) {
                        ImageUploadView(selectedImage: $image)
                            .cornerRadius(5)
                        VStack {
                            TextField("title-form-field-placeholder", text: $step.title)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .textFieldStyle(.roundedBorder)
                                .disableAutocorrection(true)
                            datePicker
                        }
                    }
                    .padding(.bottom)
                    
                    descriptionTextView
                    Toggle(isOn: $step.hasCertification) {
                        Text("certification-question")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                    }
                    .tint(.appPurple)
                    
                    Text("event-held-question")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                    DropdownSelectorBinding(placeholder: "-", options: options, isOpen: $selectionOpen, current: $holdStatusOption)
                    .onChange(of: holdStatusOption) { newValue in
                            guard let newValue = newValue,
                                  let place =  EventPlaceType(rawValue: newValue.key) else {
                                return
                            }
                            step.placeType = place
                    }
                    .zIndex(999)
                    
                    Spacer()
                    LongRoundedButton(text: "continue-button",
                                      active: .constant(true),
                                      action: {
                                        guard let image = image else {
                                            return
                                        }

                                        step.next(image: image)
                                    })
                }
                .padding(.all)
                .frame(maxWidth: .infinity)
                .frame(height: geo.size.height)
            }
        }
        
        
    }
    
    
    var viewTitle: some View {
        Text("create-event-title")
            .font(.system(size: 21, weight: .semibold, design: .rounded))
    }
    
    
    @ViewBuilder var datePicker: some View {
        Text("date-picker")
            .font(.system(size: 14, weight: .regular, design: .rounded))
        
        DatePicker(selection: $step.startAt,
                  
                   displayedComponents: [.date, .hourAndMinute]) {}
        .labelsHidden()
    }
    
    var descriptionTextView: some View {
        ResizableTextField(text: $step.description,
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
        NewEventView(viewModel: .init(next: {_ in}), dismiss: {})
            .preferredColorScheme(.dark)
    }
}
