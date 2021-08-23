//
//  ViewController.swift
//  CombinePractice2
//
//  Created by Johyeon Yoon on 2021/08/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var myLabel: UILabel!
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.accessibilityIdentifier = "mySearchBarTextField"
        return searchController
    }()
    
    var mySubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.searchController = searchController
        searchController.isActive = true
        
        searchController.searchBar.searchTextField
            .myDebounceSearchPublisher
            .sink(receiveValue: {[weak self] (receivedValue) in
                guard let self = self else { return }
                
                print("receivedValue : \(receivedValue)")
                self.myLabel.text = receivedValue
            }).store(in: &mySubscriptions)
    }


}


extension UISearchTextField {
    var myDebounceSearchPublisher : AnyPublisher<String,Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            // NotificationCenter에서 UISearchTextField 가져옴
            .compactMap{ $0.object as? UISearchTextField}
            .map{ $0.text ?? ""}
            // 디바운스
            .debounce(for: .milliseconds(1000) , scheduler: RunLoop.main)
            .filter{ $0.count > 0}
            .eraseToAnyPublisher()
    }
}

