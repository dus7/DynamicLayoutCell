//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import BaseUIKit

struct Item {
    var primaryText: String?
    var secondaryText: String?
    var glyph: BaseGlyph?
    var valueText: String?
    var captionText: String?
    var chevronPresent: Bool
    
    init(primaryText: String? = nil,
         secondaryText: String? = nil,
         glyph: BaseGlyph? = nil,
         valueText: String? = nil,
         captionText: String? = nil,
         chevronPresent: Bool = false) {
        
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.glyph = glyph
        self.valueText = valueText
        self.captionText = captionText
        self.chevronPresent = chevronPresent
    }
}

extension Item {
    
    static func itemsCatalog() -> [Item] {
        return [
            Item(glyph: .snail),
            Item(primaryText: "Primary text"),
            Item(primaryText: "Primary text", secondaryText: "Secondary text"),
            
            Item(primaryText: "Primary text", secondaryText: "Secondary text", glyph: .snail, valueText: "value", captionText: "caption", chevronPresent: true),
            
            Item(),
            
            Item(primaryText: "Very very very long primary text", secondaryText: "Deal na sto milijonów złotych", glyph: .leadsFill, valueText: "100 000 000 zł", captionText: "test test test test"),
            
            Item(primaryText: "John Smith", secondaryText: "CEO", glyph: .leadsFill, valueText: "$100", captionText: "test"),
            Item(primaryText: "Adam", secondaryText: "Banan", glyph: .contactsFill, valueText: "$100", captionText: "test"),
            Item(primaryText: "This is some text", secondaryText: "And a description lets make it a long text so it'll be multiline, let's make sure this text is really long... I believe it can go like this forever...", chevronPresent: true),
            Item(primaryText: "This is some text", secondaryText: "Second line \nFake third line after newline",glyph: .dealsFill, chevronPresent: false),
        ]
    }
}

class ViewController: UITableViewController {
    
    let items: [Item] = Item.itemsCatalog()
    
    lazy var layout: BaseCellListLayout = {
        let layout = BaseCellListLayout()
        layout.leftIcon.minWidth = 48
        layout.leftIcon.verticalAlignment = .center
        layout.leftIcon.horizontalAlignment = .left
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    tableView?.register(BaseCell<BaseCellListModel>.self, forCellReuseIdentifier: "ListCell")
        tableView?.dataSource = self
        tableView?.delegate = self
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        if let baseCell = cell as? BaseCell<BaseCellListModel>,
            (try? baseCell.setLayoutDefinition(layout)) != nil {
            
            let item = items[indexPath.row]
            
            let leftImage: UIImage?
            
            if let glyph = item.glyph {
                leftImage = UIImage(glyph: glyph,
                                    imageSize: CGSize(width: 32, height: 32),
                                    color: UIColor.baseBackgroundGray())
            } else {
                leftImage = nil
            }
            
            baseCell.model.leftIcon.image = leftImage
            baseCell.model.primaryLabel.text = item.primaryText
            baseCell.model.secondaryLabel.text = item.secondaryText
            baseCell.model.valueLabel.text = item.valueText
            baseCell.model.sortLabel.text = item.captionText
            
            baseCell.model.chevron.isHidden = !item.chevronPresent            
        } else {
            assertionFailure("Something went wrong")
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
