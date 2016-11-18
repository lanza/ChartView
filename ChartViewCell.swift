import UIKit

open class ChartViewCell: UITableViewCell {
    
    public let topContentView = UIView()
    public let chartView = ChartView()
    public let bottomContentView = UIView()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        topContentView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topContentView)
        contentView.addSubview(chartView)
        contentView.addSubview(bottomContentView)
        
        NSLayoutConstraint.activate([
            topContentView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            topContentView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            topContentView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            topContentView.bottomAnchor.constraint(equalTo: chartView.topAnchor),
            chartView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomContentView.topAnchor),
            bottomContentView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            bottomContentView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        selectionStyle = .none
    }
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
