//
//  Events.swift
//  play
//
//  Created by Gürhan Kuraş on 2/13/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit



//class EventDetailsViewModel
struct EventDetails: View {
    let viewModel: EventDetails.ViewModel
    let dismiss: () -> ()
    let buyTicket: () -> ()
    
    @State private var mapRegion: MKCoordinateRegion

    init(viewModel: EventDetails.ViewModel,
         dismiss: @escaping () -> (),
         buyTicket: @escaping () -> ()
    ) {
        self.viewModel = viewModel
        self.dismiss = dismiss
        self.buyTicket = buyTicket
        self._mapRegion = State(initialValue: viewModel.region)
    }
    

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                
                EventHeader(title: viewModel.nearEvent.title,
                            image: viewModel.nearEvent.image,
                            height: UIScreen.main.bounds.height * 0.3,
                            dismiss: dismiss)
                 
                InterestedUsers(users: viewModel.users, gap: 20)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ExpandableText(text: viewModel.nearEvent.description, initial: .closed)
                    .lineLimit(4)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                map
                watchButton
                joinButton
                
            }
        }
        .navigationBarHidden(true)
    }
    
    private var map: some View {
        Map(coordinateRegion: $mapRegion,
            annotationItems: [viewModel.nearEvent],
            annotationContent: { event in
                MapMarker(coordinate: .init(latitude: event.latitude, longitude: event.longitute), tint: .red)
            })
            .frame(maxWidth: .infinity)
            .frame(height: 200)
    }
     
    
    
    private var joinButton: some View {
        Button {
            buyTicket()
            print("Click")
        } label: {
            Text("Join")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    Capsule()
                        .fill(.pink)
                )
            
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var watchButton: some View {
        NavigationLink {
            LazyView {
                VideoPage()
            }
        } label: {
            Text("Join")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(
                    Capsule()
                        .fill(.pink)
                )
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
    
    struct EventDetailsImageOverlay: View {
        let text: String

        var body: some View {
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.width)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .background(LinearGradient(colors: [.black, .black.opacity(0.3)], startPoint: .bottom, endPoint: .top))
        }
    }

}



struct EventDetails_Previews: PreviewProvider {
    static var previews: some View {
        EventDetails(viewModel: .init(nearEvent: .stub),
                     dismiss: {},
                     buyTicket: {})
    }
}


struct EventHeader: View {
    
    // MARK: constructor
    let title: String
    let image: String
    let height: CGFloat
    let dismiss: () -> ()
    
    // MARK: constants
    let titleGradient = LinearGradient(colors: [.black, .black.opacity(0.3)],
                                       startPoint: .bottom,
                                       endPoint: .top)
    var body: some View {
        
        WebImage(url: URL(string: image))
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(eventTitle, alignment: .bottom)
            .overlay(backButton, alignment: .topLeading)
 }
    
    private var eventTitle: some View {
        Text(title)
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding()
            .background(titleGradient)
    }
    
    private var backButton: some View {
        Image(systemName: "arrow.backward")
            .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 0)
            .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 0)
            .shadow(color: .black.opacity(0.7), radius: 8, x: 0, y: 0)

            .padding(.top, 30)
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
            .foregroundColor(.white)
            .onTapGesture {
                dismiss()
            }
    }
}

struct InterestedUsers: View {
    let gap: Double
    let users: [String]
    
    init(users: [String], gap: Double)
    {
        self.gap = gap
        self.users = users
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Interested")
                .bold()
            ImageStack(gap: 50/2, imageUrls: users, content: { image in
                    image
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.appPurple)
                            .shadow(radius: 5)
                    )
                    
            }) {
                Text("+5")
                    .foregroundColor(.white)
            }
        }
        
    }
}

struct ImageStack<Content: View, AdditionalContent: View> : View {
    let gap: Double
    let imageUrls: [String]
    let content: (Image) -> Content
    let additionalContent: () -> AdditionalContent
    
    
    init(gap: Double,
         imageUrls: [String],
         content: @escaping (Image) -> Content,
         additionalContent: @escaping () -> AdditionalContent
    ) {
        self.gap = gap
        self.imageUrls = imageUrls
        self.content = content
        self.additionalContent = additionalContent
    }
    
    
    var body: some View {
        ZStack {
            ForEach(0..<imageUrls.count, id: \.self) { index in
                content(Image(imageUrls[index]))
                    .offset(x: CGFloat(Double(index) * Double(gap)))
            }
            additionalContent()
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(Color.appPurple)
                    .shadow(radius: 5)
            )
            .offset(x: CGFloat(Double(imageUrls.count) * gap))
        }
    }
}



