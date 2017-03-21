import ChartView
import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChartViewCell.self, forCellReuseIdentifier: "cell")
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChartViewCell
       
        let cvdsi = ChartViewDataSourceImplementation()
        cell.chartView.dataSource = cvdsi
        
        return cell 
    }
}


class ChartViewDataSourceDemo: ChartViewDataSourceImplementation {
    override init() {
        self.numberOfRowsInChartView = { cv in
            return 5
        }
        self.cellForRowAtIndex = { cv, index in
            let rowView = cv.dequeueRowView()
            
            
        }
    }
}

func setupRowView() {
    let columnConfiguration = ColumnConfiguration(width: 40, viewType: UILabel.self)
    
    let rowViewConfiguration = RowViewConfiguration(columnConfigurations: [columnConfiguration])
    
    
    RowView.configuration = rowViewConfiguration
}

