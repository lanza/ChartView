import UIKit

public protocol ColumnConfiguration: Hashable {
    var width: CGFloat { get }
    var viewType: UIView.Type { get }
}
extension ColumnConfiguration {
    public func getView() -> UIView {
        return viewType.init()
    }
}
