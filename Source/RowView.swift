import UIKit

////TODO - key value getting
//open class RowViewConfiguration {
//    public init(columnConfigurations: [ColumnConfiguration]) {
//        self.columnConfigurations = columnConfigurations
//    }
//    public var columnConfigurations: [ColumnConfiguration] = []
//    public static var base: RowViewConfiguration = {
//        let cc1 = ColumnConfiguration(width: 40, viewType: UIView.self)
//        let cc2 = ColumnConfiguration(width: 60, viewType: UIView.self)
//        return RowViewConfiguration(columnConfigurations: [cc1,cc2])
//    }()
//    
//    public var columnSpacing: CGFloat = 1
//    public var columnBackgroundColor: UIColor = .white
//}
//
//public struct ColumnConfiguration {
//    public let width: CGFloat
//    public let viewType: UIView.Type
//    public func getView() -> UIView {
//        return viewType.init()
//    }
//    
//}


public protocol ColumnConfiguration: Hashable {
    var width: CGFloat { get }
    var viewType: UIView.Type { get }
}
extension ColumnConfiguration {
    public func getView() -> UIView {
        return viewType.init()
    }
}

open class RowView: UIView {
    
    public struct Spacing {
        
        let left: CGFloat
        let right: CGFloat
        let top: CGFloat
        let bottom: CGFloat
        let between: CGFloat
        
        init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat, between: CGFloat) {
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
            self.between = between
        }
        init(vertical: CGFloat, horizontal: CGFloat, between: CGFloat) {
            self.left = horizontal
            self.right = horizontal
            self.top = vertical
            self.bottom = vertical
            self.between = between
        }
        init(all: CGFloat, between: CGFloat) {
            self.left = all
            self.right = all
            self.bottom = all
            self.top = all
            self.between = between
        }
        init(all: CGFloat) {
            self.left = all
            self.right = all
            self.bottom = all
            self.top = all
            self.between = all
        }
    }
    
    public var spacing = Spacing(all: 1)
    public var columnViews: [UIView] = []
    public var columnWidths: [CGFloat] = []
    
    required public init() { super.init(frame: CGRect.zero) }
    public override init(frame: CGRect) { super.init(frame: frame) }
    public required init?(coder aDecoder: NSCoder) {fatalError()}
    
    private func appendColumnView(_ columnView: UIView) {
        columnViews.append(columnView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(columnView)
    }
    
    private func setupColumns() {
        switch columnViews.count {
        case 0: fatalError("Why are you using this anyways?")
        case 1: setOneView()
        default: setMoreViews()
        }
    }
    
    private func setOneView() {
        columnViews.first!.frame = CGRect(x: spacing.left, y: spacing.top, width: frame.width - (spacing.left + spacing.right), height: frame.width - (spacing.top + spacing.bottom))
    }
    
    private func setMoreViews() {
        let height = frame.height - (spacing.top + spacing.bottom)
        
        let usableWidth = frame.width - (spacing.left + spacing.right + (CGFloat(columnViews.count) + spacing.between))
        
        let totalWidthValues = columnWidths.reduce(0,+)
        let adjustedColumnWidths = columnWidths.map { ($0 / totalWidthValues) * usableWidth }
        
        let first = columnViews.first!
        
        first.frame = CGRect(x: spacing.left, y: spacing.top, width: adjustedColumnWidths[0], height: height)
        
        for i in 1..<columnViews.count {
            let view = columnViews[i]
            let prev = columnViews[i-1]
            view.frame = CGRect(x: prev.frame.maxX + spacing.between, y: spacing.top, width: adjustedColumnWidths[i], height: height)
        }
    }
    
    open func prepareForReuse() {
    }
}

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
        columnWidths = columnConfigurations.map { $0.width }
    }
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    

}
