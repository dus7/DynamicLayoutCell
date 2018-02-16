//
//  TwoLineModel.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 21/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

@objc public class TwoLineLayout: ContainerItem, LayoutDefinition {
    
    public struct Binding {
        static let leftIcon = "leftIcon"
        static let rightCustomItem = "rightCustom"
        static let primaryText = "primaryText"
        static let bottomLeftText = "bottomLeftText"
        static let bottomRightText = "bottomRightText"
        static let value = "value"
        static let chevron = "chevron"
    }
    
    public let leftIcon: ImageItem = ImageItem(binding: Binding.leftIcon)
    public let rightCustomItem: CustomItem = CustomItem(binding: Binding.rightCustomItem)
    public let chevron: ChevronItem = ChevronItem(binding: Binding.chevron)
    public let primaryText: LabelItem = LabelItem(binding: Binding.primaryText)
    public let bottomLeftText: MultilineLabelItem = MultilineLabelItem(binding: Binding.bottomLeftText)
    public let bottomRightText: LabelItem = LabelItem(binding: Binding.bottomRightText)
    public let valueText: LabelItem = LabelItem(binding: Binding.value)
    public let leftTextColumnContainer: ContainerItem = ContainerItem.vertical([])
    public let rightTextColumnContainer: ContainerItem = ContainerItem.vertical([])
    public let textAreaContainer: ContainerItem = ContainerItem.horizontal([])
    
    @objc public convenience init() {
        
        self.init(direction: .horizontal)
        
        leftIcon.priority = .low
        leftIcon.margins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 6)
        
        rightCustomItem.priority = .lower
        rightCustomItem.isRequired = true
        
        primaryText.isRequired = true
        primaryText.priority = .highest
        primaryText.category = .primary
        primaryText.verticalAlignment = .top
        
        bottomLeftText.category = .secondary
        bottomLeftText.priority = .high
        bottomLeftText.margins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        bottomLeftText.verticalAlignment = .bottom
        
        bottomRightText.isRequired = true
        bottomRightText.category = .supplementary
        bottomRightText.margins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        bottomRightText.verticalAlignment = .bottom
        bottomRightText.priority = .high
        bottomRightText.onCreate = {(element) in
            guard let label = element.view as? UILabel else { return }
            label.textAlignment = .right
        }
        
        valueText.category = .primary
        valueText.idiom = .input
        valueText.verticalAlignment = .fill
        valueText.isRequired = true
        valueText.onCreate = {(element) in
            guard let label = element.view as? UILabel else { return }
            label.textAlignment = .right
        }
        
        leftTextColumnContainer.items = [primaryText, bottomLeftText]
        leftTextColumnContainer.isRequired = true
        leftTextColumnContainer.margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        
        rightTextColumnContainer.items = [valueText, bottomRightText]
        rightTextColumnContainer.isRequired = true
        rightTextColumnContainer.priority = .high
        
        textAreaContainer.items = [leftTextColumnContainer, rightTextColumnContainer]
        textAreaContainer.margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        textAreaContainer.isRequired = true
        textAreaContainer.priority = .primary
        
        items = [leftIcon, textAreaContainer, rightCustomItem, chevron]
    }
    
    public var rootContentItem: LayoutItem { return self }
}

@objc public class TwoLineModel: NSObject, LayoutViewModel {
    
    @objc public private(set) var leftIcon: UIImageView = UIImageView()
    @objc public private(set) var rightCustomView: UIView = UIView()
    @objc public private(set) var primaryLabel: UILabel = UILabel()
    @objc public private(set) var valueLabel: UILabel = UILabel()
    @objc public private(set) var bottomRightLabel: UILabel = UILabel()
    @objc public private(set) var bottomLeftLabel: UILabel = UILabel()
    @objc public private(set) var chevron: UIImageView = UIImageView()
    
    private(set) public var isValid: Bool = false
    
    public var rootElement: ContentElement { return generatedLayout.view }
    
    private var generatedLayout: ContentElement
    
    public func reuse() {
        (leftIcon as ContentElement).reuse()
        (rightCustomView as ContentElement).reuse()
        (primaryLabel as ContentElement).reuse()
        (valueLabel as ContentElement).reuse()
        (bottomLeftLabel as ContentElement).reuse()
        (bottomRightLabel as ContentElement).reuse()
    }
    
    public func hideEmptyElements() {
        [leftIcon, rightCustomView, primaryLabel, valueLabel, bottomLeftLabel, bottomLeftLabel].forEach { $0.isHidden = $0.isEmpty }
    }
    
    required public init(rootElement: ContentElement, bindings: [String:UIView]) {
        
        generatedLayout = rootElement
        
        if
            let leftIcon = bindings[TwoLineLayout.Binding.leftIcon] as? UIImageView,
            let primaryLabel = bindings[TwoLineLayout.Binding.primaryText] as? UILabel,
            let valueLabel = bindings[TwoLineLayout.Binding.value] as? UILabel,
            let bottomRightLabel = bindings[TwoLineLayout.Binding.bottomRightText] as? UILabel,
            let bottomLeftLabel = bindings[TwoLineLayout.Binding.bottomLeftText] as? UILabel,
            let rightCustomView = bindings[TwoLineLayout.Binding.rightCustomItem],
            let chevron = bindings[TwoLineLayout.Binding.chevron] as? UIImageView
        {
            self.leftIcon = leftIcon
            self.primaryLabel = primaryLabel
            self.valueLabel = valueLabel
            self.bottomRightLabel = bottomRightLabel
            self.bottomLeftLabel = bottomLeftLabel
            self.rightCustomView = rightCustomView
            self.chevron = chevron
            
            isValid = true
        }
    }
}
