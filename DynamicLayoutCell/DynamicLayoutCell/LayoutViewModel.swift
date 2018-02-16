//
//  LayoutViewModel.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 21/10/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

@objc public protocol LayoutViewModel {
    /**
     *  Used to determine if model was created properly based on the rootItem
     *  passed in the initialized
     */
    var isValid: Bool { get }
    
    /// Root element of the model
    var rootElement: ContentElement { get }
    
    /// Used to prepare views inside the model for reusing in table view
    func reuse()
    
    /// Optional method used to apply isHidden while a specific element isEmpty 
    func hideEmptyElements()
    
    init(rootElement: ContentElement, bindings: [String:UIView])
}
