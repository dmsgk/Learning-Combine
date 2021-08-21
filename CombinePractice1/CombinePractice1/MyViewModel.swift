//
//  MyViewModel.swift
//  CombinePractice1
//
//  Created by Johyeon Yoon on 2021/08/21.
//

import Foundation
import Combine

class MyViewModel {
    @Published var passwordInput : String = "" {
        didSet {
            print("passwordInput: \(passwordInput)")
        }
    }
    @Published var passwordConfirmInput : String  = "" {
        didSet {
            print("passwordConfirmInput: \(passwordConfirmInput)")
        }
    }
}
