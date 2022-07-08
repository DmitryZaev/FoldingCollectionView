//
//  CollectionView.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 04.07.2022.
//

import UIKit

class CollectionView: UICollectionView {
    
    var presenter: PresenterProtocol!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super .init(frame: frame, collectionViewLayout: layout)
        
        register(CustomMessageCell.self, forCellWithReuseIdentifier: CustomMessageCell.identifire)
        register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifire)
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource
extension CollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.sectionIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNubmerOfMessagesIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomMessageCell.identifire, for: indexPath) as? CustomMessageCell
        cell?.configureSelf(with: presenter.getMessageFor(section: indexPath.section, row: indexPath.item),
                            cellNumber: indexPath.item,
                            foldedSection: presenter.getFoldedStateOf(section: indexPath.section))
        
        cell?.layer.zPosition = CGFloat(1000 - indexPath.item)
        
        if presenter.getFoldedStateOf(section: indexPath.section), indexPath.item > 2 {
            cell?.isHidden = true
        }
        return cell ?? CustomMessageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if !presenter.getFoldedStateOf(section: indexPath.section), !presenter.getAvailabilityPresentedHeader(section: indexPath.section) {
            let header = careateHeader(in: collectionView, for: indexPath) as? HeaderView
            guard let header = header else { return UICollectionReusableView()}
            UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState) {
                header.contentView.alpha = 1
                header.contentView.frame = header.contentView.frame.offsetBy(dx: 0, dy: -header.myHeight)
            }
            presenter.fixHavePresentedHeader(section: indexPath.section, haveHeader: true)
            return header
        } else {
            let header = careateHeader(in: collectionView, for: indexPath) as? HeaderView
            guard let header = header else { return UICollectionReusableView()}
            header.contentView.frame.origin.y -= header.myHeight
            return header
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let collectionHeight = collectionView.bounds.height
        let itemNumber = indexPath.item + 1
        let height : CGFloat = collectionHeight * 0.1
        var width : CGFloat = collectionWidth
        var index = 1 - 0.05 * Double(itemNumber)
        if index < 0.05 {
            index = 0.05
        }
        if presenter.getFoldedStateOf(section: indexPath.section) {
            width = collectionWidth * index
        } else {
            width = collectionView.bounds.width * 0.95
        }
        return CGSize(width: width,
                      height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let betweenCellsInterval = collectionView.bounds.height / 100
        let standartVerticalInset = betweenCellsInterval * 2
        
        if presenter.getFoldedStateOf(section: section) {
            let messageCount = presenter.getNubmerOfMessagesIn(section: section)
            return UIEdgeInsets(top: standartVerticalInset,
                                left: 0,
                                bottom: standartVerticalInset * 2 - CGFloat(messageCount - 1) * betweenCellsInterval,
                                right: 0)
        } else {
            return UIEdgeInsets(top: standartVerticalInset,
                                left: 0,
                                bottom: standartVerticalInset,
                                right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        var interval : CGFloat = collectionView.bounds.height / 100

        if presenter.getFoldedStateOf(section: section) {
            interval = -(collectionView.bounds.height / 10 - collectionView.bounds.height / 100)
        }
        return interval
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size = CGSize()
        if presenter.needsFolding(section: section), !presenter.getFoldedStateOf(section: section) {
        size = CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height / 20)
        }
        return size
    }
}

//MARK: - UICollectionViewDelegate
extension CollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if presenter.getFoldedStateOf(section: indexPath.section), indexPath.item <= 2 {
            self.presenter.unfold(section: indexPath.section)
        }
    }
//MARK: UICollectionViewDelegate -
    
    private func careateHeader(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifire, for: indexPath) as? HeaderView  else { return UICollectionReusableView()}
        header.text = presenter.getSectionName(section: indexPath.section)
        header.addContentView()
        header.addTextLabel()
        header.addButton()
        header.addBlur()
        header.showLessButton.tag = indexPath.section
        header.showLessButton.addTarget(self, action: #selector(showLessButtonDidPressed(sender:)), for: .touchUpInside)
        return header
    }
    
    @objc func showLessButtonDidPressed(sender: UIButton) {
        presenter.fold(section: sender.tag)
    }
}




