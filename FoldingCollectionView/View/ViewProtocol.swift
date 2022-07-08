//
//  ViewProtocol.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

protocol ViewProtocol: AnyObject {
    
    func addBackground(imageName: String)
    func addButton(height: Int, width: Int, bottomOffset: Int)
    func addCollectionView()
    func updateMessages()
    func update(section: Int, folding: Bool)
}
