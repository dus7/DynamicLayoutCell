import UIKit
import DynamicLayoutCell

struct Item {
    var primaryText: String?
    var secondaryText: String?
    var image: UIImage?
    var valueText: String?
    var captionText: String?
    var chevronPresent: Bool
    
    init(primaryText: String? = nil,
         secondaryText: String? = nil,
         image: UIImage? = nil,
         valueText: String? = nil,
         captionText: String? = nil,
         chevronPresent: Bool = false) {
        
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.image = image
        self.valueText = valueText
        self.captionText = captionText
        self.chevronPresent = chevronPresent
    }
}

extension Item {
    
    static func itemsCatalog() -> [Item] {
        return [
            Item(image: UIImage(named: "alert")),
            Item(primaryText: "Primary text"),
            Item(primaryText: "Primary text", secondaryText: "Secondary text"),
            
            Item(primaryText: "Primary text", secondaryText: "Secondary text", image: UIImage(named: "alert"), valueText: "value", captionText: "caption", chevronPresent: true),
            
            Item(),
            
            Item(primaryText: "Very very very long primary text", secondaryText: "Deal na sto milijonów złotych", image: UIImage(named: "awesome"), valueText: "100 000 000 zł", captionText: "test test test test"),
            
            Item(primaryText: "John Smith", secondaryText: "CEO", image: UIImage(named: "awesome"), valueText: "$100", captionText: "test"),
            Item(primaryText: "Adam", secondaryText: "Banan", image: UIImage(named: "awesome"), valueText: "$100", captionText: "test"),
            Item(primaryText: "This is some text", secondaryText: "And a description lets make it a long text so it'll be multiline, let's make sure this text is really long... I believe it can go like this forever...", chevronPresent: true),
            Item(primaryText: "This is some text", secondaryText: "Second line \nFake third line after newline", image: UIImage(named: "awesome"), chevronPresent: false),
        ]
    }
}

class ViewController: UITableViewController {
    
    let items: [Item] = Item.itemsCatalog()
    
    lazy var layout: ListLayout = {
        let layout = ListLayout()
        layout.leftIcon.minWidth = 48
        layout.leftIcon.verticalAlignment = .center
        layout.leftIcon.horizontalAlignment = .left
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(DynamicLayoutCell<ListModel>.self, forCellReuseIdentifier: "ListCell")
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        if let dynamicCell = cell as? DynamicLayoutCell<ListModel>,
            (try? dynamicCell.setLayoutDefinition(layout)) != nil {
            
            let item = items[indexPath.row]
            
            let leftImage: UIImage?
            
            if let image = item.image {
                leftImage = image
            } else {
                leftImage = nil
            }
            
            dynamicCell.model.leftIcon.image = leftImage
            dynamicCell.model.primaryLabel.text = item.primaryText
            dynamicCell.model.secondaryLabel.text = item.secondaryText
            dynamicCell.model.valueLabel.text = item.valueText
            dynamicCell.model.sortLabel.text = item.captionText
            
            dynamicCell.model.chevron.isHidden = !item.chevronPresent
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

