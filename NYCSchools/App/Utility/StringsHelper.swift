//
//  StringsHelper.swift
//  NYCSchools
//
//  Created by Cong Huynh on 2023-02-20.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(params: CVarArg...) -> String {
        return String(format: localized(), arguments: params)
    }
}
