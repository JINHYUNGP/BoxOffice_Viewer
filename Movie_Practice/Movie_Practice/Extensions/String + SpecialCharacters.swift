//
//  String + removingSpecialCharactersAndWhitespace.swift
//  Movie_Practice
//
//  Created by 박진형 on 2023/07/06.
//

import Foundation

extension String {
    func removeLeadingCommaSpace() -> String {
        var modifiedString = self
        let leadingCommaSpace = ", "
        
        if modifiedString.hasPrefix(leadingCommaSpace) {
            modifiedString.removeFirst(leadingCommaSpace.count)
        }
        return modifiedString
    }
}
