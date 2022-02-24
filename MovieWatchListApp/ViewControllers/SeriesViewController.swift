import UIKit


class SeriesController : UIViewController, SearchFilterDelegate, UpdateTableData {

    var series = TableSeriesModel()
    var copySeries = TableSeriesModel()
    var filter = SearchFilter(title: nil, genre: nil, isApplied: false)
    
    @IBOutlet weak var seriesTableView: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        seriesTableView.tableFooterView = UIView(frame: .zero)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ChangeDetection.seriesChange == true {
            getSeries()
            ChangeDetection.seriesChange = false
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openSeriesDetails" {
                    if let next = segue.destination as! SerieDetailViewController? {
                        next.details = sender as? Details
                        next.delegate = self
                            }
            }
            if segue.identifier == "openSearchBox" {
                if let next = segue.destination as! SearchModalViewController? {
                    next.isMovie = sender as? Bool
                    next.delegate = self
                    }
        }
    }
    func updateFilter(searchFilter: SearchFilter) {
        filter.isApplied = true
        copySeries.listOfSeries = series.listOfSeries
        var filteredSeries = [SeriesGroup](repeating: SeriesGroup(category: "", isExpanded: true, series: []), count: series.listOfSeries.count)
        var index = 0
        series.listOfSeries.forEach { series in
            filteredSeries[index].category = series.category
            filteredSeries[index].isExpanded = series.isExpanded
            filteredSeries[index].series =  series.series.filter { s in
                (searchFilter.title == nil || s.name.contains(searchFilter.title ?? ""))
                    && ( searchFilter.genre == nil || (s.genresIDs!.contains(searchFilter.genre ?? -1)))
            }
            index = index + 1
        }
        series.listOfSeries = filteredSeries
        searchButton.image = UIImage(systemName: "xmark")
        seriesTableView.reloadData()
    }
    func updateCategory(section: Int, row: Int, newCategory: String) -> (Int, Int) {
        let seriesToUpdate = series.listOfSeries[section].series[row]
        UserService.shared.updateSeries(series: seriesToUpdate, category: Category.init(rawValue: newCategory)!, rating: seriesToUpdate.myRating, episode: seriesToUpdate.episode, season: seriesToUpdate.season)
        let newSectionAndRow = series.switchCategory(section: section, row: row, newCategory: newCategory)
        seriesTableView.reloadData()
        return newSectionAndRow
    }
    
    func updateRaiting(section: Int, row: Int, newRaiting: String) {
        let seriesToUpdate = series.listOfSeries[section].series[row]
        UserService.shared.updateSeries(series: seriesToUpdate, category: Category.init(rawValue: seriesToUpdate.category!)!, rating: Int.init(newRaiting)!, episode: seriesToUpdate.episode, season: seriesToUpdate.season)
        series.updateRaiting(section: section, row: row, newRaiting: newRaiting)
        seriesTableView.reloadData()
    }
    @IBAction func searchButtonClicked(_ sender: Any) {
        if filter.isApplied == false {
            performSegue(withIdentifier: "openSearchBox", sender: false)
        }
        else {
            filter.isApplied = false
            filter.genre = nil
            filter.title = nil
            searchButton.image = UIImage(systemName: "magnifyingglass")
            series.listOfSeries = copySeries.listOfSeries
            seriesTableView.reloadData()
        }
    }
    private func getSeries() {
        series.removeAllSeries()
        UserService.shared.getAllSeries()
        UserService.shared.completionHandlerSeries { [weak self] seriesResult, status, message in
            if status {
                guard let self = self else {return}
                guard let _series = seriesResult else {return}
                _series.forEach { serie in
                    switch serie.category {
                    case "Watched":
                        self.series.listOfSeries[1].series.append(serie)
                        break
                    case "Watching":
                        self.series.listOfSeries[0].series.append(serie)
                        break
                    case "Plan to watch":
                        self.series.listOfSeries[2].series.append(serie)
                        break
                    default:
                        break
                    }
                }
                self.seriesTableView.reloadData()
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
        let series = series.listOfSeries[indexPath.section].series[indexPath.row]
        cell.serieTitle.text = series.name
        var rating = series.myRating == 0 ? "-" : series.myRating.description
        rating.append("/10⭐️")
        cell.serieRaiting.text = rating
        if indexPath.section == 0 {
            var nextEpisodeText = "Next episode will air on: "
            nextEpisodeText.append(series.nextAirDate)
            cell.serieNextEpisode.text = nextEpisodeText
        }
        else{
            cell.serieNextEpisode.isHidden = true
        }
        cell.serieImage.load(url: series.posterURL)
        if indexPath.section == 0 {
            var myEpsiode = "Episode to watch: "
            myEpsiode.append(series.episode.description)
            cell.serieEpisode.text = myEpsiode
        }
        else {
            cell.serieEpisode.isHidden = true
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seriesId = series.listOfSeries[indexPath.section].series[indexPath.row].seriesId
        //GET MOVIE FROM API BY ID
        SeriesService.shared.getSeries(id: seriesId)
        SeriesService.shared.completionHandlerDetails { [weak self] (series,status,message) in
                               if status {
                                   guard let self = self else {return}
                                   guard let _series = series else {return}
                                let serieFromTable = self.series.listOfSeries[indexPath.section].series[indexPath.row]
                                var episodeDuration = 0
                                if _series.runtime != nil {
                                    episodeDuration = _series.runtime![0]
                                }
                                var details = Details(title: _series.name, image: _series.posterURL, myRaiting: serieFromTable.myRating, raiting: _series.rating, summary: _series.summary, releaseDate: _series.releaseDate ?? "", genre: [], duration: episodeDuration, category: serieFromTable.category, section: indexPath.section, row: indexPath.row)
                                _series.genres?.forEach({ genre in
                                    details.genre.append(genre.name)
                                })
                                self.performSegue(withIdentifier: "openSeriesDetails", sender: details)
                               }
        }
    }
    
    private func handleIncrementEpisode(section: Int, row: Int) {
        let seriesToUpdate = series.listOfSeries[section].series[row]
        UserService.shared.updateSeries(series: seriesToUpdate, category: Category.watching, rating: seriesToUpdate.myRating, episode: seriesToUpdate.episode + 1, season: seriesToUpdate.season)
        seriesTableView.reloadData()
    }
    private func handleRemove(section: Int, row: Int) {
        UserService.shared.deleteSeries(series: series.listOfSeries[section].series[row])
        series.remove(section: section, row: row)
        
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath(row: row, section: section))
        seriesTableView.deleteRows(at: indexPaths, with: .fade)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "➕\n1 ep.") { [weak self] (action, view, completitionHandler) in
            self?.handleIncrementEpisode(section: indexPath.section, row: indexPath.row)
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

