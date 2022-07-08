//
//  ModuleAssembler.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

import Foundation

class ModuleAssembler {
    
    static func configureView() -> ViewController {
        
        let viewController = ViewController()
        let presenter = Presenter()
        
        guard let mainView = viewController.view as? MainView else { return viewController }
        mainView.presenter = presenter
        presenter.view = mainView
        mainView.collectionView.presenter = presenter
        
        return viewController
    }
}
