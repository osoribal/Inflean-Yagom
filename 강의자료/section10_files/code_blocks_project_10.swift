import UIKit

/// 코드블록 10-1-1

let userDidSelectFilterNotificationName: Notification.Name = Notification.Name("UserDidSelectFilterNotification")
let userInfoKeyFilterName: String = "filterName"
///


/// 코드블록 10-1-2

class AlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 5.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
}
///


/// 코드블록 10-1-3

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Properties
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
///


/// 코드블록 10-1-4

class PhotoViewController: UIViewController {
    // MARK:- Properties
    // MARK: IBOutlets
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resetFilterButton: UIBarButtonItem!
    @IBOutlet weak var saveImageButton: UIBarButtonItem!
}
///


/// 코드블록 10-1-5

extension PhotoViewController {
    
    // MARK:- IBActions
    @IBAction func tapAssetImage(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func touchUpResetFilterButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func touchUpSaveImageButton(_ sender: UIBarButtonItem) {
    }
}
///


/// 코드블록 10-1-6

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Properties
    override var isSelected: Bool {
        didSet {
            self.imageView.layer.borderWidth = isSelected ? 4.0 : 0
            self.imageView.alpha = isSelected ? 0.7 : 1.0
            super.isSelected = isSelected
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
}
///



/// 코드블록 10-1-7

extension FilterCollectionViewCell {
    
    // MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.filterNameLabel.layer.shadowColor = UIColor.black.cgColor
        filterNameLabel.layer.shadowRadius = 3.0
        filterNameLabel.layer.shadowOpacity = 1.0
        filterNameLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        filterNameLabel.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.imageView.layer.borderWidth = 0
        self.imageView.alpha = 1.0
        self.filterNameLabel.text = nil
    }
}
///


/// 코드블록 10-1-8

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


/// 코드블록 10-3-1
import Photos

class AlbumCollectionViewController: UICollectionViewController {
    
    // MARK:- Properties
    private var fetchResult: PHFetchResult<PHAsset>?
    private var albums: [PHAssetCollection]?
    private let cellReuseIdentifier: String = "albumCell"
    private lazy var cachingImageManager: PHCachingImageManager = { PHCachingImageManager() }()
}
///



/// 코드블록 10-3-2

extension AlbumCollectionViewController {
    
    /// 시스템 앨범
    private var systemAlbums: [PHAssetCollection]? {
        var albumList: [PHAssetCollection] = [PHAssetCollection]()
        
        // 카메라 롤
        if let cameraRoll: PHAssetCollection =
            PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum,
                                                    subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary,
                                                    options: nil).firstObject {
            albumList.append(cameraRoll)
        }
        
        // 셀카
        if let selfieAlbum: PHAssetCollection =
            PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum,
                                                    subtype: PHAssetCollectionSubtype.smartAlbumSelfPortraits,
                                                    options: nil).firstObject {
            albumList.append(selfieAlbum)
        }
        
        // 즐겨찾는 사진
        if let favoriteAlbum: PHAssetCollection =
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                    subtype: .smartAlbumFavorites,
                                                    options: nil).firstObject {
            albumList.append(favoriteAlbum)
        }
        
        return albumList
    }
}
///


/// 코드블록 10-3-3

extension AlbumCollectionViewController {
    
    /// 사용자 생성 앨범
    private var userAlbums: [PHAssetCollection]? {
        var albumList: [PHAssetCollection] = [PHAssetCollection]()
        
        let userAlbums: PHFetchResult<PHCollection>
        userAlbums = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        
        for index in 0..<userAlbums.count {
            if let collection: PHAssetCollection =
                userAlbums.object(at: index) as? PHAssetCollection {
                
                albumList.append(collection)
            }
        }
        
        return albumList
    }
}
///



/// 코드블록 10-3-4

extension AlbumCollectionViewController {
    
    /// 시스템 앨범 + 사용자 앨범 불러오기
    private func loadAllAlbums() {
        self.fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        guard let systemAlbums = self.systemAlbums else { return }
        guard let userAlbums = self.userAlbums else { return }
        
        let albumList: [PHAssetCollection] = systemAlbums + userAlbums
        
        // 에셋이 존재하는 에셋 콜렉션만 필터링
        self.albums = albumList.filter { (collection: PHAssetCollection) -> Bool in
            PHAsset.fetchAssets(in: collection, options: nil).count > 0
        }
        
        OperationQueue.main.addOperation {
            self.collectionView?.reloadSections(IndexSet(0...0))
        }
    }
}
///



/// 코드블록 10-3-5

extension AlbumCollectionViewController {
    
    /// 사진첩 접근 권한 확인
    private func requestAlbumAuth() {
        
        let requestHandler = { (status: PHAuthorizationStatus) in
            switch status {
            case PHAuthorizationStatus.authorized:  self.loadAllAlbums()
            case PHAuthorizationStatus.denied:      print("사진첩 접근 거부됨")
            default: break
            }
        }
        
        switch PHPhotoLibrary.authorizationStatus() {
        case PHAuthorizationStatus.authorized:      self.loadAllAlbums()
        case PHAuthorizationStatus.denied:          print("사진첩 접근 거부됨")
        case PHAuthorizationStatus.restricted:      print("사집첩 접근 불가")
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization(requestHandler)
        }
    }
}
///


/// 코드블록 10-3-6

extension AlbumCollectionViewController {
    
    private func configureCell(_ cell: AlbumCollectionViewCell,
                               collectionView: UICollectionView,
                               indexPath: IndexPath) {
        
        guard let collection: PHAssetCollection = self.albums?[indexPath.item]
            else { return }
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection,
                                                             options: nil)
        
        guard let asset: PHAsset = fetchResult.lastObject else { return }
        
        cell.titleLabel.text = collection.localizedTitle
        cell.countLabel.text = "\(fetchResult.count)"
        
        let manager: PHCachingImageManager = self.cachingImageManager
        let handler: (UIImage?, [AnyHashable:Any]?) -> Void = { image, _ in
            
            let cellAtIndex: UICollectionViewCell? = collectionView.cellForItem(at: indexPath)
            guard let cell: AlbumCollectionViewCell = cellAtIndex as? AlbumCollectionViewCell
                else { return }
            
            cell.imageView.image = image
        }
        
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 200, height: 200),
                             contentMode: PHImageContentMode.aspectFill,
                             options: nil,
                             resultHandler: handler)
    }
}
///


/// 코드블록 10-3-7

extension AlbumCollectionViewController {
    
    // MARK:- UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.albums?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AlbumCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier,
                                                  for: indexPath) as! AlbumCollectionViewCell
        
        self.configureCell(cell, collectionView: collectionView, indexPath: indexPath)
        
        return cell
    }
}
///


/// 코드블록 10-3-8

extension AlbumCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout: UICollectionViewFlowLayout =
            self.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero}
        
        let numberOfCellsInRow: CGFloat = 2
        let viewSize: CGSize = self.view.frame.size
        let sectionInset: UIEdgeInsets = flowLayout.sectionInset
        
        let interitemSpace: CGFloat = flowLayout.minimumInteritemSpacing * (numberOfCellsInRow - 1)
        
        var itemWidth: CGFloat
        itemWidth = viewSize.width - sectionInset.left - sectionInset.right - interitemSpace
        itemWidth /= numberOfCellsInRow
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        
        return itemSize
    }
}
///


/// 코드블록 10-3-9

extension AlbumCollectionViewController: PHPhotoLibraryChangeObserver {
    
    // MARK:- Reset Cache
    private func resetCachedAssets() {
        self.cachingImageManager.stopCachingImagesForAllAssets()
    }
    
    // MARK:- PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetchResult = fetchResult else { return }
        
        DispatchQueue.main.sync {
            guard let _ = changeInstance.changeDetails(for: fetchResult)
                else { return }
            
            self.resetCachedAssets()
            self.loadAllAlbums()
            self.collectionView?.reloadSections(IndexSet(0...0))
        }
    }
}
///


/// 코드블록 10-3-10

extension AlbumCollectionViewController  {
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestAlbumAuth()
        
        // 사진 라이브러리 변경을 감지할 수 있도록 등록
        PHPhotoLibrary.shared().register(self)
    }
}
///


/// 코드블록 10-3-11

// MARK:- Life Cycle
deinit {
    // 사진 라이브러리 변경 감지 중단을 위해 등록 해제
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
}
///


/// 코드블록 10-4-1
import Photos

class PhotoCollectionViewController: UICollectionViewController {
    
    // MARK:- Properties
    var fetchResult: PHFetchResult<PHAsset>? {
        didSet {
            OperationQueue.main.addOperation {
                self.collectionView?.reloadSections(IndexSet(0...0))
            }
        }
    }
    var assetCollection: PHAssetCollection?
    
    // MARK: Privates
    private let cellReuseIdentifier: String = "photoCell"
    private lazy var cachingImageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
}
///


/// 코드블록 10-4-2

extension AlbumCollectionViewController {
    
    // MARK:- Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? PhotoCollectionViewController,
            let cell: AlbumCollectionViewCell = sender as? AlbumCollectionViewCell,
            let indexPath: IndexPath = collectionView?.indexPath(for: cell)
            else { return }
        
        guard let assetCollection: PHAssetCollection = self.albums?[indexPath.item]
            else { return }
        
        destination.title = cell.titleLabel?.text
        
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: true)]
        OperationQueue().addOperation {
            
            destination.fetchResult = PHAsset.fetchAssets(in: assetCollection,
                                                          options: fetchOptions)
            
            destination.assetCollection = assetCollection
        }
    }
}
///


/// 코드블록 10-4-3

extension PhotoCollectionViewController {
    
    private func configureCell(_ cell: PhotoCollectionViewCell,
                               collectionView: UICollectionView,
                               indexPath: IndexPath) {
        
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.item) else { return }
        
        let manager: PHCachingImageManager = self.cachingImageManager
        let handler: (UIImage?, [AnyHashable:Any]?) -> Void = { image, _ in
            
            let cellAtIndex: UICollectionViewCell? = collectionView.cellForItem(at: indexPath)
            
            guard let cell: PhotoCollectionViewCell = cellAtIndex as? PhotoCollectionViewCell
                else { return }
            
            cell.imageView.image = image
        }
        
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 100, height: 100),
                             contentMode: PHImageContentMode.aspectFill,
                             options: nil,
                             resultHandler: handler)
    }
}
///


/// 코드블록 10-4-4

// MARK:- UICollectionViewDataSource
extension PhotoCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.fetchResult?.count ?? 0
    }
}
///


/// 코드블록 10-4-5

extension PhotoCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PhotoCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier,
                                                  for: indexPath) as! PhotoCollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        guard let cell: PhotoCollectionViewCell = cell as? PhotoCollectionViewCell else {
            return
        }
        
        self.configureCell(cell, collectionView: collectionView, indexPath: indexPath)
    }
}
///


/// 코드블록 10-4-6

// MARK:- UICollectionViewDelegateFlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout: UICollectionViewFlowLayout =
            self.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero}
        
        let numberOfCellsInRow: CGFloat = 4
        let viewSize: CGSize = self.view.frame.size
        let sectionInset: UIEdgeInsets = flowLayout.sectionInset
        
        let interitemSpace: CGFloat = flowLayout.minimumInteritemSpacing * (numberOfCellsInRow - 1)
        
        var itemWidth: CGFloat
        itemWidth = viewSize.width - sectionInset.left - sectionInset.right - interitemSpace
        itemWidth /= numberOfCellsInRow
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
}
///


/// 코드블록 10-4-7

extension PhotoCollectionViewController {
    private func updateCollectionView(with changes: PHFetchResultChangeDetails<PHAsset>) {
        guard let collectionView = self.collectionView else { return }
        
        // 업데이트는 삭제, 삽입, 다시 불러오기, 이동 순으로 진행합니다
        if let removed: IndexSet = changes.removedIndexes, removed.count > 0 {
            collectionView.deleteItems(at: removed.map({
                IndexPath(item: $0, section: 0)
            }))
        }
        
        if let inserted: IndexSet = changes.insertedIndexes, inserted.count > 0 {
            collectionView.insertItems(at: inserted.map({
                IndexPath(item: $0, section: 0)
            }))
        }
        
        if let changed: IndexSet = changes.changedIndexes, changed.count > 0 {
            collectionView.reloadItems(at: changed.map({
                IndexPath(item: $0, section: 0)
            }))
        }
        
        changes.enumerateMoves { fromIndex, toIndex in
            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                    to: IndexPath(item: toIndex, section: 0))
        }
    }
}
///


/// 코드블록 10-4-8

// MARK:- PHPhotoLibraryChangeObserver
extension PhotoCollectionViewController: PHPhotoLibraryChangeObserver {
    
    private func resetCachedAssets() {
        self.cachingImageManager.stopCachingImagesForAllAssets()
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetchResult: PHFetchResult<PHAsset> = self.fetchResult
            else { return }
        
        guard let changes: PHFetchResultChangeDetails<PHAsset> =
            changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        DispatchQueue.main.sync {
            self.resetCachedAssets()
            self.fetchResult = changes.fetchResultAfterChanges
            
            if changes.hasIncrementalChanges {
                self.updateCollectionView(with: changes)
            } else {
                self.collectionView?.reloadSections(IndexSet(0...0))
            }
        }
    }
}
///


/// 코드블록 10-4-9

extension PhotoCollectionViewController {
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 사진 라이브러리 변경을 감지할 수 있도록 등록
        PHPhotoLibrary.shared().register(self)
    }
}
///


/// 코드블록 10-4-10

// MARK:- Life Cycle
deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
}
///


/// 코드블록 10-5-1
import Photos

class PhotoViewController: UIViewController {
    // MARK:- Properties
    var asset: PHAsset?
    var assetCollection: PHAssetCollection?
    
    // MARK: IBOutlets
    @IBOutlet weak var assetImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resetFilterButton: UIBarButtonItem!
    @IBOutlet weak var saveImageButton: UIBarButtonItem!
    
    // MARK: Privates
    private var originalImage: UIImage?
    private let cachingImageManager: PHCachingImageManager = PHCachingImageManager()
    private let imageFilteringQueue: OperationQueue = OperationQueue()
    private lazy var filterCollectionViewController: FilterCollectionViewController? = {
        return self.childViewControllers.first as? FilterCollectionViewController
    }()
}
///


/// 코드블록 10-5-2

extension PhotoCollectionViewController {
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? PhotoViewController,
            let cell: PhotoCollectionViewCell = sender as? PhotoCollectionViewCell,
            let indexPath: IndexPath = collectionView?.indexPath(for: cell)
            else { return }
        
        destination.asset = fetchResult?.object(at: indexPath.item)
        destination.assetCollection = self.assetCollection
    }
}
///


/// 코드블록 10-5-3

extension PhotoViewController {
    
    private func changeImageViewMode() {
        guard let isNavigationBarHidden: Bool = self.navigationController?.isNavigationBarHidden
            else { return }
        
        self.navigationController?.isNavigationBarHidden = !isNavigationBarHidden
        self.view.backgroundColor = isNavigationBarHidden ? UIColor.white : UIColor.black
        self.containerView.isHidden = !self.containerView.isHidden
    }
}
///


/// 코드블록 10-5-4

extension PhotoViewController {
    private func alertSaveResult(success: Bool, error: Error?) {
        let alert: UIAlertController
        let alertMessage: String
        
        if success {
            alertMessage = "카메라 롤에 저장하였습니다."
        } else {
            alertMessage = "사진저장에 실패했습니다. " + (error?.localizedDescription ?? "")
        }
        
        alert = UIAlertController(title: "알림",
                                  message: alertMessage,
                                  preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "확인",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        
        OperationQueue.main.addOperation {
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
}
///


/// 코드블록 10-5-5

extension PhotoViewController {
    
    // MARK:- IBActions
    @IBAction func tapAssetImage(_ sender: UITapGestureRecognizer) {
        self.changeImageViewMode()
    }
    
    @IBAction func touchUpResetFilterButton(_ sender: UIBarButtonItem) {
        self.assetImageView.image = self.originalImage
        sender.isEnabled = false
        self.saveImageButton.isEnabled = false
    }
    
    @IBAction func touchUpSaveImageButton(_ sender: UIBarButtonItem) {
        
        guard let filteredImage: UIImage = self.assetImageView.image else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: filteredImage)
        }, completionHandler: self.alertSaveResult(success:error:))
    }
}
///


/// 코드블록 10-5-6

// MARK: - UIScrollViewControllerDelegate
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.assetImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView,
                                    with view: UIView?) {
        
        if self.navigationController?.isNavigationBarHidden == false {
            self.changeImageViewMode()
        }
    }
}
///


/// 코드블록 10-5-7

// MARK: PHPhotoLibraryChangeObserver
extension PhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset: PHAsset = self.asset else {
            return
        }
        guard let changes = changeInstance.changeDetails(for: asset)
            else { return }
        
        DispatchQueue.main.sync {
            if changes.objectWasDeleted {
                self.navigationController?.popViewController(animated: true)
            } else if let after = changes.objectAfterChanges {
                self.asset = after
            }
        }
    }
}
///


/// 코드블록 10-5-8

extension PhotoViewController {
    private func adjustFilter(name filterName: String) {
        imageFilteringQueue.addOperation {
            guard let inputImage: UIImage = self.originalImage else { return }
            guard let filter: CIFilter = CIFilter(name: filterName) else { return }
            guard let ciImage: CIImage = CIImage(image: inputImage) else {return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            guard let outputImage: CIImage = filter.outputImage else { return }
            let context: CIContext = CIContext(options: nil)
            guard let cgImage: CGImage = context.createCGImage(outputImage,
                                                               from: outputImage.extent)
                else { return }
            let filteredImage: UIImage = UIImage(cgImage: cgImage)
            
            OperationQueue.main.addOperation {
                self.assetImageView.image = filteredImage
                self.resetFilterButton.isEnabled = true
                self.saveImageButton.isEnabled = true
            }
        }
    }
}
///


/// 코드블록 10-5-9

extension PhotoViewController {
    @objc private func didRecieveUserDidSelectFilterNotification(_ noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let filterName: String = userInfo[userInfoKeyFilterName] as? String
            else { return }
        self.adjustFilter(name: filterName)
    }
}
///


/// 코드블록 10-5-10

extension PhotoViewController {
    
    // MARK:- Methods
    private func setUpImageView() {
        
        guard let asset: PHAsset = self.asset else {
            return
        }
        
        let originalAssetImageSize: CGSize
        originalAssetImageSize = CGSize(width: asset.pixelWidth,
                                        height: asset.pixelHeight)
        
        let manager: PHCachingImageManager = self.cachingImageManager
        manager.requestImage(for: asset,
                             targetSize: originalAssetImageSize,
                             contentMode: PHImageContentMode.aspectFill,
                             options: nil,
                             resultHandler: { image, _ in
                                self.assetImageView.image = image
                                self.originalImage = image
        })
    }
}
///


/// 코드블록 10-5-11

extension PhotoViewController {
    
    private func setUpNavigationTitle() {
        
        guard let asset: PHAsset = self.asset else {
            return
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        guard let createdDate: Date = asset.creationDate else {return}
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = UIColor.clear
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.numberOfLines = 1
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        dateLabel.textColor = UIColor.black
        dateLabel.text = dateFormatter.string(from: createdDate)
        
        dateFormatter.dateFormat = "a hh:mm:ss"
        
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.numberOfLines = 1
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        timeLabel.textColor = UIColor.black
        timeLabel.text = dateFormatter.string(from: createdDate)
        
        titleView.addSubview(dateLabel)
        titleView.addSubview(timeLabel)
        
        dateLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
}
///


/// 코드블록 10-5-12
import Photos

class FilterCollectionViewController: UICollectionViewController {
    
    // MARK:- Properties
    var photoAsset: PHAsset? {
        didSet {
            guard let asset = photoAsset else { return }
            
            let manager: PHCachingImageManager = self.cachingImageManager
            manager.requestImage(for: asset,
                                 targetSize: CGSize(width: 200, height: 200),
                                 contentMode: PHImageContentMode.aspectFill,
                                 options: nil,
                                 resultHandler: { image, _ in
                                    self.thumbnailImage = image })
        }
    }
    
    // MARK: Privates
    private var thumbnailImage: UIImage? {
        didSet {
            self.collectionView?.reloadSections(IndexSet(0...0))
        }
    }
    private let cellReuseIdentifier: String = "filterCell"
    private let cachingImageManager: PHCachingImageManager = PHCachingImageManager()
    private let imageOperationQueue: OperationQueue = OperationQueue()
    private var filteredImageChache: [String:UIImage] = [:]
}
///


/// 코드블록 10-5-13

extension PhotoViewController {
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpImageView()
        self.setUpNavigationTitle()
        
        PHPhotoLibrary.shared().register(self)
        
        self.filterCollectionViewController?.photoAsset = asset
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRecieveUserDidSelectFilterNotification(_:)),
                                               name: userDidSelectFilterNotificationName,
                                               object: nil)
    }
}
///


/// 코드블록 10-5-14

// MARK:- Life Cycle
deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
    NotificationCenter.default.removeObserver(self)
}
///


/// 코드블록 10-6-1

extension FilterCollectionViewController {
    private var imageFilterNames: [String] {
        return ["CIPhotoEffectChrome",
                "CIPhotoEffectFade",
                "CIPhotoEffectInstant",
                "CIPhotoEffectMono",
                "CIPhotoEffectNoir",
                "CIPhotoEffectProcess",
                "CIPhotoEffectTonal",
                "CIPhotoEffectTransfer",
                "CISepiaTone",
                "CIVignette"]
    }
}
///


/// 코드블록 10-6-2

extension FilterCollectionViewController {
    
    private func adjustFilter(name filterName: String,
                              for indexPath: IndexPath,
                              cell: FilterCollectionViewCell) {
        
        if let filteredImage: UIImage = self.filteredImageChache[filterName] {
            cell.imageView.image = filteredImage; return;
        }
        
        self.imageOperationQueue.addOperation {
            guard let inputImage: UIImage = self.thumbnailImage else { return }
            guard let filter: CIFilter = CIFilter(name: filterName) else { return }
            guard let ciImage: CIImage = CIImage(image: inputImage) else {return }
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            guard let outputImage: CIImage = filter.outputImage else { return }
            let context: CIContext = CIContext(options: nil)
            guard let cgImage: CGImage = context.createCGImage(outputImage,
                                                               from: outputImage.extent)
                else { return }
            let filteredImage: UIImage = UIImage(cgImage: cgImage)
            self.filteredImageChache[filterName] = filteredImage
            
            OperationQueue.main.addOperation {
                
                let cellAtIndex: UICollectionViewCell? =
                    self.collectionView?.cellForItem(at: indexPath)
                
                guard let cell: FilterCollectionViewCell = cellAtIndex
                    as? FilterCollectionViewCell else { return }
                
                cell.imageView.image = filteredImage
            }
        }
    }
}
///


/// 코드블록 10-6-3

// MARK:- UICollectionViewDataSource
extension FilterCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.imageFilterNames.count
    }
}
///


/// 코드블록 10-6-4

extension FilterCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: FilterCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier,
                                                  for: indexPath) as! FilterCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        guard let cell: FilterCollectionViewCell = cell as? FilterCollectionViewCell
            else { return }
        
        let filterName: String = self.imageFilterNames[indexPath.item]
        
        cell.filterNameLabel.text = filterName
        
        self.adjustFilter(name: filterName, for: indexPath, cell: cell)
    }
}
///


/// 코드블록 10-6-5

// MARK:- UICollectionViewDelegateFlowLayout
extension FilterCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout: UICollectionViewFlowLayout =
            self.collectionViewLayout as? UICollectionViewFlowLayout
            else { return CGSize.zero}
        
        let viewSize: CGSize = self.view.frame.size
        let sectionInset: UIEdgeInsets = flowLayout.sectionInset
        let itemHeight: CGFloat = viewSize.height - sectionInset.top - sectionInset.bottom
        let itemSize = CGSize(width: itemHeight, height: itemHeight)
        
        return itemSize
    }
}
///


/// 코드블록 10-6-6

// MARK:- UICollectionViewDelegate
extension FilterCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        let userInfo: [String: Any]
        userInfo = [userInfoKeyFilterName:self.imageFilterNames[indexPath.item]]
        
        NotificationCenter.default.post(name: userDidSelectFilterNotificationName,
                                        object: nil,
                                        userInfo: userInfo)
    }
}
///

