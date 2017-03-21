import UIKit

open class ConfigurableRowView<Configuration: ColumnConfiguration>: RowView {
    
    open var columnConfigurations: [Configuration] {
        return []
    }
    public var store: [Configuration:UIView] = [:]
    required public init() {
        super.init()
        let pairs = columnConfigurations.map { ($0,$0.getView()) }
        
        pairs.forEach { pair in
            store[pair.0] = pair.1
        }
        
        columnViews = pairs.map { $0.1 }
        columnViews.forEach { addSubview($0) }
        columnWidths = columnConfigurations.map { $0.width }
    }
    required public init?(coder aDecoder: NSCoder) { fatalError() }
}
