//
//  String+.swift
//  demo
//
//  Created by 平石　太郎 on 2022/11/27.
//

import Foundation

extension String {
    func isBackSpace() -> Bool {
        guard let char = self.cString(using: .utf8) else { return false }
        return strcmp(char, "\\b") == -92
    }
}
