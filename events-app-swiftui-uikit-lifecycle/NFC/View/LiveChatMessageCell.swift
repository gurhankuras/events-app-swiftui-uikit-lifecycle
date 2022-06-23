//
//  TableViewCell.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/7/22.
//
import UIKit

extension UIColor {
    static var cellColor: UIColor {
        .init { (trait: UITraitCollection) -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
            } else {
                return UIColor.white
            }
        }
    }
    
    static var messageUsernameColor: UIColor {
        .init { (trait: UITraitCollection) -> UIColor in
            if trait.userInterfaceStyle == .light {
                return UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
            } else {
                return UIColor.systemGray
            }
        }
    }
     
}

class LiveChatMessageCell: UITableViewCell {
    static let identifier = String(describing: LiveChatMessageCell.self)
    var messageLeadingConstraint: NSLayoutConstraint!
    var messageCenterYConstraint: NSLayoutConstraint!
    var messageTrailingConstraint: NSLayoutConstraint!

    
    lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var image: UIImageView = {
        
        let image = UIImage(named: "hisoka")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemPink
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.attributedText = LiveChatMessageAttributedStringMaker(message: .init(image: "", timestamp: "", username: "", text: "")).make()
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setMessage(_ message: LiveChatMessage) {
        self.timestampLabel.attributedText = LiveChatMessageAttributedStringMaker(message: message).make()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
            let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
            let minHeight: CGFloat = 60
            return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .cellColor
        addSubview(timestampLabel)
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50)
        ])
  
        
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timestampLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timestampLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            //timestampLabel.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

func actualNumberOfLines(label: UILabel) -> Int {
        // You have to call layoutIfNeeded() if you are using autoLayout
        label.layoutIfNeeded()

        let myText = label.text! as NSString

        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font as Any], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct LiveChatMessageCell_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            var cell = LiveChatMessageCell(style: .default, reuseIdentifier: "")
            return cell
        }
        .frame(width: .infinity, height: 70, alignment: .center)
        .previewLayout(.sizeThatFits)
    }
}
#endif
