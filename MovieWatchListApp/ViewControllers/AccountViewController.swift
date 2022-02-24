import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var summaryBackgroundView: UIView!
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var moviesWatched: UILabel!
    @IBOutlet weak var seriesWatched: UILabel!
    @IBOutlet weak var topRatingMovies: UILabel!
    @IBOutlet weak var topRatingSeries: UILabel!
    
    let settings = Setting.getSettingsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        settingsTable.tableFooterView = UIView(frame: .zero)
        settingsTable.backgroundColor = UIColor.clear
        summaryBackgroundView.layer.cornerRadius = 20
        UserService.shared.getAllMovies()
        UserService.shared.completionHandlerMovies { [weak self] moviesResult, status, message in
            if status {
                guard let self = self else {return}
                guard let _movies = moviesResult else {return}
                var counter = 0
                var topRatedCounter = 0
                _movies.forEach { movie in
                    if movie.category == "Watched" {
                        counter = counter + 1
                    }
                    if movie.myRating == 10 {
                        topRatedCounter = topRatedCounter + 1
                    }
                }
                self.moviesWatched.text = counter.description
                self.topRatingMovies.text = topRatedCounter.description
            }
        }
        UserService.shared.getAllSeries()
        UserService.shared.completionHandlerSeries { [weak self] seriesResult, status, message in
            if status {
                guard let self = self else {return}
                guard let _series = seriesResult else {return}
                var counter = 0
                var topRatedCounter = 0
                _series.forEach { serie in
                    if serie.category == "Watched" {
                        counter = counter + 1
                    }
                    if serie.myRating == 10 {
                        topRatedCounter = topRatedCounter + 1
                    }
                }
                self.seriesWatched.text = counter.description
                self.topRatingSeries.text = topRatedCounter.description
            }
        }
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
            settingCell.settingImage.image = UIImage(named: data.image)
            return settingCell
        }
        
        return SettingTableViewCell(style: .default, reuseIdentifier: "settingCell")
    }
    
    
}

extension AccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row].label == "Log out" {
            performSegue(withIdentifier: "logout", sender: nil)
        }
        else if settings[indexPath.row].label == "General" {
            performSegue(withIdentifier: "openGeneralSettings", sender: nil)
        }
        else if settings[indexPath.row].label == "About" {
            performSegue(withIdentifier: "openAboutSettings", sender: nil)
        }
    }
}


class GeneralSettingsViewController : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

class AboutSettingsViewController : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
