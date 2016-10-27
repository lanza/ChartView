import UIKit

public class RowView: UIView {
    public var columnViews = [UIView]()
    public init() {
        super.init(frame: CGRect())
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
