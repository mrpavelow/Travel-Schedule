import Foundation

@MainActor
final class APITestRunner: ObservableObject {
    static let shared = APITestRunner()
    
    private var didRun = false
    private init() {}
    
    func runOnce() {
        guard !didRun else { return }
        didRun = true
        
        Task {
            //            await APITests.testFetchStations()
            //            await APITests.testFetchScheduleBetweenStations()
            //            await APITests.testFetchStationSchedule()
            //            await APITests.testFetchThreadViaSearch()
            //            await APITests.testFetchNearestSettlement()
            //            await APITests.testFetchCarrier()
            //            await APITests.testFetchStationsList()
            //            await APITests.testFetchCopyright()
            
            print("✅ All API tests finished")
        }
    }
}
