import UIKit

open class ChartView: UIView {
    
    public var width: CGFloat { return frame.width }
    public var height: CGFloat { return frame.height }
    
    public var rowHeight: CGFloat = 0
    public var columnWidthPercentages: [CGFloat] = [100]
    
    public var numberOfRows = 0
    public var numberOfColumns: Int { return columnWidthPercentages.count }
    
    public var columnTypes: [UIView.Type]? = [UITextField.self]
    public var columnViews: [UIView]?
    
    public var columnSpacing: CGFloat = 0
    public var rowSpacing: CGFloat = 0
    
    public var columnBackgroundColor = UIColor.white
    public var rowBackgroundColor = UIColor.black
    
    public init() {
        super.init(frame: CGRect())
        let temp = heightAnchor.constraint(equalToConstant: 0)
        temp.priority = 1
        temp.isActive = true
    }
    
    public var chartViewDataSource: ChartViewDataSource {
        set { let cvds = newValue
            rowHeight = cvds.rowHeight
            columnWidthPercentages = cvds.columnWidthPercentages
            numberOfRows = cvds.numberOfRows
            columnSpacing = cvds.columnSpacing
            columnTypes = cvds.columnTypes
            columnViews = cvds.columnViews
            rowSpacing = cvds.rowSpacing
            columnBackgroundColor = cvds.columnBackgroundColor
            rowBackgroundColor = cvds.rowBackgroundColor
            backgroundColor = cvds.backgroundColor
            setup()
        }
        get {
            return ChartViewDataSource(rowHeight: rowHeight, numberOfRows: numberOfRows, columnWidthPercentages: columnWidthPercentages, columnTypes: columnTypes, columnViews: columnViews, columnSpacing: columnSpacing, rowSpacing: rowSpacing, columnBackgroundColor: columnBackgroundColor, rowBackgroundColor: rowBackgroundColor, backgroundColor: backgroundColor!)
            
        }
    
    }
    
    public var rowViews = [RowView]()
    
    public func setup() {

        var constraints = [NSLayoutConstraint]()
        
        for rowNumber in 0..<numberOfRows {
            let rv = RowView()
            rv.backgroundColor = rowBackgroundColor
            rowViews.append(rv)
            rv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(rv)
        
            constraints.append(rv.leftAnchor.constraint(equalTo: leftAnchor, constant: rowSpacing))
            constraints.append(rv.rightAnchor.constraint(equalTo: rightAnchor, constant: -rowSpacing))
            constraints.append(rv.heightAnchor.constraint(equalToConstant: rowHeight))
            let top = (rowNumber == 0) ? topAnchor : rowViews[rowNumber - 1].bottomAnchor
            constraints.append(rv.topAnchor.constraint(equalTo: top, constant: rowSpacing))
            print(width)
            
            for columnNumber in 0..<numberOfColumns {
                let type = columnTypes?[columnNumber]
                let cv = type?.init() ?? self.columnViews![columnNumber]
                cv.setContentCompressionResistancePriority(0, for: .horizontal)
                cv.backgroundColor = columnBackgroundColor
                rv.columnViews.append(cv)
                cv.translatesAutoresizingMaskIntoConstraints = false
                rv.addSubview(cv)
                
                constraints.append(cv.topAnchor.constraint(equalTo: rv.topAnchor, constant: columnSpacing))
                constraints.append(cv.bottomAnchor.constraint(equalTo: rv.bottomAnchor, constant: -columnSpacing))
                
                let left = columnNumber == 0 ? rv.leftAnchor : rv.columnViews[columnNumber - 1].rightAnchor
                constraints.append(cv.leftAnchor.constraint(equalTo: left, constant: columnSpacing))
            }
            if let last = rv.columnViews.last {
                let constraint = last.rightAnchor.constraint(equalTo: rv.rightAnchor, constant: -columnSpacing)
                constraint.priority = 500
                constraints.append(constraint)
            }
            
            for i in 1..<numberOfColumns {
                let first = rv.columnViews[i-1]
                let fwm = columnWidthPercentages[i-1]
                let second = rv.columnViews[i]
                let swm = columnWidthPercentages[i]
                constraints.append(first.widthAnchor.constraint(equalTo: second.widthAnchor, multiplier: fwm/swm))
            }
            
        }
        
        if let last = rowViews.last {
            let constraint = last.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -rowSpacing)
            constraint.priority = 500
            constraints.append(constraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
   
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
