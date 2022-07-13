//
//  ViewController.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.mainView.presenter.initial()
        }
    }
}

