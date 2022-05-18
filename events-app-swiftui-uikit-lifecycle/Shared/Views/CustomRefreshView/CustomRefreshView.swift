//
//  CustomRefreshView.swift
//  swiftui-refresh
//
//  Created by Gürhan Kuraş on 5/18/22.
//

/// https://www.youtube.com/c/Kavsoft
/// https://www.youtube.com/watch?v=5rD5GhYVBPg

import SwiftUI
import Lottie

class Refresher {
    deinit {
        print("Refresher \(#function)")
    }
    var stopRefreshing: (() -> ())?
}

struct CustomRefreshView<Content: View>: View {
    var showsIndicator: Bool
    var lottieFileName: String
    var content: Content
    var onRefresh: (Refresher) -> ()
    var refreshHeight: CGFloat
        
    @StateObject var scrollDelegate: RefreshScrollViewModel = .init()
    
    init(showsIndicator: Bool = false,
         lottieFileName: String,
         @ViewBuilder content: @escaping () -> Content,
         onRefresh: @escaping (Refresher) -> (),
         refreshHeight: CGFloat? = nil) {
        self.showsIndicator = showsIndicator
        self.lottieFileName = lottieFileName
        self.content = content()
        self.onRefresh = onRefresh
        self.refreshHeight = refreshHeight ?? 85
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicator) {
            VStack(spacing: 0) {
                ResizebleLottieView(fileName: lottieFileName, isPlaying: $scrollDelegate.isRefreshing)
                    .scaleEffect(scrollDelegate.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.2), value: scrollDelegate.isEligible)
                    .overlay{
                        preRefreshContent
                    }
                    .frame(height: refreshHeight * scrollDelegate.progress)
                    .opacity(scrollDelegate.progress)
                    .offset(y: scrollDelegate.isEligible ? -max(0, scrollDelegate.contentOffset) : -max(0, scrollDelegate.scrollOffset)
                    )
                content
            }
            .offset(coordinateSpace: "SCROLL", offset: handleOffset(_:))
        }
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { refreshing in
            if refreshing {
                let refresher = Refresher()
                refresher.stopRefreshing = scrollDelegate.reset
                onRefresh(refresher)
            }
        }
    }
    
    func handleOffset(_ offset: CGFloat) {
        scrollDelegate.contentOffset = offset
        if !scrollDelegate.isEligible {
            var progress = offset / scrollDelegate.refreshOffsetThreshold
            progress = clamp(progress, min: 0, max: 1)
            scrollDelegate.scrollOffset = offset
            scrollDelegate.progress = progress
        }
        
        if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
            scrollDelegate.isRefreshing = true
        }
    }
    
    private var preRefreshContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down")
                .font(.caption.bold())
                .foregroundColor(.white)
                .rotationEffect(.degrees(scrollDelegate.progress * 180))
                .padding(8)
                .background(Color(.secondaryLabel), in: Circle())
            
            Text("pull-to-refresh")
                .font(.caption.bold())
                .foregroundColor(.primary)
        }
        .opacity(scrollDelegate.isEligible ? 0 : 1)
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
    }
}


struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView(showsIndicator: false, lottieFileName: "loading") {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
            
        } onRefresh: { _ in }
    }
}

extension View {
    func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { geo in
                    let minY = geo.frame(in: .named(coordinateSpace)).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            offset(value)
                        }
                }
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



