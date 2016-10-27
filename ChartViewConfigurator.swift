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
}
