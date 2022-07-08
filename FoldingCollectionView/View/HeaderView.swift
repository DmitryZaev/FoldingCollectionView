//
//  HeaderView.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 05.07.2022.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    static let identifire = "header"
    
    var text = String() {
        didSet {
            textLabel.text = text
        }
    }
    var myHeight: Double!
    
    let contentView = UIView()
    var showLessButton: UIButton!
    private let textLabel = UILabel()
    private let blurView = UIVisualEffectView()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .clear
        myHeight = bounds.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        textLabel.text?.removeAll()
        showLessButton.tag = Int.max
    }
    
    func addContentView() {
        contentView.backgroundColor = .clear
        contentView.alpha = 1
        addSubview(contentView)
        
        
        contentView.frame = CGRect(x: bounds.width * 0.025,
                                   y: bounds.height,
                                   width: bounds.width * 0.95,
                                   height: bounds.height)
    }
    
    func addTextLabel() {
        textLabel.textAlignment = .left
        textLabel.textColor = .white
        textLabel.font = .boldSystemFont(ofSize: 25)
        textLabel.backgroundColor = .clear
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2),
            textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/4),
        ])
    }
    
    func addButton() {
        showLessButton = UIButton()
        showLessButton.backgroundColor = .clear
        showLessButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        showLessButton.tintColor = .darkGray
        showLessButton.setTitle("Show less", for: .normal)
        showLessButton.titleLabel?.font = .systemFont(ofSize: 14)
        showLessButton.setTitleColor(.darkGray, for: .normal)
        showLessButton.layer.cornerRadius = bounds.height / 3
        showLessButton.layer.masksToBounds = true
        
        contentView.addSubview(showLessButton)
        showLessButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showLessButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            showLessButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/3),
            showLessButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/4),
            showLessButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        blurView.effect = blurEffect
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        showLessButton.addSubview(blurView)
        showLessButton.sendSubviewToBack(blurView)
        showLessButton.bringSubviewToFront(showLessButton.imageView ?? UIView())
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: showLessButton.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: showLessButton.widthAnchor),
            blurView.centerXAnchor.constraint(equalTo: showLessButton.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: showLessButton.centerYAnchor)
        ])
    }
}
