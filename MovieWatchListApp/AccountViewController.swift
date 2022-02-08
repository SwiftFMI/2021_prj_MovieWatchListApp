import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var summaryBackgroundView: UIView!
    @IBOutlet weak var settingsTable: UITableView!
    
    let settings = Setting.getSettingsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        settingsTable.tableFooterView = UIView(frame: .zero)
        settingsTable.backgroundColor = UIColor.clear
        summaryBackgroundView.layer.cornerRadius = 20
    }


}

extension AccountViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = settings[indexPath.row]
        let cell: SettingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingTableViewCell
        if let settingCell = cell {
            settingCell.settingName.text = data.label
            settingCell.settingImage.image = UIImage(systemName: data.image)
            return settingCell
        }
        
        return SettingTableViewCell(style: .default, reuseIdentifier: "settingCell")
    }
    
    
}

extension AccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
