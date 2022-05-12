//
//  Banner.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 5/11/22.
//

import Foundation
import UIKit

enum BannerAction {
    case close
    case custom(() -> ())
}

enum BannerIcon {
    case success
    case failure
}


class Banner: UIView {
    var closeCallback: (() -> ())?
    
    lazy var closeButton: UIImageView = {
        let closeImage = UIImageView(image: .init(systemName: "xmark"))
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeImage.tintColor = .white
        closeImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClose))
        closeImage.addGestureRecognizer(tap)
        return closeImage
    }()

    
    lazy var indicatorImage: UIImageView = {
        let image = UIImageView(image: .init(systemName: "checkmark.circle.fill"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .green
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "yok"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 13, weight: .medium)
        
        label.textColor = .white
        return label
    }()
    
    
    @objc private func onClose() {
        print("onClose")
        closeCallback?()
    }
    
    func configure(text: String, icon: BannerIcon, action: BannerAction) {
        setTitle(text)
        setIcon(icon)
        setAction(action)
    }
    
    private func setTitle(_ text: String) {
        label.text = text
    }
    
    private func setIcon(_ icon: BannerIcon) {
        switch icon {
        case .success:
            indicatorImage.image =  .init(systemName: "checkmark.circle.fill")
            indicatorImage.tintColor = .green
        case .failure:
            indicatorImage.image = .init(systemName: "xmark.circle.fill")
            indicatorImage.tintColor = .red
        }
    }
    
    private func setAction(_ action: BannerAction) {
        switch action {
        case .close:
            closeCallback = { BannerService.shared.dismiss() }
        case .custom(let callback):
            closeCallback = callback
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.7)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(indicatorImage)
        let imageConstraints = [
            indicatorImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            indicatorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(imageConstraints)

        
        
        addSubview(closeButton)
        let closeButtonConstraints = [
            closeButton.centerYAnchor.constraint(equalTo: indicatorImage.safeAreaLayoutGuide.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ]
        NSLayoutConstraint.activate(closeButtonConstraints)

        
        
        addSubview(label)
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: indicatorImage.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: indicatorImage.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -15)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Banner_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let v = Banner()
            v.configure(text: "Merhaba", icon: .success, action: .close)
            return v
        }
        .preferredColorScheme(.light)
    }
}
#endif

