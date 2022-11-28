//
//  AuthCodeTextField.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import Combine
import SwiftUI

struct AuthCodeTextField: View {
    @StateObject private var viewModel: AuthCodeTextFieldViewModel = .init()
    
    private let tableName: String = .init(describing: Self.self)
    
    private var text: Binding<String>
    private var focusTag: Binding<Int?>
    
    private let tag: Int
    private let tapTextFieldSubject: PassthroughSubject<Int, Never>
    private let editingChangedSubject: PassthroughSubject<String, Never>
    private let deleteBackwardSubject: PassthroughSubject<Void, Never>
    
    init(
        text: Binding<String>,
        focusTag: Binding<Int?>,
        tag: Int,
        tapTextFieldSubject: PassthroughSubject<Int, Never>,
        editingChangedSubject: PassthroughSubject<String, Never>,
        deleteBackwardSubject: PassthroughSubject<Void, Never>
    ) {
        self.text = text
        self.focusTag = focusTag
        self.tag = tag
        self.tapTextFieldSubject = tapTextFieldSubject
        self.editingChangedSubject = editingChangedSubject
        self.deleteBackwardSubject = deleteBackwardSubject
    }
    
    var body: some View {
        AuthCodeTextFieldRepresentable(
            text: text,
            focusTag: focusTag,
            doneStringKey: "DONE",
            tableName: tableName,
            tag: tag,
            tapTextFieldSubject: tapTextFieldSubject,
            didBeginEditingSubject: viewModel.didBeginEditingSubject,
            didEndEditingSubject: viewModel.didEndEditingSubject,
            editingChangedSubject: editingChangedSubject,
            deleteBackwardSubject: deleteBackwardSubject
        )
        .background(textFieldBackground)
    }
    
    private var textFieldBackground: some View {
        Group {
            if viewModel.isFocused {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple.opacity(0.6), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple.opacity(0.1), lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
            }
        }
    }
}
