import UIKit

open class ChartView: UIView {
    public enum EditingStyle {
        case delete
    }

    public init() {
        super.init(frame: CGRect())
        let temp = heightAnchor.constraint(equalToConstant: 0)
        temp.priority = 1
        temp.isActive = true
    }

    //MARK: - Delegation
    public weak var delegate: ChartViewDelegate?
    public weak var dataSource: ChartViewDataSource! {
        didSet {
            setup()
        }
    }

    //MARK: - DataSource
    public var rowHeight: CGFloat {
        return delegate?.rowHeight(for: self) ?? 30
    }
    public var rowSpacing: CGFloat {
        return delegate?.rowSpacing(for: self) ?? 1
    } 
    public var numberOfRows: Int {
        return dataSource.numberOfRows(in: self)
    }

    //MARK: - RowView type registration
    public func registerForReuse(_ rowViewType: RowView.Type) {
        self.rowViewType = rowViewType

    }
    var rowViewType: RowView.Type = RowView.self

    //MARK: - RowViews
    public var rowViews: [RowView] { get { return _rowViews } }

    fileprivate var _rowViews = [RowView]()

    func appendRowView(_ rowView: RowView) {
        addSubview(rowView)
        _rowViews.append(rowView)
        rowView.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - Reuse Tracking
    var currentRowCount = 0
    var unusedRows = [RowView]()

    //MARK: - Setup

    public func setup() {

        unusedRows += _rowViews
        _rowViews = []

        subviews.forEach { $0.removeFromSuperview() }
        setupRows()
        currentRowCount = numberOfRows

        setNeedsUpdateConstraints()

        checkAndAddEmpty()
    }

    fileprivate var emptyBottomConstraint: NSLayoutConstraint?
    fileprivate func checkAndAddEmpty() {
        if numberOfRows == 0, let text = emptyText {
            if emptyBottomConstraint == nil {
                emptyBottomConstraint = topAnchor.constraint(equalTo: bottomAnchor, constant: -emptyHeight)
                emptyBottomConstraint?.priority = 50
                emptyBottomConstraint?.isActive = true
            }
            constrainEmptyLabel()
            emptyLabel.text = text
        } else {
            if subviews.contains(emptyLabel) {
                emptyLabel.removeFromSuperview()
                removeConstraint(emptyBottomConstraint!)
                emptyBottomConstraint = nil
            }
        }
    }
   
    public var emptyText: String? = "Hi muffin"
    lazy public var emptyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.minimumScaleFactor = 0.4
        l.textAlignment = .center
        return l
    }()
    private func constrainEmptyLabel() {
        addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: self.topAnchor),
            emptyLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            emptyLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    public var emptyHeight: CGFloat = 30
    
    public func dequeueRowView() -> RowView {
        if unusedRows.count > 0 {
            
            let reuseRowView = unusedRows.removeLast()
            reuseRowView.prepareForReuse()
            return reuseRowView
            
        } else {
            
            let rv = rowViewType.init()
            let pgr = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
            rv.addGestureRecognizer(pgr)
            
            return rv
        }
    }
    func setupRows() {
        constraintHolders = []
        for rowNumber in 0..<numberOfRows {
            
            let rv = dataSource.chartView(self, cellForRowAtIndex: rowNumber)
            appendRowView(rv)
            
            let ch = ConstraintHolder()
            
            ch.rowView = rv
            ch.left = rv.leftAnchor.constraint(equalTo: leftAnchor, constant: rowSpacing)
            ch.right = rv.rightAnchor.constraint(equalTo: rightAnchor, constant: -rowSpacing)
            ch.height = rv.heightAnchor.constraint(equalToConstant: rowHeight)
            
            let top = (rowNumber == 0) ? topAnchor : rowViews[rowNumber - 1].bottomAnchor
            ch.top = rv.topAnchor.constraint(equalTo: top, constant: rowSpacing)
            constraintHolders.append(ch)
        }
        
        if let bc = bottomConstraint {
            bc.isActive = false
            bottomConstraint = nil
        }
        if let last = rowViews.last {
            
            bottomConstraint = last.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -rowSpacing)
            bottomConstraint.priority = 500
        }
        NSLayoutConstraint.activate(constraintHolders.flatMap { $0.all } + [bottomConstraint].flatMap { $0 })
    }
    
    
    fileprivate var bottomConstraint: NSLayoutConstraint!
    fileprivate var constraintHolders: [ConstraintHolder]!
    
    fileprivate class ConstraintHolder {
        weak var rowView: RowView!
        
        weak var left: NSLayoutConstraint!
        weak var right: NSLayoutConstraint!
        weak var height: NSLayoutConstraint!
        weak var top: NSLayoutConstraint!
        
        var all: [NSLayoutConstraint] { return [left,right,height,top].flatMap{ $0 ?? nil } }
    }
    
    
    //MARK: - Gesture recognition
    func didPan(_ pgr: UIPanGestureRecognizer) {
        if delegate == nil { return }
        
        let translation = pgr.translation(in: pgr.view)
        let velocity = pgr.velocity(in: pgr.view)
        let start = pgr.location(in: pgr.view).x - translation.x
        
        let movement = abs(translation.x)
        
        if pgr.state == .ended || pgr.state == .cancelled || pgr.state == .failed {
            if translation.x < 0 && movement > (pgr.view!.frame.width / 3) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "chartViewWillDelete"), object: self)
                let index = rowViews.index(of: pgr.view as! RowView)!
                self.deleteRowView(atIndex: index, velocity: velocity.x)
                
            } else {
                UIView.animate(withDuration: 0.2) {
                    pgr.view!.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
            return
        }
        
        guard translation.x < 0 else { return }
        
        guard start > (pgr.view!.frame.width / 2) else { return }
        pgr.view!.transform = CGAffineTransform(translationX: -movement, y: 0)
    }
   
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension ChartView {
    func deleteRowView(atIndex index: Int, velocity: CGFloat) {
        dataSource.chartView(self, commit: .delete, forRowAt: index)
        
        guard dataSource.numberOfRows(in: self) + 1 == rowViews.count else { fatalError("You needed to remove an element from the dataSource") }
        
        let removingCH = constraintHolders.remove(at: index)
        let rv = self._rowViews.remove(at: index)
        
        var singleConstraint: NSLayoutConstraint!
        var singleConstraintHolder: ConstraintHolder!
        var originalPriority: UILayoutPriority!
        
        if rowViews.count == 0 {
            
            singleConstraint = bottomConstraint

            originalPriority = singleConstraint.priority
            (removingCH.all + [singleConstraint]).forEach { $0.isActive = false }
            self.bottomConstraint = self.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0)

            self.bottomConstraint.priority = 100
            self.bottomConstraint.isActive = true
            singleConstraint = bottomConstraint
            
        } else if index == 0 {
            let belowCH = constraintHolders[index]
            
            singleConstraint = belowCH.top
            originalPriority = singleConstraint.priority
            (removingCH.all + [singleConstraint]).forEach { $0.isActive = false }
            belowCH.top = belowCH.rowView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.rowSpacing)
            belowCH.top.priority = 100
            belowCH.top.isActive = true
            singleConstraint = belowCH.top
            singleConstraintHolder = belowCH
            
        } else if index == (rowViews.count) {
            let aboveCH = constraintHolders[index - 1]
            
            singleConstraint = self.bottomConstraint
            originalPriority = singleConstraint.priority
            (removingCH.all + [singleConstraint]).forEach { $0.isActive = false }
            self.bottomConstraint = aboveCH.rowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.rowSpacing)
            self.bottomConstraint.priority = 100
            self.bottomConstraint.isActive = true
            singleConstraint = self.bottomConstraint
            
        } else {
            let aboveCH = constraintHolders[index - 1]
            let belowCH = constraintHolders[index]
            
            singleConstraint = belowCH.top
            originalPriority = singleConstraint.priority
            (removingCH.all + [singleConstraint]).forEach { $0.isActive = false }
            belowCH.top = aboveCH.rowView.bottomAnchor.constraint(equalTo: belowCH.rowView.topAnchor, constant: -self.rowSpacing)
            belowCH.top.priority = 100
            belowCH.top.isActive = true
            singleConstraint = belowCH.top
            singleConstraintHolder = belowCH
        }
        
        UIView.animate(withDuration: 0.3, animations:  {
            rv.alpha = 0
            rv.transform = CGAffineTransform(translationX: -(30 + rv.frame.width), y: 0)
        }, completion: { _ in
            rv.removeFromSuperview()
            self.unusedRows.append(rv)
            self.currentRowCount -= 1
            rv.alpha = 1
            rv.transform = CGAffineTransform.identity
            
            singleConstraint.isActive = false
            singleConstraint = singleConstraint.firstAnchor.constraint(equalTo: singleConstraint.secondAnchor!, constant: singleConstraint.constant)
            singleConstraint.priority = originalPriority
            singleConstraint.isActive = true
            if let sch = singleConstraintHolder {
                sch.top = singleConstraint
            } else {
                self.bottomConstraint = singleConstraint
            }
        })
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "chartViewDidDelete"), object: self)
    }

}
