//
//  HomeViewModel.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import THLogger
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var firstValue: String = ""
    @Published var secondValue: String = ""
    @Published var thirdValue: String = ""
    @Published var fourthValue: String = ""
    @Published var fifthValue: String = ""
    @Published var sixthValue: String = ""
    @Published var focusTag: Int? = nil
    @Published var isShowResultView = false
    @Published var authCode: String = ""
    
    private(set) var tapTextFieldSubject: PassthroughSubject<Int, Never> = .init()
    private(set) var editingChangedSubject: PassthroughSubject<String, Never> = .init()
    private(set) var deleteBackwardSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeTapTextField()
        subscribeEditingChanged()
        subscribeCompleteCode()
        subscribeDeleteBackward()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    private func showResultView() {
        isShowResultView = true
    }
    
    private func getAuthCode() -> String {
        [
            firstValue, secondValue, thirdValue, fourthValue, fifthValue, sixthValue
        ].joined()
    }
    
    private func subscribeCompleteCode() {
        let checkFirst = generateCodePublisher($firstValue)
        let checkSecond = generateCodePublisher($secondValue)
        let checkThird = generateCodePublisher($thirdValue)
        let checkFourth = generateCodePublisher($fourthValue)
        let checkFifth = generateCodePublisher($fifthValue)
        let checkSixth = generateCodePublisher($sixthValue)
        
        let checkFirstHalf = generateHalfCheckPublisher(
            first: checkFirst,
            second: checkSecond,
            third: checkThird
        )
        let checkSecondHalf = generateHalfCheckPublisher(
            first: checkFourth,
            second: checkFifth,
            third: checkSixth
        )
        
        let codeChecker: AnyPublisher<Bool, Never> = checkFirstHalf
            .combineLatest(checkSecondHalf)
            .map { first, second in
                first && second
            }
            .eraseToAnyPublisher()
        
        codeChecker
            .receive(on: DispatchQueue.main)
            .sink { [weak self] valid in
                guard let self = self else { return }
                
                if valid {
                    self.authCode = self.getAuthCode()
                    self.showResultView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func generateCodePublisher(
        _ code: Published<String>.Publisher
    ) -> AnyPublisher<Bool, Never> {
        code.map { !$0.isEmpty }.eraseToAnyPublisher()
    }
    
    private func generateHalfCheckPublisher(
        first: AnyPublisher<Bool, Never>,
        second: AnyPublisher<Bool, Never>,
        third: AnyPublisher<Bool, Never>
    ) -> AnyPublisher<Bool, Never> {
        first
            .combineLatest(second, third)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
}

// MARK: - SUBSCRIBE
extension HomeViewModel {
    private func subscribeTapTextField() {
        tapTextFieldSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tag in
                guard let self = self else { return }
                self.focusTag = tag
            }
            .store(in: &cancellables)
    }
    
    private func subscribeEditingChanged() {
        editingChangedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.focusTag == .zero {
                    self.focusTag = 1
                } else if self.focusTag == 1 {
                    self.focusTag = 2
                } else if self.focusTag == 2 {
                    self.focusTag = 3
                } else if self.focusTag == 3 {
                    self.focusTag = 4
                } else if self.focusTag == 4 {
                    self.focusTag = 5
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeDeleteBackward() {
        deleteBackwardSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.focusTag == 5 {
                    self.focusTag = 4
                } else if self.focusTag == 4 {
                    self.focusTag = 3
                } else if self.focusTag == 3 {
                    self.focusTag = 2
                } else if self.focusTag == 2 {
                    self.focusTag = 1
                } else if self.focusTag == 1 {
                    self.focusTag = .zero
                }
            }
            .store(in: &cancellables)
    }
}
