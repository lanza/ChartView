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
            topContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            topContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            topContentView.bottomAnchor.constraint(equalTo: chartView.topAnchor),
            chartView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomContentView.topAnchor),
            bottomContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bottomContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        selectionStyle = .none
    }
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
