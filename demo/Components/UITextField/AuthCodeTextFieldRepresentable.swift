//
//  AuthCodeTextFieldRepresentable.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import THLogger
import Combine
import SwiftUI

struct AuthCodeTextFieldRepresentable: UIViewRepresentable {
    @Binding private var text: String
    @Binding var focusTag: Int?
    
    private let doneStringKey: String
    private let tableName: String
    private let tag: Int
    
    private let tapTextFieldSubject: PassthroughSubject<Int, Never>
    private let didBeginEditingSubject: PassthroughSubject<Void, Never>
    private let didEndEditingSubject: PassthroughSubject<Void, Never>
    private let editingChangedSubject: PassthroughSubject<String, Never>
    private let deleteBackwardSubject: PassthroughSubject<Void, Never>
    private let redoSubject: PassthroughSubject<Void, Never>
    
    private let textField = BaseUITextField()
    
    init(
        text: Binding<String>,
        focusTag: Binding<Int?>,
        doneStringKey: String,
        tableName: String,
        tag: Int,
        tapTextFieldSubject: PassthroughSubject<Int, Never>,
        didBeginEditingSubject: PassthroughSubject<Void, Never>,
        didEndEditingSubject: PassthroughSubject<Void, Never>,
        editingChangedSubject: PassthroughSubject<String, Never>,
        deleteBackwardSubject: PassthroughSubject<Void, Never>,
        redoSubject: PassthroughSubject<Void, Never>
    ) {
        self._text = text
        self._focusTag = focusTag
        self.doneStringKey = doneStringKey
        self.tableName = tableName
        self.tag = tag
        self.tapTextFieldSubject = tapTextFieldSubject
        self.didBeginEditingSubject = didBeginEditingSubject
        self.didEndEditingSubject = didEndEditingSubject
        self.editingChangedSubject = editingChangedSubject
        self.deleteBackwardSubject = deleteBackwardSubject
        self.redoSubject = redoSubject
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> BaseUITextField {
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.returnKeyType = .default
        textField.tag = tag
        textField.textAlignment = .center
        textField.deleteBackwardSubject = deleteBackwardSubject
        textField.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.onEditingChanged(_:)),
            for: .editingChanged
        )
        
        return textField
    }
    
    func updateUIView(_ uiView: BaseUITextField, context: Context) {
        if uiView.tag == focusTag {
            uiView.becomeFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        private let parent: AuthCodeTextFieldRepresentable
        
        private var cancellables: Set<AnyCancellable> = []
        
        init(_ parent: AuthCodeTextFieldRepresentable) {
            self.parent = parent
            
            parent.deleteBackwardSubject
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    if parent.text.count < 1 && parent.textField.tag == parent.focusTag {
                        parent.redoSubject.send()
                    }
                }
                .store(in: &cancellables)
        }
        
        @objc func onEditingChanged(_ textField: UITextField) {
            Task { @MainActor in
                guard let text = textField.text else { return }
                parent.text = text
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.tapTextFieldSubject.send(textField.tag)
            parent.didBeginEditingSubject.send()
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.didEndEditingSubject.send()
        }
        
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            /**
             1. 文字数が1より小さいなら入力を許可してフォーカスを1つ進める
             2. 文字数が1より小さいかつbackspaceならフォーカスを一つ進める
             3. 文字数が1より大きくてもbackspaceなら編集を許す
             4. それ以外の場合は編集を許さない
             */
            if range.length < 1 {
                parent.editingChangedSubject.send(string)
                return true
            } else {
                if string.isBackSpace() {
                    return true
                } else {
                    return false
                }
            }
        }
    }
}
