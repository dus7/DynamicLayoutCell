//
//  DynamicLayoutCell.swift
//  DynamicLayoutCell
//
//  Created by Mariusz Spiewak on 17/09/2017.
//  Copyright © 2017 Mariusz Śpiewak. All rights reserved.
//

import UIKit

public enum DynamicLayoutCellError: Error {
    case modelNotInitialized
}

open class DynamicLayoutCell<ModelType: LayoutViewModel> : UITableViewCell, GenericLayoutViewAPI {
    
    /**
     *  An object defining the layout and style of the cell.
     *  Can be reused across the cells which are the same.
     */
    public private(set) var layoutDefinition: LayoutDefinition = DummyLayoutDefinition()
    
    /**
     *  A proxy object used to access the views created using `layoutDefinition`.
     */
    public private(set) var model: ModelType = {
        var bindings : [String : UIView] = [:]
        let rootElement = LayoutItem().create(&bindings)
        return ModelType.init(rootElement: rootElement, bindings: bindings)
    }()
    
    // MARK: - Overrides
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        model.reuse()
    }
    
    // MARK: - Public
    
    /**
     *  Applies layout to cell
     *
     *  You can (and should) use this inside each call of `cellForRow` metod.
     *  Setting a definition that differs from current one invokes initialization of
     *  a model which type is defined by the cell generic type.
     *
     *  - attention: For performance reasons it's recommended to separate cell pools with
     *  different layouts using different reuseIdentifiers.
     *  Model is rebuilt upon setting different layout.
     *  
     *  - parameter definition: layout definition based on which the model will be created
     *
     *  - Throws: DynamicLayoutCellError when the model could not been created
     *
     */
    public func setLayoutDefinition(_ definition: LayoutDefinition) throws {
        if definition !== layoutDefinition {
            var bindings : [String : UIView] = [:]
            let rootElement = definition.rootContentItem.create(&bindings)
            let model = ModelType.init(rootElement: rootElement, bindings: bindings)
            
            guard model.isValid else { throw DynamicLayoutCellError.modelNotInitialized }
            
            clearLayout()
            layoutDefinition = definition
            self.model = model
            createLayout()
        }
    }
    
    // MARK: - Private
    
    private func createLayout() {

        clearLayout()
        
        let rootView = model.rootElement.view
        rootView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rootView)

        contentView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[mainView]-|",
                                           options: [],
                                           metrics: nil,
                                           views: ["mainView" : rootView]))
        contentView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[mainView]-|",
                                           options: [],
                                           metrics: nil,
                                           views: ["mainView" : rootView]))
    }
    
    private func clearLayout() {
        model.rootElement.view.removeFromSuperview()
    }
    
    // MARK: - Added only for OBJC bridging in GenericLayoutView
    
    public var cellModel: LayoutViewModel { return model as LayoutViewModel }
    public var rootView: UIView { return model.rootElement.view }
}

internal class DummyLayoutDefinition: LayoutItem, LayoutDefinition {
    var rootContentItem: LayoutItem { return self }
}
