//
//  ScrollPopup.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 4/25/22.
//

import UIKit

class ScrollPopup: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        isUserInteractionEnabled = true
        backgroundColor = .purple
        translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
    }
    
    private func configureSubviews() {
        let image = UIImage(systemName: "house")
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        addSubview(imageView)
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
