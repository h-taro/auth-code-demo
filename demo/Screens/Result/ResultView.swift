//
//  ResultView.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/26.
//

import SwiftUI

struct ResultView: View {
    @Binding private var authCode: String
    
    init(authCode: Binding<String>) {
        self._authCode = authCode
    }

    var body: some View {
        Text(authCode)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
    }
}
