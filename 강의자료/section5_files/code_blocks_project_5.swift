import UIKit

/// 코드블록 5-4-1

// MARK: IBOutlets
@IBOutlet var animalImageView: UIImageView!
@IBOutlet var nameLabel: UILabel!
@IBOutlet var descriptionTextView: UITextView!
///


/// 코드블록 5-4-2

// MARK: - Properties
@IBOutlet var descriptionTextView: UITextView!
///


/// 코드블록 5-4-3

// MARK: - Methods
@IBAction func touchUpInsideDismissButton(_ sender: UIButton) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
}
///


/// 코드블록 5-4-4

override func viewDidLoad() {
    super.viewDidLoad()
    
    self.descriptionTextView.text = """
    안녕하세요 야곰입니다.
    제 애플리케이션을 이용해 주셔서 고맙습니다.
    제 블로그 주소는 http://blog.yagom.net 입니다.
    자주자주 놀러오세요 :D
    """
}
///


/// 코드블록 5-5-1
import UIKit

struct AnimalInfo: Codable {
    let name: String
    let animalDescription: String
    var imageName: String
}
///


/// 코드블록 5-5-2
static func decode(from assetName: String) -> AnimalInfo? {
    guard let asset: NSDataAsset = NSDataAsset(name: assetName) else {
        print("에셋 로드 실패")
        return nil
    }
    
    do {
        let decoder: PropertyListDecoder = PropertyListDecoder()
        return try decoder.decode(AnimalInfo.self, from: asset.data)
    } catch {
        print("데이터 디코딩 실패")
        print(error.localizedDescription)
        return nil
    }
}
///


/// 코드블록 5-6-1

// MARK: - Nested Type
private enum ButtonTag: Int {
    case dog = 101
    case cat, rabbit, hedgehog
}
///


/// 코드블록 5-6-2
// MARK: Privates
private func animalInfo(for tag: ButtonTag) -> AnimalInfo? {
    
    let assetName: String
    
    switch tag {
    case ButtonTag.dog:
        assetName = "Dog"
    case ButtonTag.cat:
        assetName = "Cat"
    case ButtonTag.rabbit:
        assetName = "Rabbit"
    case ButtonTag.hedgehog:
        assetName = "Hedgehog"
    }
    
    return AnimalInfo.decode(from: assetName)
}
///


/// 코드블록 5-6-3

guard let button: UIButton = sender as? UIButton else { return }

guard let nextViewController: DescriptionViewController = segue.destination as? DescriptionViewController else { return }

guard let tag: ButtonTag = ButtonTag(rawValue: button.tag) else {
    print("버튼의 태그를 enum으로 변경불가")
    return
}

guard let info: AnimalInfo = self.animalInfo(for: tag) else { return }

///


/// 코드블록 5-6-4

// MARK: - Properties
var animalInfo: AnimalInfo!
///


/// 코드블록 5-6-5
nextViewController.animalInfo = info
///


/// 코드블록 5-6-6

// MARK: - Methods
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.animalInfo.name
    self.animalImageView.image = UIImage(named: self.animalInfo.imageName)
    self.nameLabel.text = self.animalInfo.name
    self.descriptionTextView.text = self.animalInfo.animalDescription
}
///
