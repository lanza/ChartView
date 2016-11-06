import UIKit

public struct ChartViewDataSource {
    
    public var rowHeight: CGFloat
    
    public var numberOfRows: Int
    public var columnWidthPercentages: [CGFloat]
    
    public var columnTypes: [UIView.Type]?
    public var columnViews: [UIView]?
    
    public var columnSpacing: CGFloat
    public var rowSpacing: CGFloat
    
    public var columnBackgroundColor: UIColor
    public var rowBackgroundColor: UIColor
    public var backgroundColor: UIColor
    
    public init(rowHeight: CGFloat, numberOfRows: Int, columnWidthPercentages: [CGFloat], columnTypes: [UIView.Type]?, columnViews: [UIView]?, columnSpacing: CGFloat, rowSpacing: CGFloat, columnBackgroundColor: UIColor, rowBackgroundColor: UIColor, backgroundColor: UIColor) {
        self.rowHeight = rowHeight
        self.numberOfRows = numberOfRows
        self.columnWidthPercentages = columnWidthPercentages
        self.columnTypes = columnTypes
        self.columnViews = columnViews
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.columnBackgroundColor = columnBackgroundColor
        self.rowBackgroundColor = rowBackgroundColor
        self.backgroundColor = backgroundColor
    }
}
