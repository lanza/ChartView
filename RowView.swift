import UIKit

open class RowView: UIView {
   
    required public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    public var columnViews = [UIView]()
    open var columnViewTypes: [UIView.Type] = [UILabel.self, UILabel.self]
    open var columnWidthPercentages: [CGFloat] = [50,50]
    
    public var numberOfColumns: Int { return columnViewTypes.count }
    public var columnBackgroundColor = UIColor.white
    public var columnSpacing: CGFloat = 2
    
    public func appendColumnView(_ columnView: UIView) {
        columnViews.append(columnView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(columnView)
    }
    
    open func setupColumns() {
        
        var constraints = [NSLayoutConstraint]()
        
        for columnNumber in 0..<numberOfColumns {
            let cv = columnViewTypes[columnNumber].init()
            
            appendColumnView(cv)
            
            cv.backgroundColor = columnBackgroundColor
            
            cv.setContentCompressionResistancePriority(0, for: .horizontal)
            constraints.append(cv.topAnchor.constraint(equalTo: topAnchor, constant: columnSpacing))
            constraints.append(cv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -columnSpacing))
            
            let left = columnNumber == 0 ? leftAnchor : columnViews[columnNumber - 1].rightAnchor
            constraints.append(cv.leftAnchor.constraint(equalTo: left, constant: columnSpacing))
        }
        if let last = columnViews.last {
            let constraint = last.rightAnchor.constraint(equalTo: rightAnchor, constant: -columnSpacing)
            constraint.priority = 500
            constraints.append(constraint)
        }
        
        for i in 1..<numberOfColumns {
            let first = columnViews[i-1]
            let fwm = columnWidthPercentages[i-1]
            let second = columnViews[i]
            let swm = columnWidthPercentages[i]
            constraints.append(first.widthAnchor.constraint(equalTo: second.widthAnchor, multiplier: fwm/swm))
        }
        NSLayoutConstraint.activate(constraints)
    }
}
