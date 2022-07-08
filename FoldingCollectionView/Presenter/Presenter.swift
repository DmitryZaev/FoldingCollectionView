//
//  Presenter.swift
//  FoldingCollectionView
//
//  Created by Dmitry Victorovich on 01.06.2022.
//

class Presenter: PresenterProtocol {
    
    weak var view: ViewProtocol!
    private var pushDictionary = [String : [PushMessage]]()
    private var sectionsDictionary = [Int : (name: String, foldedState: Bool, havePresentedHeader: Bool)]()
    var sectionIndex = 0
    
    func initial() {
        let background = Background()
        view.addBackground(imageName: background.imageName)
        
        guard let view = view as? MainView else { return }
        let button = Button(height: Int(view.bounds.height / 20),
                            width: Int(view.bounds.width / 2),
                            bottomOffsetY: 20)
        
        view.addButton(height: button.height,
                       width: button.width,
                       bottomOffset: button.bottomOffsetY)
        view.addCollectionView()
    }
    
    func createMessage() {
        let newMessage = PushMessage(appName: Apps.allCases.randomElement()!,
                                     text: "You have a new message!")
        if pushDictionary[newMessage.appName.rawValue] == nil {
            pushDictionary[newMessage.appName.rawValue] = [newMessage]
            sectionsDictionary[sectionIndex] = (name: newMessage.appName.rawValue, foldedState: false, havePresentedHeader: false)
            sectionIndex += 1
        } else {
        	pushDictionary[newMessage.appName.rawValue]?.append(newMessage)
        }
        for section in 0...(sectionIndex - 1) {
            if pushDictionary[sectionsDictionary[section]!.name]!.count >= 3 {
                sectionsDictionary[section]?.foldedState = true
                sectionsDictionary[section]?.havePresentedHeader = false
            }
        }
        view.updateMessages()
    }
    
    func getNubmerOfMessagesIn(section: Int) -> Int {
        guard let thisSection = sectionsDictionary[section],
              let messages = pushDictionary[thisSection.name]
        else { return 0 }
        return messages.count
    }
    
    func getMessageFor(section: Int, row: Int) -> PushMessage {
        guard let thisSection = sectionsDictionary[section],
              let messages = pushDictionary[thisSection.name]
        else { return PushMessage(appName: .vk, text: "") }
        return messages[row]
    }
    
    func needsFolding(section: Int) -> Bool {
        guard let thisSection = sectionsDictionary[section],
              let messages = pushDictionary[thisSection.name]
        else { return false }
        return messages.count >= 3
    }
    
    func getSectionName(section : Int) -> String {
        guard let thisSection = sectionsDictionary[section] else { return ""}
        return thisSection.name
    }
    
    func getFoldedStateOf(section: Int) -> Bool {
        guard let thisSection = sectionsDictionary[section] else { return false}
        return thisSection.foldedState
    }
    
    func unfold(section: Int) {
        sectionsDictionary[section]?.foldedState = false
        view.update(section: section, folding: false)
    }
    
    func fixHavePresentedHeader(section: Int, haveHeader: Bool) {
        sectionsDictionary[section]?.havePresentedHeader = haveHeader
    }
    
    func fold(section: Int) {
        guard sectionsDictionary.keys.contains(section) else { return }
        sectionsDictionary[section]!.foldedState = true
        view.update(section: section, folding: true)
    }
    
    func getAvailabilityPresentedHeader(section: Int) -> Bool {
        guard let thisSection = sectionsDictionary[section] else { return false }
        return thisSection.havePresentedHeader
    }
}
