//
//  Todo.swift
//  MyTodos
//
//  Created by KDY on 2020/05/14.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit
import UserNotifications

/// Todo 인스턴스를 표현할 구조체
struct Todo: Codable {
    var title: String       // 작업이름
    var due: Date           // 작업기한
    var memo: String?       // 작업메모
    var shouldNotify: Bool  // 사용자가 기한에 맞춰 알림을 받기 원하는지
    var id: String          // 작업 고유 ID
}

extension Todo {
    static var all: [Todo]? = decode(from: "Todo") ?? default value
    
    static func decode(from assetName: String)->[Todo]? {
        guard let asset: NSDataAsset = NSDataAsset(name: assetName) else {
            print("에셋 로드 실패")
            return nil
        }
        
        do {
            let decoder: PropertyListDecoder = PropertyListDecoder()
            return try decoder.decode([Todo], from: asset.data)
        } catch {
            print("데이터 디코딩 실패")
            print(error.localizedDescription)
            return nil
        }
    }
)

/*
/// Todo 목록 저장/로드
extension Todo {
    
    static var all: [Todo] = Todo.loadTodosFromJSONFile()
    
    /// Todo JSON 파일 위치
    private static var todosPathURL: URL {
        return try! FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("todos.json")
    }
    
    /// JSON 파일로부터 Todo 배열 읽어오기
    private static func loadTodosFromJSONFile() -> [Todo] {
        do {
            let jsonData: Data = try Data(contentsOf: self.todosPathURL)
            let todos: [Todo] = try JSONDecoder().decode([Todo].self, from: jsonData)
            return todos
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    /// 현재 Todo 배열 상태를 JSON 파일로 저장
    @discardableResult private static func saveToJSONFile() -> Bool {
        do {
            let data: Data = try JSONEncoder().encode(self.all)
            try data.write(to: self.todosPathURL, options: Data.WritingOptions.atomicWrite)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}

/// 현재 Todo 배열에 추가/삭제/수정
extension Todo {
    
    @discardableResult static func remove(id: String) -> Bool {
        guard let index: Int = self.all.firstIndex(where: { (todo:Todo) -> Bool in todo.id == id}) else { return false }
        self.all.remove(at: index)
        return self.saveToJSONFile()
    }
    
    @discardableResult func save(comletion: () -> Void) -> Bool {
        if let index = Todo.index(of: self) {
            Todo.all.replaceSubrange(index...index, with: [self])
        } else {
            Todo.all.append(self)
        }
        
        let isSuccess: Bool = Todo.saveToJSONFile()
        
        if isSuccess {
            if self.shouldNotify {
                Todo.addNotification(todo: self)
            } else {
                Todo.removeNotification(todo: self)
            }
            comletion()
        }
        
        return isSuccess
    }
    
    private static func index(of target: Todo) -> Int? {
        guard let index: Int = self.all.firstIndex(where: {(todo:Todo) -> Bool in todo.id == target.id}) else { return nil }
        return index
    }
}

extension Todo {
    private static func addNotification(todo: Todo) {
        // 공용 UserNotification 객체
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        // 노티피케이션 콘텐츠 객체 생성
        let content = UNMutableNotificationContent()
        content.title = "할일 알림"
        content.body = todo.title
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // 기한 날짜 생성
        let dataInfo = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: todo.due)
        
        // 노티피케이션 트리거 생성
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataInfo, repeats: false)
        
        // 노티피케이션 요청 객체 생성
        let request = UNNotificationRequest(identifier: todo.id, content: content, trigger: trigger)
        
        // 노티피케이션 스케줄 추가
        center.add(request, withCompletionHandler: {(error:Error?) in if let theError = error {
            print(theError.localizedDescription)
            }
        })
    }
    
    private static func removeNotification(todo: Todo) {
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [todo.id])
    }
}
*/