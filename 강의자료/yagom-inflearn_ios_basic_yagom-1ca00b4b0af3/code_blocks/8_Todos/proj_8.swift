import UIKit

/// 코드블록 8-1-1

// MARK:- Properties
// MARK: Type Properties
/// 스토리보드에 구현해 둔 인스턴스를 코드를 통해 더 생성하기 위하여 스토리보드 ID를 활용
static let storyboardID: String = "TodoViewController"

// MARK: IBOutlets
@IBOutlet weak var titleField: UITextField!
@IBOutlet weak var memoTextView: UITextView!
@IBOutlet weak var dueDatePicker: UIDatePicker!
@IBOutlet weak var shouldNotifySwitch: UISwitch!
///


/// 코드블록 8-2-1

/// Todo 인스턴스를 표현할 구조체
struct Todo: Codable {
    var title: String       // 작업이름
    var due: Date           // 작업기한
    var memo: String?       // 작업메모
    var shouldNotify: Bool  // 사용자가 기한에 맞춰 알림을 받기 원하는지
    var id: String          // 작업 고유 ID
}
///


/// 코드블록 8-2-2

/// Todo 목록 저장/로드
extension Todo {
    
    static var all: [Todo] = Todo.loadTodosFromJSONFile()
    
    /// Todo JSON 파일 위치
    private static var todosPathURL: URL {
        return try! FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory,
                                            in: FileManager.SearchPathDomainMask.userDomainMask,
                                            appropriateFor: nil,
                                            create: true).appendingPathComponent("todos.json")
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
///


/// 코드블록 8-2-3

/// 현재 Todo 배열에 추가/삭제/수정
extension Todo {
    
    @discardableResult static func remove(id: String) -> Bool {
        
        guard let index: Int = self.all.index(where: { (todo: Todo) -> Bool in
            todo.id == id
        }) else { return false }
        self.all.remove(at: index)
        return self.saveToJSONFile()
    }
    
    @discardableResult func save(completion: () -> Void) -> Bool {
        
        if let index = Todo.index(of: self) {
            Todo.all.replaceSubrange(index...index, with: [self])
        } else {
            Todo.all.append(self)
        }
        
        let isSuccess: Bool = Todo.saveToJSONFile()
        
        if isSuccess {
            completion()
        }
        
        return isSuccess
    }
    
    private static func index(of target: Todo) -> Int? {
        guard let index: Int = self.all.index(where: { (todo: Todo) -> Bool in
            todo.id == target.id
        }) else { return nil }
        
        return index
    }
}
///


/// 코드블록 8-3-1

// MARK: - Properties
// MARK: Privates
/// todo 목록 - dummy 데이터
private var todos: [Todo] = [Todo(title: "테스트1", due: Date(), memo: "메모1", shouldNotify: true, id: "1"),
                             Todo(title: "테스트2", due: Date(), memo: "메모2", shouldNotify: true, id: "2"),
                             Todo(title: "테스트3", due: Date(), memo: "메모3", shouldNotify: true, id: "3")]

/// 셀에 표시할 날짜를 포멧하기 위한 Date Formatter
private let dateFormatter: DateFormatter = {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.short
    return formatter
}()
///


/// 코드블록 8-3-2

// MARK: - Methods
// MARK: Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    
    // UIViewController에서 제공하는 기본 수정버튼
    self.navigationItem.leftBarButtonItem = self.editButtonItem
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // 화면이 보여질 때마다 todo 목록을 새로고침
    self.todos = Todo.all
    self.tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRow.Animation.automatic)
}
///


/// 코드블록 8-3-3
// MARK: Table view data source
/// 테이블뷰의 섹션 수 (기본값 1)
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

/// 테이블뷰의 섹션 별 로우 수
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.todos.count
}
///


/// 코드블록 8-3-4

/// 인덱스에 해당하는 cell 반환
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 스토리보드에 구현해 둔 셀을 재사용 큐에서 꺼내옴
    let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
    
    guard indexPath.row < self.todos.count else { return cell }
    
    let todo: Todo = self.todos[indexPath.row]
    
    // 셀에 내용 설정
    cell.textLabel?.text = todo.title
    cell.detailTextLabel?.text = self.dateFormatter.string(from: todo.due)
    
    return cell
}
///


/// 코드블록 8-4-1

// MARK: - Nested Types
/// 동일한 화면을 편집상태와 보기 모드로 변환
private enum Mode {
    case edit, view
}
///


/// 코드블록 8-4-2

// MARK: Stored Properties
/// 화면에 보여줄 Todo 정보
var todo: Todo?

// MARK: Privates
/// 현재 화면의 작업상태
private var mode: Mode = Mode.edit {
    // mode 변경에 따라 적절한 처리
    didSet {
        self.titleField.isUserInteractionEnabled = (mode == .edit)
        self.memoTextView.isEditable = (mode == .edit)
        self.dueDatePicker.isUserInteractionEnabled = (mode == .edit)
        self.shouldNotifySwitch.isEnabled = (mode == .edit)
        
        if mode == Mode.edit {
            if todo == nil {
                self.navigationItem.leftBarButtonItems = [self.cancelButton]
            } else {
                self.navigationItem.rightBarButtonItems = [self.doneButton, self.cancelButton]
            }
        } else {
            self.navigationItem.rightBarButtonItems = [self.editButton]
        }
    }
}
///


/// 코드블록 8-4-3

/// 수정 - 내비게이션 바 버튼
private var editButton: UIBarButtonItem {
    let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                                                  target: self,
                                                  action: #selector(touchUpEditButton(_:)))
    return button
}

/// 취소 - 내비게이션 바 버튼
private var cancelButton: UIBarButtonItem {
    let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                                  target: self,
                                                  action: #selector(touchUpCancelButton(_:)))
    return button
}

/// 완료 - 내비게이션 바 버튼
private var doneButton: UIBarButtonItem {
    let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                                  target: self,
                                                  action: #selector(touchUpDoneButton(_:)))
    return button
}
///


/// 코드블록 8-4-4

// MARK: - Methods
// MARK: Privates
/// 화면초기화
private func initializeViews() {
    
    // 이전화면에서 전달받은 todo가 있다면 그에 맞게 화면 초기화
    if let todo: Todo = self.todo {
        self.navigationItem.title = todo.title
        self.titleField.text = todo.title
        self.memoTextView.text = todo.memo
        self.dueDatePicker.date = todo.due
        self.mode = Mode.view
    }
}
///

/// 코드블록 8-4-5

/// 간단한 얼럿을 보여줄 때 코드 중복을 줄이기위한 메서드
private func showSimpleAlert(message: String,
                             cancelTitle: String = "확인",
                             cancelHandler: ((UIAlertAction) -> Void)? = nil) {
    
    let alert: UIAlertController = UIAlertController(title: "알림",
                                                     message: message,
                                                     preferredStyle: UIAlertController.Style.alert)
    let action: UIAlertAction = UIAlertAction(title: cancelTitle,
                                              style: UIAlertAction.Style.cancel,
                                              handler: cancelHandler)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
}
///

/// 코드블록 8-4-6

/// 수정 버튼을 눌렀을 때
@objc private func touchUpEditButton(_ sender: UIBarButtonItem) {
    self.mode = Mode.edit
}

/// 취소 버튼을 눌렀을 때
@objc private func touchUpCancelButton(_ sender: UIBarButtonItem) {
    
    if self.todo == nil {
        // 이전 화면에서 전달받은 todo가 없다면 새로 작성을 위한 상태이므로 모달을 내려주고
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    } else {
        // 그렇지 않으면 다시 원래 todo 상태로 화면을 초기화 해줌
        self.initializeViews()
    }
}
///

/// 코드블록 8-4-7

/// 완료 버튼을 눌렀을 때
@objc private func touchUpDoneButton(_ sender: UIBarButtonItem) {
    
    // todo 제목은 필수사항이므로 입력했는지 확인
    guard let title: String = self.titleField.text,
        title.isEmpty == false else {
            self.showSimpleAlert(message: "제목은 꼭 작성해야합니다",
                                 cancelHandler: { (action: UIAlertAction) in
                                    self.titleField.becomeFirstResponder()
            })
            return
    }
    
    // 새로운 todo 생성
    let todo: Todo
    todo = Todo(title: title,
                due: self.dueDatePicker.date,
                memo: self.memoTextView.text,
                shouldNotify: self.shouldNotifySwitch.isOn,
                id: self.todo?.id ?? String(Date().timeIntervalSince1970)) /// 유닉스 타임스템프를 할 일 고유 아이디로 활용
    
    let isSuccess: Bool
    
    if self.todo == nil {
        // 새로 작성하기 위한 상태라면 저장을 완료하고 모달을 내려줌
        isSuccess = todo.save {
            self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    } else {
        // 수정상태라면 저장을 완료하고 화면을 보기모드로 전환
        isSuccess = todo.save(completion: {
            self.todo = todo
            self.mode = Mode.view
        })
    }
    
    // 저장에 실패하면 알림
    if isSuccess == false {
        self.showSimpleAlert(message: "저장 실패")
    }
}
///

/// 코드블록 8-5-1

// MARK: Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    
    // 텍스트 필드 delegate 설정
    self.titleField.delegate = self
    
    // 이전 화면에서 전달받은 todo가 없다면 새로운 작성화면 설정
    if self.todo == nil {
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.navigationItem.rightBarButtonItem = self.doneButton
    } else {
        self.navigationItem.rightBarButtonItem = self.editButton
    }
    
    // 화면 초기화
    self.initializeViews()
}
///

/// 코드블록 8-5-2

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // 수정 모드라면 텍스트 필드에 바로 입력할 수 있도록 키보드 보여줌
    if self.mode == Mode.edit {
        self.titleField.becomeFirstResponder()
    }
}
///

/// 코드블록 8-5-3

/// 텍스트 필드 delegate 메서드 구현
extension TodoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.navigationItem.title = textField.text
    }
}

///

/// 코드블록 8-5-4

// MARK: Navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let todoViewController: TodoViewController = segue.destination as? TodoViewController else {
        return
    }
    
    guard let cell: UITableViewCell = sender as? UITableViewCell else { return }
    guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return }
    
    guard index.row < todos.count else { return }
    let todo: Todo = todos[index.row]
    todoViewController.todo = todo
}
///

/// 코드블록 8-5-5

private var todos: [Todo] = Todo.all
///

/// 코드블록 8-6-1

/// User Notification의 delegate 메서드 구현
extension TodosTableViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let idToShow: String = response.notification.request.identifier
        
        guard let todoToShow: Todo = self.todos.filter({ (todo: Todo) -> Bool in
            return todo.id == idToShow
        }).first else {
            return
        }
        
        guard let todoViewController: TodoViewController = self.storyboard?.instantiateViewController(withIdentifier: TodoViewController.storyboardID) as? TodoViewController else { return }
        
        todoViewController.todo = todoToShow
        
        self.navigationController?.pushViewController(todoViewController, animated: true)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
}
///

/// 코드블록 8-6-2

import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // 애플리케이션 실행 직후 호출
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // User Notification Center를 통해서 노티피케이션 권한 획득
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound, UNAuthorizationOptions.badge]) { (granted, error) in
            print("허용여부 \(granted), 오류 : \(error?.localizedDescription ?? "없음")")
        }
        
        // 맨 처음 화면의 뷰 컨트롤러(TodosTableViewController)를 UserNotificationCenter의 delegate로 설정
        if let navigationController: UINavigationController = self.window?.rootViewController as? UINavigationController,
            let todosTableViewController: TodosTableViewController = navigationController.viewControllers.first as? TodosTableViewController {
            
            UNUserNotificationCenter.current().delegate = todosTableViewController
        }
        
        return true
    }
    
}
///

/// 코드블록 8-6-3

/// Todo의 User Notification 관련 메서드
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
        let dateInfo = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from: todo.due)
        
        // 노티피케이션 트리거 생성
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // 노티피케이션 요청 객체 생성
        let request = UNNotificationRequest(identifier: todo.id, content: content, trigger: trigger)
        
        // 노티피케이션 스케줄 추가
        center.add(request, withCompletionHandler: { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
    }
    
    private static func removeNotification(todo: Todo) {
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [todo.id])
    }
}
///

/// 코드블록 8-6-4

@discardableResult func save(completion: () -> Void) -> Bool {
    
    if let index = Todo.index(of: self) {
        Todo.removeNotification(todo: self)
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
        completion()
    }
    
    return isSuccess
}
///

