import UIKit

public protocol ChartViewDelegate: class {
    
    func rowHeight(for chartView: ChartView) -> CGFloat
    func rowSpacing(for chartView: ChartView) -> CGFloat
}
extension ChartViewDelegate {
    func rowHeight(for chartView: ChartView) -> CGFloat {
        return 30
    }
    func rowSpacing(for chartView: ChartView) -> CGFloat {
        return 1
    }
}

public protocol ChartViewDataSource: class {
    
    func numberOfRows(in chartView: ChartView) -> Int
    func chartView(_ chartView: ChartView, cellForRowAtIndex index: Int) -> RowView
    
    func chartView(_ chartView: ChartView, commit editingStyle: ChartView.EditingStyle, forRowAt index: Int)
}
extension ChartViewDataSource {
    func chartView(_ chartView: ChartView, commit editingStyle: ChartView.EditingStyle, forRowAt index: Int) {
        
    }
}
