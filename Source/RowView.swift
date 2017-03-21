import UIKit

open class RowView: UIView {
    required public init() {
        super.init(frame: CGRect.zero)
    }
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    open func prepareForReuse() {
    }
    
    public var columnViews: [UIView] = []
    open var columnViewTypes: [UIView.Type] = [UILabel.self, UILabel.self]
    open var columnWidths: [CGFloat] = [50,50]
    
    public var numberOfColumns: Int { return columnViewTypes.count }
    public var columnBackgroundColor: UIColor = .white
    public var columnSpacing: CGFloat = 1
    
    public func appendColumnView(_ columnView: UIView) {
        columnViews.append(columnView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(columnView)
    }
    
    open func getColumnView(columnNumber: Int) -> UIView {
        return columnViewTypes[columnNumber].init()
    }
    
    open func setupColumns() {
        
        for columnNumber in 0..<numberOfColumns {
            let cv = getColumnView(columnNumber: columnNumber)
            
            appendColumnView(cv)
            
            cv.backgroundColor = columnBackgroundColor
        }
    }
    
    func layout() {
    
        switch columnViews.count {
        case 0: fatalError("Why are you using this anyways?")
        case 1: setOneView()
        default: setMoreViews()
        }
    }
    private func setOneView() {
        columnViews.first!.frame = CGRect(x: spacing.left, y: spacing.top, width: frame.width - (spacing.left + spacing.right), height: frame.height - (spacing.top + spacing.bottom))
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    
        layout()
    }
}
