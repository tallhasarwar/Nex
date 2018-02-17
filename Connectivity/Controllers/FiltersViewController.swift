//
//  FiltersViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 04/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

protocol FiltersDelegate {
    func didChangeFilters(hashtags: String?)
}

class FiltersViewController: UIViewController, UITextViewDelegate, SuggestionTableDelegate {

    static let storyboardID = "filtersViewController"
    
    @IBOutlet weak var filtersTextView: FloatLabelTextView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var ownPostSwitch: UISwitch!
    
    var delegate: FiltersDelegate?
    var suggestionsTable: SuggestionTable!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filters"
        filtersTextView.delegate = self
        suggestionsTable = SuggestionTable(over: filtersTextView, in: self)
        
        let value = UserDefaults.standard.value(forKey: UserDefaultKey.geoFeedRadius)
        if let radiusValue = value as? Float {
            radiusSlider.value = radiusValue
            sliderValueChanged(radiusSlider)

        }
        
        let on = UserDefaults.standard.bool(forKey: UserDefaultKey.ownPostsFilter)
        ownPostSwitch.isOn = on
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let value = String(format: "%.2f", arguments: [radiusSlider.value])
        
        radiusLabel.text = value
        UserDefaults.standard.set(Float(value), forKey: UserDefaultKey.geoFeedRadius)
        
    }
    
    @IBAction func sliderEditingChanged(_ sender: Any) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let text = filtersTextView.text
        let tags = text?.components(separatedBy: .whitespacesAndNewlines).filter { $0.hasPrefix("#") }
        let refinedTags = tags?.map{ $0.dropFirst() }
        
        self.delegate?.didChangeFilters(hashtags: refinedTags?.joined(separator: ","))
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func ownPostSwitchChanged(_ sender: Any) {
        let slider = sender as! UISwitch
        let on = slider.isOn
        UserDefaults.standard.set(on, forKey: UserDefaultKey.ownPostsFilter)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if let lastWord = textView.text.components(separatedBy: .whitespacesAndNewlines).last {
            if lastWord.first == "#" {
                let list = Constant.hashtags.filter { $0.lowercased().hasPrefix(lastWord.lowercased()) }
                suggestionsTable.refreshList(listValues: list)
                self.view.bringSubview(toFront: suggestionsTable)
            }
            else{
                suggestionsTable.isHidden = true
            }
        }
        else{
            suggestionsTable.isHidden = true
        }
        textView.convertHashtags()
    }
    
    func suggestionSelected(value: String) {
        if let text = filtersTextView.text {
            var word = text.components(separatedBy: .whitespacesAndNewlines)
            word.removeLast()
            var newWord = word.joined(separator: " ")
            newWord.append("\(value) ")
            filtersTextView.text = newWord
        }
        filtersTextView.convertHashtags()
    }
    

}
