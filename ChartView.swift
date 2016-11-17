import UIKit

open class ChartView: UIView {
    
    
    public var width: CGFloat { return frame.width }
    public var height: CGFloat { return frame.height }
    
    public var rowHeight: CGFloat { return chartViewDataSource.rowHeight }
    public var rowSpacing: CGFloat { return chartViewDataSource.rowSpacing }
    public var numberOfRows: Int { return chartViewDataSource.numberOfRows }
    
    public init() {
        super.init(frame: CGRect())
        let temp = heightAnchor.constraint(equalToConstant: 0)
        temp.priority = 1
        temp.isActive = true
    }
    
    public func register(_ rowViewType: RowView.Type, forResuseIdentifier reuseIdentifier: String) {
        rowView = (rowViewType, reuseIdentifier)
    }
    
    var rowView: (type: RowView.Type, identifier: String)?
    
    
    public var chartViewDataSource: ChartViewDataSource! {
        didSet {
            backgroundColor = chartViewDataSource.backgroundColor
        }
    }
    
    public func views(at index: Int) -> [UIView] {
        return rowViews.map { $0.columnViews[index] }
    }
    
    public var rowViews: [RowView] { get { return _rowViews } }
    fileprivate var _rowViews = [RowView]()
    
    func appendRowView(_ rowView: RowView) {
        addSubview(rowView)
        _rowViews.append(rowView)
        rowView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var currentRowCount = 0
    var currentColumnViewTypes = [UIView.Type]()
    
    var unusedRows = [RowView]()
    
    public func setup() {
   
        if numberOfRows != currentRowCount {
            unusedRows += _rowViews
            _rowViews = []
            
            subviews.forEach { $0.removeFromSuperview() }
            
            
            
            setupRows(type: rowView?.type ?? RowView.self)
        }
        
        for (index,rowView) in rowViews.enumerated() {
            configurationClosure?(index,rowView)
        }
        setNeedsUpdateConstraints()
    }
    
    func didPan(_ pgr: UIPanGestureRecognizer) {
        if pgr.state == .ended {
            UIView.animate(withDuration: 0.2) {
                pgr.view!.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        let translation = pgr.translation(in: pgr.view)
        let velocity = pgr.velocity(in: pgr.view)
        let start = pgr.location(in: pgr.view).x - translation.x
       
        guard start > (pgr.view!.frame.width / 2) else { return }
        guard translation.x < 0 else { return }
        let movement = abs(translation.x)
        
        if movement > (pgr.view!.frame.width / 3) {
            print("should die")
        } else {
            print("nope")
            pgr.view!.transform = CGAffineTransform(translationX: -movement, y: 0)
        }
    }
    
    func setupRows<RowViewType: RowView>(type: RowViewType.Type) {
        
        var constraints = [NSLayoutConstraint]()
        
        for rowNumber in 0..<numberOfRows {
            
            var rv: RowViewType
            
            if unusedRows.count > 0 {
                rv = unusedRows.removeLast() as! RowViewType
            } else {
                rv = type.init()
                let pgr = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
                rv.addGestureRecognizer(pgr)
                
                rv.setupColumns()
            }
            
            appendRowView(rv)
            
            constraints.append(rv.leftAnchor.constraint(equalTo: leftAnchor, constant: rowSpacing))
            constraints.append(rv.rightAnchor.constraint(equalTo: rightAnchor, constant: -rowSpacing))
            constraints.append(rv.heightAnchor.constraint(equalToConstant: rowHeight))
            
            let top = (rowNumber == 0) ? topAnchor : rowViews[rowNumber - 1].bottomAnchor
            constraints.append(rv.topAnchor.constraint(equalTo: top, constant: rowSpacing))
            
        }
        
        if let last = rowViews.last {
            let constraint = last.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -rowSpacing)
            constraint.priority = 500
            constraints.append(constraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
   
    public var configurationClosure: ((Int,RowView) -> ())?
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
