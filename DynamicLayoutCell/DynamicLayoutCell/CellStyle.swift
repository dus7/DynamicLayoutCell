//
//  CellStyle.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 21/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

@objc public protocol LayoutItemStyleDefinition {
    
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var supplementaryColor: UIColor { get }
    var interactiveColor: UIColor { get }
    var destructiveColor: UIColor { get }
    
    var primaryFont: UIFont { get }
    var secondaryFont: UIFont { get }
    var supplementaryFont: UIFont { get }
    
    func style(for category: LayoutItemCategory, idiom: LayoutItemIdiom) -> DynamicCellStyle
}

@objc public class DynamicCellStyle: NSObject {
    let font: UIFont
    let foregroundColor: UIColor
    
    init(font: UIFont, foregroundColor: UIColor) {
        self.font = font
        self.foregroundColor = foregroundColor
    }
}

public class DefaultStyleDefinition: LayoutItemStyleDefinition {
    
    public var primaryColor: UIColor = .darkGray
    public var secondaryColor: UIColor = .gray
    public var supplementaryColor: UIColor = .black

    public var interactiveColor: UIColor = .green
    public var destructiveColor: UIColor = .red
    
    public var primaryFont: UIFont = DefaultStyleDefinition.bodyFont
    public var secondaryFont: UIFont = DefaultStyleDefinition.subheadlineFont
    public var supplementaryFont: UIFont = DefaultStyleDefinition.footnoteFont
    
    static let bodyFont = UIFont.preferredFont(forTextStyle: .body)
    static let subheadlineFont = UIFont.preferredFont(forTextStyle: .subheadline)
    static let footnoteFont = UIFont.preferredFont(forTextStyle: .footnote)
    static let title1Font = UIFont.preferredFont(forTextStyle: .title1)
    
    public func style(for category: LayoutItemCategory, idiom: LayoutItemIdiom) -> DynamicCellStyle {
        var font: UIFont
        var color: UIColor
        
        switch category {
        case .plain:
            font = primaryFont
        case .primary:
            font = primaryFont
        case .secondary:
            font = secondaryFont
        case .supplementary:
            font = secondaryFont
        }
        
        switch idiom {
        case .actionable:
            color = interactiveColor
        case .plain:
            color = primaryColor
        case .destructive:
            color = destructiveColor
        case .value:
            color = secondaryColor
        case .input:
            color = secondaryColor
        }
        
        return DynamicCellStyle(font: font, foregroundColor: color)
    }
}
