import ChartView
import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChartViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChartViewCell
        cell.registerRowViewForReuse(SimpleRowView.self)
        
        let cvdsd = ChartViewDataSourceDemo()
        cell.chartViewDataSource = cvdsd
        
        return cell 
    }
}


class ChartViewDataSourceDemo: ChartViewDataSourceImplementation {
    override init() {
        super.init()
        self.numberOfRowsInChartView = { cv in
            return 5
        }
        self.cellForRowAtIndex = { cv, index in
            let rowView = cv.dequeueRowView() as! SimpleRowView
            let mainLabel = rowView.mainLabel
            mainLabel.text = "HI"
            return rowView
        }
    }
}

class SimpleRowView: ConfigurableRowView<SimpleColumnConfiguration> {
    override var columnConfigurations: [SimpleColumnConfiguration] {
        return [.mainLabel]
    }
    
    var mainLabel: UILabel { return store[.mainLabel] as! UILabel }
}


public struct SimpleColumnConfiguration: ColumnConfiguration {
    static let mainLabel = SimpleColumnConfiguration(width: 46, viewType: UILabel.self, key: "mainLabel")
    
    public let width: CGFloat
    public let viewType: UIView.Type
    public let key: String
    public var hashValue: Int { return key.hashValue }
    public static func ==(lhs: SimpleColumnConfiguration, rhs: SimpleColumnConfiguration) -> Bool {
        return lhs.width == rhs.width &&
        lhs.viewType == rhs.viewType &&
        lhs.hashValue == rhs.hashValue
    }
    
}
