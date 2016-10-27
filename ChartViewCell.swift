import UIKit

public class ChartViewCell: UITableViewCell {
    
    public let chartView = ChartView()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        selectionStyle = .none
    }
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
