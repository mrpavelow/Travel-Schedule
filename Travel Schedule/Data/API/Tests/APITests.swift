import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
//
//private struct SearchDTO: Decodable {
//    let segments: [SegmentDTO]?
//}
//
//private struct SegmentDTO: Decodable {
//    let thread: ThreadDTO?
//    let start_date: String?
//    let departure: String?
//}
//
//private struct ThreadDTO: Decodable {
//    let uid: String?
//}
//
//private func extractDate(_ s: String?) -> String? {
//    guard let s else { return nil }
//    if s.count >= 10 { return String(s.prefix(10)) }
//    return nil
//}
//
//enum APITests {
//    
//    static func testFetchStations() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = NearestStationsService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching stations...")
//            let result = try await service.getNearestStations(
//                lat: 59.864177,
//                lng: 30.319163,
//                distance: 50
//            )
//            print("✅ Stations: \(result)")
//        } catch {
//            print("❌ Stations error: \(error)")
//        }
//    }
//    
//    static func testFetchScheduleBetweenStations() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = ScheduleBetweenStationsService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching schedule between stations...")
//            let result = try await service.get(from: "c2", to: "c213", date: nil)
//            print("✅ Search: \(result)")
//        } catch {
//            print("❌ Search error: \(error)")
//        }
//    }
//    
//    static func testFetchStationSchedule() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = StationScheduleService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching station schedule...")
//            let result = try await service.get(station: "s9600213", date: nil)
//            print("✅ Schedule: \(result)")
//        } catch {
//            print("❌ Schedule error: \(error)")
//        }
//    }
//    
//    static func testFetchThreadViaSearch() async {
//        do {
//            let client = try APIConfig.makeClient()
//            
//            let searchService = ScheduleBetweenStationsService(
//                client: client,
//                apikey: APIConfig.apiKey
//            )
//            
//            let threadService = ThreadStationsService(
//                client: client,
//                apikey: APIConfig.apiKey
//            )
//            
//            print("Fetching /search to derive uid for /thread...")
//            
//            let searchResult = try await searchService.get(
//                from: "c2",
//                to: "c213",
//                date: nil
//            )
//            
//            let encoded = try APIConfig.encoder.encode(searchResult)
//            let dto = try APIConfig.decoder.decode(SearchDTO.self, from: encoded)
//            
//            guard
//                let first = dto.segments?.first,
//                let uid = first.thread?.uid,
//                !uid.isEmpty
//            else {
//                print("❌ Could not extract thread uid from /search response")
//                return
//            }
//            
//            let date = first.start_date ?? extractDate(first.departure)
//            
//            print("✅ Derived thread uid=\(uid), date=\(date ?? "nil")")
//            print("Fetching /thread...")
//            
//            let thread = try await threadService.get(uid: uid, date: date)
//            
//            print("✅ Thread fetched successfully: \(thread)")
//        } catch {
//            print("❌ Thread via search error: \(error)")
//        }
//    }
//    
//    static func testFetchNearestSettlement() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = NearestSettlementService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching nearest settlement...")
//            let result = try await service.get(lat: 59.864177, lng: 30.319163, distance: 50)
//            print("✅ Nearest settlement: \(result)")
//        } catch {
//            print("❌ Nearest settlement error: \(error)")
//        }
//    }
//    
//    static func testFetchCarrier() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = CarrierService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching carrier...")
//            let result = try await service.get(code: "TK", system: "iata")
//            print("✅ Carrier: \(result)")
//        } catch {
//            print("❌ Carrier error: \(error)")
//        }
//    }
//    
//    static func testFetchStationsList() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = StationsListService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching stations list...")
//            let _ = try await service.getDTO()
//            print("✅ stations_list decoded successfully")
//        } catch {
//            print("❌ Stations list error: \(error)")
//        }
//    }
//    
//    static func testFetchCopyright() async {
//        do {
//            let client = try APIConfig.makeClient()
//            let service = CopyrightService(client: client, apikey: APIConfig.apiKey)
//            
//            print("Fetching copyright...")
//            let result = try await service.get()
//            print("✅ Copyright: \(result)")
//        } catch {
//            print("❌ Copyright error: \(error)")
//        }
//    }
//}
