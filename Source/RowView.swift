import UIKit

//TODO - key value getting
open class RowViewConfiguration {
    init(columnConfigurations: [ColumnConfiguration]) {
        self.columnConfigurations = columnConfigurations
    }
    var columnConfigurations: [ColumnConfiguration] = []
    static var base: RowViewConfiguration = {
        let cc1 = ColumnConfiguration(width: 40, viewType: UIView.self)
        let cc2 = ColumnConfiguration(width: 60, viewType: UIView.self)
        return RowViewConfiguration(columnConfigurations: [cc1,cc2])
    }()
    
    var columnSpacing: CGFloat = 1
    var columnBackgroundColor: UIColor = .white
}

public struct ColumnConfiguration {
    let width: CGFloat
    let viewType: UIView.Type
    func getView() -> UIView {
        return viewType.init()
    }
}

open class RowView<Configuration: RowViewConfiguration>: UIView {
    
    var configuration: Configuration = Configuration.base as! Configuration
    private var columnConfigurations: [ColumnConfiguration] { return configuration.columnConfigurations }
    
    private var columnWidths: [CGFloat] { return columnConfigurations.map { $0.width } }
    private var columnViewTypes: [UIView.Type] { return columnConfigurations.map { $0.viewType } }
    public private(set) var columnViews: [UIView]!
    
    required public init() {
        super.init(frame: CGRect.zero)
        columnViews = columnConfigurations.map { $0.getView() }
    }
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    
    private func appendColumnView(_ columnView: UIView) {
        columnViews.append(columnView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(columnView)
    }
    
    open func getColumnView(columnNumber: Int) -> UIView {
        return columnViewTypes[columnNumber].init()
    }
    
    private func setupColumns() {
        switch columnViews.count {
        case 0: fatalError("Why are you using this anyways?")
        case 1: setOneView()
        default: setMoreViews()
        }
    }
    
    private func setOneView() {
        let spacing = configuration.columnSpacing
        columnViews.first!.frame = CGRect(x: spacing, y: spacing, width: frame.width - spacing * 2, height: frame.width - spacing * 2)
    }
    
    private func setMoreViews() {
        let spacing = configuration.columnSpacing
        let height = frame.height - spacing * 2
        
        let totalWidthValues = columnWidths.reduce(0,+)
        let adjustedColumnWidths = columnWidths.map { $0 / totalWidthValues }
        
        let first = columnViews.first!
        
        first.frame = CGRect(x: spacing, y: spacing, width: adjustedColumnWidths[0], height: height)
        
        for i in 1..<columnViews.count {
            let view = columnViews[i]
            let prev = columnViews[i-1]
            view.frame = CGRect(x: prev.frame.maxX + spacing, y: spacing, width: adjustedColumnWidths[i], height: height)
        }
    }
    
    open func prepareForReuse() {
    }
}
