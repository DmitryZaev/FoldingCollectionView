//
//  AddPushButton.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

import UIKit

class AddPushButton: UIButton {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        configureSelf()
        addBlur()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        setTitle("Add Push-Message", for: .normal)
        setTitleColor(.lightGray, for: .normal)
        setTitleColor(.white, for: .highlighted)
        backgroundColor = .clear
        layer.masksToBounds = true
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: heightAnchor),
            blurView.widthAnchor.constraint(equalTo: widthAnchor),
            blurView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
