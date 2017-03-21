import UIKit

class ChartViewDataSourceImplementation: ChartViewDataSource {
    var numberOfRowsInChartView: ((_ chartView: ChartView) -> Int)!
    func numberOfRows(in chartView: ChartView) -> Int {
        return numberOfRowsInChartView(chartView)
    }

    var cellForRowAtIndex: ((_ chartView: ChartView, _ index: Int) -> ChartViewCell)!
    func chartView(_ chartView: ChartView, cellForRowAtIndex index: Int) -> ChartViewCell {
        return cellForRowAtIndex(chartView,index)
    }
    
    var chartViewCommitEditingStyle: ((_ chartView: ChartView, _ editingStyle: ChartView.EditingStyle) -> Void)!
    func chartView(_ chartView: ChartView, commit editingStyle: ChartView.EditingStyle, forRowAt index: Int) {
        chartViewCommitEditingStyle(chartView,editingStyle)
    }
}
