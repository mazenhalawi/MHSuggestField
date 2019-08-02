//
//  SuggestFieldDelegate.swift
//  SuggestField
//
//  Created by Mazen on 07/25/2019.
//  Copyright © 2019 Mazen. All rights reserved.
//

import Foundation

public protocol SuggestFieldDelegate : class {
    func alertNotInList(value: String)
    func suggestFieldDidBeginEditing(_ suggestField: SuggestField)
    func suggestFieldDidEndEditing(_ suggestField: SuggestField)
}
