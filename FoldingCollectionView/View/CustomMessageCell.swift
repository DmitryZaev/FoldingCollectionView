//
//  CustomMessageCell.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 04.07.2022.
//

import UIKit

class CustomMessageCell: UICollectionViewCell {
    
    static let identifire = "cell"
    
    private var imageName: String!
    private var topText: String!
    private var bottomText: String!
    private var iconImageView = UIImageView()
    private var topTextLabel = UILabel()
    private var bottomTextLabel = UILabel()
    private var blurView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        
        topTextLabel.text?.removeAll()
        bottomTextLabel.text?.removeAll()
        iconImageView.image = nil
        blurView.effect = nil
        self.contentView.alpha = 1
        isHidden = false
    }
    
    func configureSelf(with model: PushMessage, cellNumber: Int, foldedSection: Bool) {
        
        contentView.frame.size = bounds.size
        contentMode = .center
        backgroundColor = .clear
        layer.cornerRadius = bounds.height / 5
        layer.masksToBounds = true

        addSubview(for: model)
        if foldedSection, cellNumber > 2 {
            contentView.alpha = 0
        }
    }
    
    func addSubview(for model: PushMessage) {
        
        imageName = model.appName.rawValue
        topText = model.appName.rawValue
        bottomText = model.text
        
        addBlur()
        addIcon()
        addTextLabels()
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.frame.size = contentView.bounds.size
        blurView.center = contentView.center
        contentView.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            blurView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            blurView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func addIcon() {
        iconImageView = UIImageView(image: .init(named: imageName))
        iconImageView.backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 2/3),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                constant: contentView.frame.height / 6)
        ])
    }
    
    private func addTextLabels() {
        topTextLabel.backgroundColor = .clear
        topTextLabel.text = topText
        topTextLabel.font = .boldSystemFont(ofSize: 16)
        topTextLabel.textColor = .black
        topTextLabel.isUserInteractionEnabled = false
        contentView.addSubview(topTextLabel)

        bottomTextLabel.backgroundColor = .clear
        bottomTextLabel.text = bottomText
        bottomTextLabel.font = .systemFont(ofSize: 16)
        bottomTextLabel.textColor = .black
        bottomTextLabel.isUserInteractionEnabled = false
        contentView.addSubview(bottomTextLabel)
        
        topTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topTextLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            topTextLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor,
                                               constant: contentView.frame.height / 6),
            
            bottomTextLabel.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            bottomTextLabel.leftAnchor.constraint(equalTo: topTextLabel.leftAnchor)
        ])
    }
}
