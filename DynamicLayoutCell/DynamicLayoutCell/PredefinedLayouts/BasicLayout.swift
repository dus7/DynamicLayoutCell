//
//  BasicLayout.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Śpiewak on 27/11/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

@objc open class BasicLayout: ContainerItem, LayoutDefinition {
    
    public struct Binding {
        static let leftIcon = "leftIcon"
        static let rightIcon = "rightIcon"
        static let chevron = "chevron"
    }
    
    public let leftIcon: ImageItem = ImageItem(binding: Binding.leftIcon)
    public let textAreaContainer: ContainerItem = ContainerItem.horizontal([])
    public let rightIcon: ImageItem = ImageItem(binding: Binding.rightIcon)
    public let chevron: ChevronItem = ChevronItem(binding: Binding.chevron)
    
    @objc public init() {
        
        super.init(direction: .horizontal, items: [], binding: nil)
        
        leftIcon.priority = .low
        leftIcon.isRequired = true
        leftIcon.margins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 6)
        
        textAreaContainer.isRequired = true
        textAreaContainer.priority = .primary

        rightIcon.priority = .lowest
        rightIcon.isRequired = true
        rightIcon.verticalAlignment = .center
        rightIcon.horizontalAlignment = .center
        rightIcon.margins = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
        
        chevron.isRequired = true
        chevron.priority = .normal
        chevron.margins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        
        items = [leftIcon, textAreaContainer, rightIcon, chevron]
    }
    
    public var rootContentItem: LayoutItem { return self }
}
