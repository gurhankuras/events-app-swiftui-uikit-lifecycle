//
//  NewEventAddressStepViewModel.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/14/22.
//

import Foundation

class NewEventAddressStepViewModel: ObservableObject {
    @Published var addressLine: String = ""
    @Published var zipCode: String = ""
    @Published var city: String = ""
    @Published var country: String = ""
    
    @Published var isCountryDropdownOpen = false
    @Published var isCityDropdownOpen = false
    @Published var valid: Bool = false
    @Published var selectedCategories: Set<EventCategoryType> = []

    
    init() {
        $country.combineLatest($city, $zipCode, $selectedCategories)
            .map { country, city, zipcode, categories in
                print(country)
                print(city)
                return !country.isEmpty && country != "-" && city != "-" && !city.isEmpty && !categories.isEmpty
                //country != "-" && city != "-" && !zipcode.isEmpty
            }
            .assign(to: &$valid)
    }
    
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
    
    func completeStep() -> NewEventBillingAddressStep {
        return NewEventBillingAddressStep(country: country,
                                  city: city.lowercased(with: Locale(identifier: "tr")),
                                  addressLine: addressLine,
                                  zipCode: zipCode,
                                 categories: Array(selectedCategories))
    }
    
    func toggleCategory(_ category: EventCategoryType) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    func contains(_ category: EventCategoryType) -> Bool {
        return selectedCategories.contains(category)
    }
    
    
}
