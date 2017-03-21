import UIKit

open class ChartViewDataSourceImplementation: ChartViewDataSource {
    public init() {}
    public var numberOfRowsInChartView: ((_ chartView: ChartView) -> Int)!
    public func numberOfRows(in chartView: ChartView) -> Int {
        return numberOfRowsInChartView(chartView)
    }

    public var cellForRowAtIndex: ((_ chartView: ChartView, _ index: Int) -> RowView)!
    public func chartView(_ chartView: ChartView, cellForRowAtIndex index: Int) -> RowView {
        return cellForRowAtIndex(chartView,index)
    }
    
    public var chartViewCommitEditingStyle: ((_ chartView: ChartView, _ editingStyle: ChartView.EditingStyle) -> Void)!
    public func chartView(_ chartView: ChartView, commit editingStyle: ChartView.EditingStyle, forRowAt index: Int) {
        chartViewCommitEditingStyle(chartView,editingStyle)
    }
}
