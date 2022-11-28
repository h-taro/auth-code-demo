//
//  HomeView.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init()
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: .zero) {
                    navigationLink
                    authCodeTextField
                }
                .padding(.horizontal)
            }
            .navigationTitle(Text("ホーム"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var navigationLink: some View {
        NavigationLink(
            destination: ResultView(authCode: $viewModel.authCode),
            isActive: $viewModel.isShowResultView
        ) {
            EmptyView()
        }
    }
    
    private var authCodeTextField: some View {
        HStack(alignment: .center, spacing: 16) {
            AuthCodeTextField(
                text: $viewModel.firstValue,
                focusTag: $viewModel.focusTag,
                tag: .zero,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
            
            AuthCodeTextField(
                text: $viewModel.secondValue,
                focusTag: $viewModel.focusTag,
                tag: 1,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
            
            AuthCodeTextField(
                text: $viewModel.thirdValue,
                focusTag: $viewModel.focusTag,
                tag: 2,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
            
            AuthCodeTextField(
                text: $viewModel.fourthValue,
                focusTag: $viewModel.focusTag,
                tag: 3,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
            
            AuthCodeTextField(
                text: $viewModel.fifthValue,
                focusTag: $viewModel.focusTag,
                tag: 4,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
            
            AuthCodeTextField(
                text: $viewModel.sixthValue,
                focusTag: $viewModel.focusTag,
                tag: 5,
                tapTextFieldSubject: viewModel.tapTextFieldSubject,
                editingChangedSubject: viewModel.editingChangedSubject,
                deleteBackwardSubject: viewModel.deleteBackwardSubject,
                redoSubject: viewModel.redoSubject
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
