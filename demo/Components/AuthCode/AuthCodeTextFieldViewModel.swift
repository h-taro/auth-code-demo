//
//  AuthCodeTextFieldViewModel.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import Combine
import SwiftUI

class AuthCodeTextFieldViewModel: ObservableObject {
    @Published private(set) var isFocused = false
    
    private(set) var didBeginEditingSubject: PassthroughSubject<Void, Never> = .init()
    private(set) var didEndEditingSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        subscribeDidBeginEditing()
        subscribeDidEndEditing()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - PRIVATE METHODS
extension AuthCodeTextFieldViewModel {
    private func subscribeDidBeginEditing() {
        didBeginEditingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isFocused = true
            }
            .store(in: &cancellables)
    }
    
    private func subscribeDidEndEditing() {
        didEndEditingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isFocused = false
            }
            .store(in: &cancellables)
    }
}
