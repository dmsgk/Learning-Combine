//
//  ViewController.swift
//  CombinePractice1
//
//  Created by Johyeon Yoon on 2021/08/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    @IBOutlet var myButton: UIButton!
    
    var viewModel : MyViewModel!
    
    private var mySubscriptions = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = MyViewModel()
        
        passwordTextField.myTextPublisher
            .receive(on: RunLoop.main)
            // 구독
            .assign(to: \.passwordInput, on: viewModel)
            // 메모리 해제
            .store(in: &mySubscriptions)
        
        passwordConfirmTextField.myTextPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &mySubscriptions)
        
        
        // 버튼이 뷰모델의 publisher를 subscribe
        viewModel.isMatchPasswordInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: myButton)
            .store(in: &mySubscriptions)
        
    }
    


}

extension UITextField {
    var myTextPublisher : AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map{ $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}


extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : .lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
