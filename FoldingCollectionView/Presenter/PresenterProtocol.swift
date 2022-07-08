//
//  PresenterProtocol.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

protocol PresenterProtocol: AnyObject {
    
    var sectionIndex: Int { get set }
    
    func initial()
    func createMessage()
    func getNubmerOfMessagesIn(section: Int) -> Int
    func getMessageFor(section: Int, row: Int) -> PushMessage
    func needsFolding(section: Int) -> Bool
    func getSectionName(section : Int) -> String
    func getFoldedStateOf(section: Int) -> Bool
    func unfold(section: Int)
    func fold(section: Int)
    func fixHavePresentedHeader(section: Int, haveHeader: Bool)
    func getAvailabilityPresentedHeader(section: Int) -> Bool
}
