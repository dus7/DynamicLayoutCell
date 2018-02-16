//
//  ListLayout.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Śpiewak on 27/11/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

@objc public class ListLayout: BasicLayout {
    
    public struct Binding {
        static let primaryText = "primaryText"
        static let secondaryText = "secondaryText"
        static let valueText = "valueText"
        static let sortText = "sortText"
        static let topRowContainer = "topRowContainer"
        static let bottomRowContainer = "bottomRowContainer"
    }

    public let primaryText: LabelItem = LabelItem(binding: ListLayout.Binding.primaryText)
    public let secondaryText: LabelItem = LabelItem(binding: ListLayout.Binding.secondaryText)
    public let valueText: LabelItem = LabelItem(binding: ListLayout.Binding.valueText)
    public let sortText: LabelItem = LabelItem(binding: ListLayout.Binding.sortText)

    public let topRowContainer: ContainerItem = ContainerItem(direction: .horizontal, items: [], binding: ListLayout.Binding.topRowContainer)
    public let bottomRowContainer: ContainerItem = ContainerItem(direction: .horizontal, items: [], binding: ListLayout.Binding.bottomRowContainer)
    
    @objc override public init() {
        
        super.init()
        
        textAreaContainer.axis = .vertical
        
        primaryText.category = .primary
        primaryText.priority = .highest
        primaryText.margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        primaryText.horizontalAlignment = .fill
        
        valueText.isRequired = true
        valueText.category = .secondary
        valueText.idiom = .value
        valueText.horizontalAlignment = .fill
        valueText.onCreate = {(element) in
            guard let label = element.view as? UILabel else { return }
            label.textAlignment = .right
        }
        
        secondaryText.category = .secondary
        secondaryText.idiom = .value
        secondaryText.priority = .highest
        secondaryText.margins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 4)
        secondaryText.verticalAlignment = .bottom
        secondaryText.horizontalAlignment = .fill
        
        sortText.isRequired = true
        sortText.category = .supplementary
        sortText.margins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        sortText.verticalAlignment = .bottom
        sortText.horizontalAlignment = .fill
        sortText.onCreate = {(element) in
            guard let label = element.view as? UILabel else { return }
            label.textAlignment = .right
        }
        
        topRowContainer.items = [primaryText, valueText]
        topRowContainer.margins = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        topRowContainer.priority = .high
        topRowContainer.verticalAlignment = .center
        
        bottomRowContainer.items = [secondaryText, sortText]
        bottomRowContainer.isRequired = true
        
        textAreaContainer.items = [topRowContainer, bottomRowContainer]
    }
    
}

@objc public class ListModel : NSObject, LayoutViewModel {
    
    @objc public private(set) var leftIcon: UIImageView = UIImageView()
    @objc public private(set) var primaryLabel: UILabel = UILabel()
    @objc public private(set) var secondaryLabel: UILabel = UILabel()
    @objc public private(set) var valueLabel: UILabel = UILabel()
    @objc public private(set) var sortLabel: UILabel = UILabel()
    @objc public private(set) var rightIcon: UIImageView = UIImageView()
    @objc public private(set) var chevron: UIImageView = UIImageView()
    
    @objc public private(set) var topRow: UIStackView = UIStackView()
    @objc public private(set) var bottomRow: UIStackView = UIStackView()
    
    private(set) public var isValid: Bool = false
    
    public var rootElement: ContentElement { return generatedLayout.view }
    
    private var generatedLayout: ContentElement
    
    public func reuse() {
        (leftIcon as ContentElement).reuse()
        (primaryLabel as ContentElement).reuse()
        (secondaryLabel as ContentElement).reuse()
        (valueLabel as ContentElement).reuse()
        (sortLabel as ContentElement).reuse()
        (rightIcon as ContentElement).reuse()
    }
    
    public func hideEmptyElements() {
        let elements = [primaryLabel, secondaryLabel, valueLabel, sortLabel, rightIcon, topRow, bottomRow] as [UIView]
        
        elements.forEach { $0.isHidden = $0.isEmpty }
    }
    
    required public init(rootElement: ContentElement, bindings: [String:UIView]) {
        
        generatedLayout = rootElement
        
        if
            let leftIcon = bindings[ListLayout.Binding.leftIcon] as? UIImageView,
            let primaryLabel = bindings[ListLayout.Binding.primaryText] as? UILabel,
            let secondaryLabel = bindings[ListLayout.Binding.secondaryText] as? UILabel,
            let valueLabel = bindings[ListLayout.Binding.valueText] as? UILabel,
            let sortLabel = bindings[ListLayout.Binding.sortText] as? UILabel,
            let rightIcon = bindings[BasicLayout.Binding.rightIcon] as? UIImageView,
            let chevron = bindings[BasicLayout.Binding.chevron] as? UIImageView,
            let topRow = bindings[ListLayout.Binding.topRowContainer] as? UIStackView,
            let bottomRow = bindings[ListLayout.Binding.bottomRowContainer] as? UIStackView
        {
            self.leftIcon = leftIcon
            self.primaryLabel = primaryLabel
            self.secondaryLabel = secondaryLabel
            self.valueLabel = valueLabel
            self.sortLabel = sortLabel
            self.rightIcon = rightIcon
            self.chevron = chevron
            self.topRow = topRow
            self.bottomRow = bottomRow
            
            isValid = true
        }
    }
}
