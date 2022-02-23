import UIKit


class SeriesController : UIViewController {
    var series = TableSeriesModel()
    
    @IBOutlet weak var seriesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        seriesTableView.tableFooterView = UIView(frame: .zero)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openSerieDetails" {
                    if let next = segue.destination as! SerieDetailViewController? {
                        next.details = sender as? Details
                            }
            }
    }
}

extension SeriesController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return series.listOfSeries.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        header.backgroundColor = .darkGray
        
        let expandCollapseButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        expandCollapseButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - 50, bottom: 0, right: 0)
        expandCollapseButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        expandCollapseButton.tintColor = .white
        expandCollapseButton.addTarget(self, action: #selector(handleExpandCollapse), for: .touchUpInside)
        expandCollapseButton.tag = section
        header.addSubview(expandCollapseButton)
        
        let category = UILabel(frame: CGRect(x: 10, y: 10, width: 250, height: 30))
        category.text = series.listOfSeries[section].category
        category.textColor = .white
        category.font = .systemFont(ofSize: 22, weight: .bold)
        header.addSubview(category)
        
        return header
    }
    
    @objc func handleExpandCollapse(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for movie in series.listOfSeries[section].series.indices {
            let indexPath = IndexPath(row: movie, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = series.listOfSeries[section].isExpanded
        series.listOfSeries[section].isExpanded = !isExpanded
        
        if isExpanded {
            seriesTableView.deleteRows(at: indexPaths, with: .fade)
        }
        else{
            seriesTableView.insertRows(at: indexPaths, with: .fade)
        }
        
        button.setImage(UIImage(systemName: isExpanded ? "chevron.right" : "chevron.down"), for: .normal)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !series.listOfSeries[section].isExpanded
        {
            return 0
        }
        return series.listOfSeries[section].series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serieCell", for: indexPath) as! SerieTableViewCell
        let moviesForCategory = series.listOfSeries[indexPath.section].series
        cell.serieTitle.text = moviesForCategory[indexPath.row].name
        var rating = moviesForCategory[indexPath.row].myRating.description
        rating.append("/10⭐️")
        cell.serieRaiting.text = rating
//        cell.movieImage.image = moviesForCategory[indexPath.row].posterImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serie = series.listOfSeries[indexPath.section].series[indexPath.row]
        //GET SERIES FROM API BY ID
//        let details = Details(title: mockMovie.title, image: "", myRaiting: mockMovie.myRaiting, raiting: mockMovie.rating, summary: mockMovie.summary, releaseDate: mockMovie.releaseDate!, genre: ["Action", "Comedy", "Horror"], length: 132, category: mockMovies.listOfMovies[indexPath.section].category, section: indexPath.section, row: indexPath.row)

        self.performSegue(withIdentifier: "openSerieDetails", sender: nil)
    }
    
    private func handleIncrementEpisode() {
        
    }
    private func handleRemove(section: Int, row: Int) {
        series.remove(section: section, row: row)
        
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath(row: row, section: section))
        seriesTableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "➕\n1 ep.") { [weak self] (action, view, completitionHandler) in
            self?.handleIncrementEpisode()
            completitionHandler(true)
        }
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "🗑Remove") { [weak self] (action, view, completitionHandler) in
            self?.handleRemove(section: indexPath.section, row: indexPath.row)
        completitionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

