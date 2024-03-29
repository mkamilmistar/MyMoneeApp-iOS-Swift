//
//  DreamService.swift
//  MyMoneeApp
//
//  Created by MacBook on 20/05/21.
//

import Foundation

class DreamService {
//    let url: String = "https://60a5decac0c1fd00175f48af.mockapi.io/api/v1/dream"
    let url: String = "http://127.0.0.1:8080/dream"
    
    func getDreams(completion: @escaping (_ dreamDataModel: [DreamResponse]) -> Void) {
        let decoder = JSONDecoder()
        guard let url = URL(string: "http://127.0.0.1:8080/dreams") else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                return
            }
            do {
                let data = try decoder.decode([DreamResponse].self, from: data)
                completion(data)
            } catch {
                let error = error
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func addDream(dreamDataModel: DreamResponse, completion: @escaping () -> Void) {
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(dreamDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) {(_, _, _) in
           completion()
        }
        task.resume()
    }
    
    func updateDream(_ userId: String, dreamDataModel: DreamResponse, completion: @escaping () -> Void) {
        
        guard let url = URL(string: url)?.appendingPathComponent(userId) else {
            print("Error: cannot create URL")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(dreamDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) {(_, _, _) in
           completion()
        }
        task.resume()
    }
    
    func deleteDream(_ dreamId: String, completion: @escaping () -> Void ) {
        
        let dreamId = "/\(dreamId)"
        
        guard let url = URL(string: url)?.appendingPathComponent(dreamId) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) {(_, _, _) in
           completion()
        }
        task.resume()
    }
    
    // BY ID
    func getDreamById(dreamId: String, completion: @escaping (_ dreamDataModel: DreamResponse) -> Void) {
        let decoder = JSONDecoder()
        guard let url = URL(string: url)?.appendingPathComponent(dreamId) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                return
            }
            do {
                let data = try decoder.decode(DreamResponse.self, from: data)
                completion(data)
            } catch {
                let error = error
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
