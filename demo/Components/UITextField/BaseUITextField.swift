//
//  BaseUITextField.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import Combine
import UIKit

class BaseUITextField: UITextField {
    var deleteBackwardSubject: PassthroughSubject<Void, Never>?
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if let deleteBackwardSubject = deleteBackwardSubject {
            deleteBackwardSubject.send()
        }
    }
}
