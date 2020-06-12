import UIKit

/// 코드블록 9-2-1

// 친구 개개인의 정보를 표현할 모델 구조체
struct Person: Codable, Equatable {
    
    // MARK: - Nested Types
    struct Name: Codable, Equatable {
        let title: String
        let first: String
        let last: String
        
        var full: String {
            return (self.title + ". " + self.last + " " + self.first).uppercased()
        }
    }
    
    struct PictureURL: Codable, Equatable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }
    
    // MARK: - Properties
    let name: Name
    let cell: String
    let pictureURL: PictureURL
    
    // MARK: Privates
    private let nat: String
}
///


/// 코드블록 9-2-2

// MARK: - Coding Keys
extension Person {
    enum CodingKeys: String, CodingKey {
        case name, cell, nat
        case pictureURL = "picture"
    }
}

// MARK: - Computed Properties
extension Person {
    var nationality: String {
        return nat.uppercased()
    }
}
///


/// 코드블록 9-2-3

// MARK: - Best Friends JSON File URL
extension Person {
    private static let bestFriendFileName: String = "best_friends.json"
    private static var bestFriendFileURL: URL? {
        
        let fileManager: FileManager = FileManager.default
        
        let documentURL: URL
        
        do {
            documentURL =
                try fileManager.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory,
                                    in: FileManager.SearchPathDomainMask.userDomainMask,
                                    appropriateFor: nil,
                                    create: true)
        } catch {
            print("can not find application support directory")
            print(error.localizedDescription)
            return nil
        }
        
        let fileURL: URL = documentURL.appendingPathComponent(bestFriendFileName)
        
        return fileURL
    }
}
///


/// 코드블록 9-2-4

// MARK: - Load Best Friends
extension Person {
    private static func loadBestFriendsFromFile() -> [Person] {
        
        guard let fileURL: URL = bestFriendFileURL else { return [] }
        
        do {
            let data: Data = try Data(contentsOf: fileURL)
            
            let decoder: JSONDecoder = JSONDecoder()
            let friends: [Person] = try decoder.decode([Person].self, from: data)
            
            return friends
        } catch {
            print("can not decode JSON")
            print(error.localizedDescription)
        }
        
        return []
    }
}
///


/// 코드블록 9-2-5

// MARK: - Best Friends Properties
extension Person {
    static var bestFriends: [Person] = Person.loadBestFriendsFromFile()
}
///



/// 코드블록 9-2-6

// MARK: - Save Best Friends
extension Person {
    
    static func saveCurrentBestFriendsToFile() -> Bool {
        
        guard let fileURL: URL = bestFriendFileURL else { return false }
        
        let encoder: JSONEncoder = JSONEncoder()
        
        do {
            let data: Data = try encoder.encode(self.bestFriends)
            try data.write(to: fileURL)
            return true
        } catch {
            print("can not save best friends")
            print(error.localizedDescription)
        }
        return false
    }
}
///


/// 코드블록 9-2-7

// MARK: - Add Best Friends
extension Person {
    
    static func addBestFriend(_ friend: Person,
                              completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        self.bestFriends.append(friend)
        
        DispatchQueue.main.async {
            completion?(self.saveCurrentBestFriendsToFile())
        }
    }
}
///


/// 코드블록 9-2-8

// MARK: - Find Best Friend Index
extension Person {
    private static func bestFriendIndex(of target: Person) -> Int? {
        guard let index: Int = self.bestFriends.index(where: {
            (friend: Person) -> Bool in
            friend == target
        }) else { return nil }
        
        return index
    }
}
///



/// 코드블록 9-2-9

// MARK: - Remove Best Friends
extension Person {
    
    static func removeBestFriend(_ friend: Person,
                                 completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        if let index: Int = self.bestFriendIndex(of: friend) {
            self.bestFriends.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(self.saveCurrentBestFriendsToFile())
            }
        } else {
            DispatchQueue.main.async {
                completion?(false)
            }
        }
    }
}

///


/// 코드블록 9-3-1

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
///



/// 코드블록 9-3-2

// API 요청을 담당할 구조체
struct Request {
    // MARK: - Private Properties
    private static let friendsURL: URL = URL(string: "https://randomuser.me/api/1.1/?inc=name,nat,cell,picture&format=json&results=50&noinfo")!
    
    // 이미지 다운로드 디스패치 큐
    private static let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image")
    
    // 이미지 메모리 캐시를 위한 딕셔너리
    private static var cachedImage: [URL: UIImage] = [:]
}
///



/// 코드블록 9-3-3

// MARK: - Friends
extension Request {
    // 친구목록 요청
    static func friends(_ completion: @escaping (_ friends: [Person]?) -> Void) {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dataTask: URLSessionDataTask = session.dataTask(with: friendsURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
///


/// 코드블록 9-3-4

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
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        imageDispatchQueue.async {
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
///


/// 코드블록 9-4-1

// MARK: - Delegate
protocol FriendTableViewCellDelegate {
    func friendCellStarredStateChanged(_ sender: FriendTableViewCell)
}
///


/// 코드블록 9-4-2

// MARK: - Class
/// 두 개의 테이블 뷰에서 공통으로 사용할 셀 클래스
class FriendTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var delegate: FriendTableViewCellDelegate?
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    // MARK: - Methods
    @IBAction func touchUpStarButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let delegate = self.delegate {
            delegate.friendCellStarredStateChanged(self)
        }
    }
}
///


/// 코드블록 9-4-3

// MARK: - Configure Cell
extension FriendTableViewCell {
    
    func configure(friend: Person, tableView: UITableView, indexPath: IndexPath) {
        
        self.nameLabel.text = friend.name.full
        self.nationalityLabel.text = friend.nationality
        self.cellLabel.text = friend.cell
        self.starButton.isSelected = Person.bestFriends.contains(friend)
        
        self.profileImageView.image = placeHolderImage
        
        Request.image(friend.pictureURL.thumbnail, completion: { (image: UIImage?) in
            
            DispatchQueue.main.async {
                
                guard let cell: FriendTableViewCell = tableView.cellForRow(at: indexPath) as? FriendTableViewCell else {
                    return
                }
                
                cell.profileImageView.image = image
            }
        })
    }
}
///


/// 코드블록 9-5-1

class FriendViewController: UIViewController {
    
    // MARK: - Properties
    var thumbnailImage: UIImage?
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet var fullStarButton: UIBarButtonItem!
    @IBOutlet var emptyStarButton: UIBarButtonItem!
    
    // MARK: Stored Properties
    var friend: Person! {
        didSet {
            self.navigationItem.title = friend.name.first.uppercased()
            self.correctBarButtonState()
        }
    }
}
///


/// 코드블록 9-5-2

// MARK: - Button States
extension FriendViewController {
    
    private func correctBarButtonState() {
        self.navigationItem.rightBarButtonItems = nil
        
        let rightBarButtonItem: UIBarButtonItem
        
        if Person.bestFriends.contains(self.friend) {
            rightBarButtonItem = self.fullStarButton
        } else {
            rightBarButtonItem = self.emptyStarButton
        }
        
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
    }
}
///


/// 코드블록 9-5-3

// MARK: - IBActions
extension FriendViewController {
    
    @IBAction func touchUpFullStarButton(_ sender: UIBarButtonItem) {
        Person.removeBestFriend(self.friend) { (isSuccess: Bool) in
            if isSuccess {
                self.correctBarButtonState()
            }
        }
    }
    
    @IBAction func touchUpEmptyStarButton(_ sender: UIBarButtonItem) {
        Person.addBestFriend(self.friend) { (isSuccess: Bool) in
            if isSuccess {
                self.correctBarButtonState()
            }
        }
    }
}
///


/// 코드블록 9-5-4

// MARK: - Life Cycle
extension FriendViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let friend: Person = self.friend else {
            return
        }
        
        self.correctBarButtonState()
        
        self.nameLabel.text = friend.name.full
        self.cellLabel.text = friend.cell
        self.nationalityLabel.text = friend.nationality
        self.imageView.image = self.thumbnailImage ?? placeHolderImage
        
        Request.image(friend.pictureURL.large) { (image: UIImage?) in
            self.imageView?.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if friend == nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
///


/// 코드블록 9-6-1

class FriendsTableViewController: UITableViewController {
    
    // MARK: - Properties
    // MARK: Privates
    private var friends: [Person] = []
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.backgroundColor = UIColor.lightGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
}
///


/// 코드블록 9-6-2

// MARK: - Friend Table View Cell Delegate
extension FriendsTableViewController: FriendTableViewCellDelegate {
    
    func friendCellStarredStateChanged(_ sender: FriendTableViewCell) {
        guard let index: IndexPath =
            self.tableView.indexPath(for: sender) else {
                return
        }
        
        guard index.row < self.friends.count else { return }
        
        let friend: Person = self.friends[index.row]
        
        if sender.starButton.isSelected {
            Person.addBestFriend(friend)
        } else {
            Person.removeBestFriend(friend)
        }
    }
}
///


/// 코드블록 9-6-3

// MARK: - Table view data source
extension FriendsTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FriendTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "friendCell",
                                             for: indexPath) as! FriendTableViewCell
        
        cell.delegate = self
        
        guard indexPath.row < self.friends.count else {
            return cell
        }
        
        let friend: Person = self.friends[indexPath.row]
        
        // Configure the cell...
        cell.configure(friend: friend, tableView: tableView, indexPath: indexPath)
        return cell
    }
}
///


/// 코드블록 9-6-4

// MARK: - Table view delegate
extension FriendsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "showFriendInfo", sender: cell)
        }
    }
}
///


/// 코드블록 9-6-5

// MARK: - Activity Indicator
extension FriendsTableViewController {
    
    private func showActivityIndicator() {
        self.view.addSubview(self.indicator)
        
        let safeAreaLayoutGuide: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        self.indicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.indicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        indicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
    }
}
///


/// 코드블록 9-6-6

// MARK: - Request
extension FriendsTableViewController {
    
    @objc private func requestFriends() {
        
        if let isRefreshing: Bool = self.tableView.refreshControl?.isRefreshing,
            isRefreshing == false {
            self.showActivityIndicator()
        }
        
        Request.friends { (friends: [Person]?) in
            if let friends = friends {
                self.friends = friends
                self.tableView.reloadSections(IndexSet(0...0),
                                              with: UITableViewRowAnimation.automatic)
            }
            
            if let refreshControl: UIRefreshControl = self.tableView.refreshControl,
                refreshControl.isRefreshing == true {
                refreshControl.endRefreshing()
            } else {
                self.hideActivityIndicator()
            }
        }
    }
}
///


/// 코드블록 9-6-7

// MARK: - Life Cycle
extension FriendsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib: UINib = UINib.init(nibName: "FriendTableViewCell",
                                        bundle: nil)
        
        self.tableView.register(cellNib,
                                forCellReuseIdentifier: "friendCell")
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.requestFriends),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        self.tableView.refreshControl = refreshControl
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.friends.isEmpty {
            self.requestFriends()
        } else {
            self.tableView.reloadSections(IndexSet(0...0),
                                          with: UITableViewRowAnimation.none)
        }
    }
}
///


/// 코드블록 9-6-8

// MARK: - Navigation
extension FriendsTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showFriendInfo" else { return }
        
        guard let cell: FriendTableViewCell = sender as? FriendTableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard index.row < self.friends.count else { return }
        
        guard let friendViewController: FriendViewController =
            segue.destination as? FriendViewController else {
                return
        }
        
        let friend: Person = self.friends[index.row]
        friendViewController.friend = friend
        friendViewController.thumbnailImage = cell.profileImageView.image
    }
}
///


/// 코드블록 9-7-1

class BestFriendsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib: UINib = UINib.init(nibName: "FriendTableViewCell",
                                        bundle: nil)
        self.tableView.register(cellNib,
                                forCellReuseIdentifier: "friendCell")
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadSections(IndexSet(0...0),
                                      with: UITableViewRowAnimation.none)
    }
}
///


/// 코드블록 9-7-2

// MARK: - Table view data source
extension BestFriendsTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Person.bestFriends.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FriendTableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "friendCell",
                                             for: indexPath) as! FriendTableViewCell
        
        guard indexPath.row < Person.bestFriends.count else {
            return cell
        }
        
        let friend: Person = Person.bestFriends[indexPath.row]
        
        // Configure the cell...
        cell.configure(friend: friend, tableView: tableView, indexPath: indexPath)
        cell.starButton.isHidden = true
        
        return cell
    }
}
///


/// 코드블록 9-7-3

extension BestFriendsTableViewController {
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let friend: Person = Person.bestFriends[indexPath.row]
            Person.removeBestFriend(friend) { (isSuccess: Bool) in
                if isSuccess {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
///


/// 코드블록 9-7-4

// MARK: - Table view delegate
extension BestFriendsTableViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "showFriendInfo", sender: cell)
        }
    }
}
///


/// 코드블록 9-7-5

// MARK: - Navigation
extension BestFriendsTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showFriendInfo" else { return }
        
        guard let cell: FriendTableViewCell = sender as? FriendTableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard index.row < Person.bestFriends.count else { return }
        
        guard let friendViewController: FriendViewController =
            segue.destination as? FriendViewController else {
                return
        }
        
        let friend: Person = Person.bestFriends[index.row]
        friendViewController.friend = friend
        friendViewController.thumbnailImage = cell.profileImageView.image
    }
}
///
