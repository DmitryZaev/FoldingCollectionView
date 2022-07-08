//
//  MainView.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

import UIKit

class MainView: UIView {
    
    var presenter: PresenterProtocol!
    private var addButton: AddPushButton!
    let collectionView = CollectionView(frame: .zero,
                                        collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addMessage() {
        presenter.createMessage()
    }
}

//MARK: - ViewProtocol
extension MainView: ViewProtocol {
    
    func addBackground(imageName: String) {
        let backgroundImageView = UIImageView(image: .init(named: imageName))
        backgroundImageView.frame = frame
        addSubview(backgroundImageView)
    }
    
    func addButton(height: Int, width: Int, bottomOffset: Int) {
        addButton = AddPushButton()
        addButton.layer.cornerRadius = CGFloat(height / 3)
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            addButton.widthAnchor.constraint(equalToConstant: CGFloat(width)),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(-bottomOffset))
        ])
        addButton.addTarget(self, action: #selector(addMessage), for: .touchUpInside)
    }
    
    func addCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.frame.size = CGSize(width: bounds.width,
                                           height: bounds.height)
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -(bounds.height / 30))
        ])
    }
    
    func updateMessages() {
        collectionView.reloadData()
    }
    
    func update(section: Int, folding: Bool) {
        if folding {
            guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: [section, 0]) as? HeaderView else { return }
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .beginFromCurrentState) {
                header.contentView.alpha = 0
                header.contentView.frame = header.contentView.frame.offsetBy(dx: 0, dy: header.myHeight)
            }
            
            collectionView.performBatchUpdates {
                for item in 1...(presenter.getNubmerOfMessagesIn(section: section) - 1) {
                    let indexPath : IndexPath = [section, item]
                    guard let cell = collectionView.cellForItem(at: indexPath) as? CustomMessageCell else { return }
                    cell.prepareForReuse()
                    cell.configureSelf(with: presenter.getMessageFor(section: section, row: item), cellNumber: item, foldedSection: folding)
                    cell.contentView.alpha = 1
                    if item > 2 {
                        UIView.animate(withDuration: 0.2) {
                            cell.contentView.alpha = 0
                        } completion: { _ in
                            cell.isHidden = true
                        }
                    }
                }
            } completion: { _ in
                self.presenter.fixHavePresentedHeader(section: section, haveHeader: false)
                self.collectionView.reloadData()
            }
        } else {
            collectionView.performBatchUpdates {
                for item in 1...(presenter.getNubmerOfMessagesIn(section: section) - 1) {
                    let indexPath : IndexPath = [section, item]
                    guard let cell = collectionView.cellForItem(at: indexPath) as? CustomMessageCell else { return }
                    cell.prepareForReuse()
                    cell.addSubview(for: presenter.getMessageFor(section: section, row: item))
                    cell.isHidden = false
                }
            }
        }
    }
}
