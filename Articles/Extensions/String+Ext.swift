//
//  String+Ext.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import UIKit

extension String {
    func style(font: UIFont = .systemFont(ofSize: 14),
               color: UIColor = .label,
               weight: UIFont.Weight = .regular) -> NSAttributedString {
        
        let finalFont = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        
        return NSAttributedString(string: self, attributes: [
            .font: finalFont,
            .foregroundColor: color
        ])
    }
}
