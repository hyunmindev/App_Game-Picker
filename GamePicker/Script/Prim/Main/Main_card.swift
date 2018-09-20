import UIKit
import Firebase

class Main_card: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var CardView: UICollectionView!
    
    @objc  func swiped(_ gesture: UISwipeGestureRecognizer) { // 스와이프
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 {
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    lazy var refreshControl : UIRefreshControl = { // 새로고침
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.actualizerData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func actualizerData(_ refreshControl : UIRefreshControl){ // 새로고침 실행 함수
        // 여기에 실행할것 입력 새로고침시;
        self.CardView.reloadData()
        refreshControl.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 스와이프 제스쳐 추가
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)

        self.CardView.addSubview(self.refreshControl)
        // 뷰 진입시 로그인 체크하는 것임--------
        if Auth.auth().currentUser == nil {
            guard let login = self.storyboard?.instantiateViewController(withIdentifier: "Login") else {return}
            self.present(login, animated: true)
        }
        // 뷰 진입시 로그인 체크하는 것임--------
        
        let left_but = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        left_but.setImage(UIImage.init(named:"icon_white"), for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: left_but)
    }
    
    let game_title_array = ["first","second","third","fourth"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { // 섹션 개수
           return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // 섹션별 셀 수
        if section == 0 { return 1 }
        else { return 4 }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{ // 섹션별 셀 높이
        if indexPath.section == 0 {
            return CGSize(width: view.frame.size.width - 30, height: 150)
        } else {
            return CGSize(width: view.frame.size.width - 30, height: 380)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 { // 메세지 카드
            let message_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "message_card", for: indexPath) as! Message_cell
            
            message_cell.message_title.text = "질문을 할까요?"
            message_cell.message_text.text = "안녕하십니까?"
            message_cell.message_confirm.text = "설정하러 가기!"
            
            //사실 여기는 카드뷰로 만드는 영역임
            message_cell.contentView.layer.cornerRadius = 4.0
            message_cell.contentView.layer.borderWidth = 1.0
            message_cell.contentView.layer.borderColor = UIColor.clear.cgColor
            message_cell.contentView.layer.masksToBounds = false
            message_cell.layer.shadowColor = UIColor.gray.cgColor
            message_cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            message_cell.layer.shadowRadius = 6.0
            message_cell.layer.shadowOpacity = 1.0
            message_cell.layer.masksToBounds = false
            message_cell.layer.shadowPath = UIBezierPath(roundedRect: message_cell.bounds, cornerRadius: message_cell.contentView.layer.cornerRadius).cgPath
            
            return message_cell
            
        } else { // 게임 카드
            let game_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "game_card", for: indexPath) as! Main_cell
            
            game_cell.game_name.text = game_title_array[indexPath.row]
            
            //사실 여기는 카드뷰로 만드는 영역임
            game_cell.contentView.layer.cornerRadius = 4.0
            game_cell.contentView.layer.borderWidth = 1.0
            game_cell.contentView.layer.borderColor = UIColor.clear.cgColor
            game_cell.contentView.layer.masksToBounds = false
            game_cell.layer.shadowColor = UIColor.gray.cgColor
            game_cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            game_cell.layer.shadowRadius = 4.0
            game_cell.layer.shadowOpacity = 1.0
            game_cell.layer.masksToBounds = false
            game_cell.layer.shadowPath = UIBezierPath(roundedRect: game_cell.bounds, cornerRadius: game_cell.contentView.layer.cornerRadius).cgPath
            
            return game_cell
        }
    }
    
}
