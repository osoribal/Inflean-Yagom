//
//  Request.swift
//  MyFriends
//
//  Created by KDY on 2020/06/21.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

// 플레이스 홀더로 사용할 이미지 객체
let placeHolderImage: UIImage? = UIImage(named: "placeholder")

// API 응답으로 받아오는 응답 JSON 모델
struct Response: Codable {
    let friends: [Person]
    
    enum CodingKeys: String, CodingKey {
        case friends = "results"
    }
}

// API 요청을 담당할 구조체
struct Request {
    // MARK: - Private Peroperties
    private static let friendsURL: URL = URL(string: "https://randomuser.me/api/1.1/?inc=name,nat,cell,picture&format=json&results=50&noinfo")!
    
    // 이미지 다운로드 디스패치 큐
    // 2. 이미지 디스패치 큐가 한 번에 여러 개의 작업을 수행할 수 있도록 변경
    private static let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image", attributes: .concurrent)
    
    // 이미지 메모리 캐시를 위한 딕셔너리
    private static var cachedImage: [URL: UIImage] = [:]
}

// MARK: - Friends
extension Request {
    // 친구목록 요청
    static func friends(_ completion:@escaping (_ friends: [Person]?) -> Void) {
        let session: URLSession = URLSession(configuration: .default)
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dataTask: URLSessionDataTask = session.dataTask(with: friendsURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            defer {
                DispatchQueue.main.async {
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse: Response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.friends)
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
        dataTask.resume()
    }
}

// MARK: - Image
extension Request {
    // 이미지 데이터 요청
    static func image(_ url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        if let cachedImage: UIImage = self.cachedImage[url] {
            DispatchQueue.main.async {
                completion(cachedImage)
                return
            }
        }
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageDispatchQueue.async {
            defer {
                DispatchQueue.main.async {
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            guard let data: Data = try? Data(contentsOf: url) else {
                print("데이터 - 이미지 변환 실패")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let image: UIImage? = UIImage(data: data)
            cachedImage[url] = image
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
