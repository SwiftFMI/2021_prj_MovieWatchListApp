import UIKit


extension UIView {
func addBackground() {
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    backgroundImageView.image = UIImage(named: "background.png")
    backgroundImageView.contentMode = UIView.ContentMode.scaleToFill

    self.addSubview(backgroundImageView)
    self.sendSubviewToBack(backgroundImageView)
}}

class MoviesViewController : UIViewController, SearchFilterDelegate, UpdateTableData {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var movies = TableMoviesModel()
    var filter = SearchFilter(title: nil, genre: nil, isApplied: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        moviesTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openMovieDetails" {
                    if let next = segue.destination as! MovieDetailViewController? {
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
        var filteredMovies = [Movies](repeating: Movies(category: "", isExpanded: true, movies: []), count: movies.listOfMovies.count)
        var index = 0
        movies.listOfMovies.forEach { movies in
            filteredMovies[index].category = movies.category
            filteredMovies[index].isExpanded = movies.isExpanded
            filteredMovies[index].movies =  movies.movies.filter { m in
                (searchFilter.title == nil || m.title.contains(searchFilter.title ?? ""))
                    && ( searchFilter.genre == nil || ((m.genresIDs?.contains(searchFilter.genre!)) != nil))
            }
            index = index + 1
        }
        movies.listOfMovies = filteredMovies
        filterButton.image = UIImage(systemName: "xmark")
        moviesTableView.reloadData()
    }
    func updateCategory(section: Int, row: Int, newCategory: String) -> (Int, Int) {
        let newSectionAndRow = movies.switchCategory(section: section, row: row, newCategory: newCategory)
        moviesTableView.reloadData()
        return newSectionAndRow
    }
    func updateRaiting(section: Int, row: Int, newRaiting: String) {
        movies.updateRaiting(section: section, row: row, newRaiting: newRaiting)
        moviesTableView.reloadData()
    }
    @IBAction func searchClicked(_ sender: Any) {
        if filter.isApplied == false {
            performSegue(withIdentifier: "openSearchBox", sender: true)
        }
        else {
            filter.isApplied = false
            filter.genre = nil
            filter.title = nil
            filterButton.image = UIImage(systemName: "magnifyingglass")
//            mockMovies.listOfMovies = getAllMoviesFrimDB();
//            moviesTableView.reloadData()
        }
        
    }
}

extension MoviesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.listOfMovies.count
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
        category.text = movies.listOfMovies[section].category
        category.textColor = .white
        category.font = .systemFont(ofSize: 22, weight: .bold)
        header.addSubview(category)
        
        return header
    }
    
    @objc func handleExpandCollapse(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for movie in movies.listOfMovies[section].movies.indices {
            let indexPath = IndexPath(row: movie, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = movies.listOfMovies[section].isExpanded
        movies.listOfMovies[section].isExpanded = !isExpanded
        
        if isExpanded {
            moviesTableView.deleteRows(at: indexPaths, with: .fade)
        }
        else{
            moviesTableView.insertRows(at: indexPaths, with: .fade)
        }
        
        button.setImage(UIImage(systemName: isExpanded ? "chevron.right" : "chevron.down"), for: .normal)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !movies.listOfMovies[section].isExpanded
        {
            return 0
        }
        return movies.listOfMovies[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MoviewTableViewCell
        let moviesForCategory = movies.listOfMovies[indexPath.section].movies
        cell.movieTitle.text = moviesForCategory[indexPath.row].title
        var rating = moviesForCategory[indexPath.row].myRating.description
        rating.append("/10⭐️")
        cell.movieRaiting.text = rating
//        cell.movieImage.load(url: moviesForCategory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = movies.listOfMovies[indexPath.section].movies[indexPath.row].movieId
        //GET MOVIE FROM API BY ID
        MovieService.shared.getMovie(id: movieId)
        MovieService.shared.completionHandlerDetails { [weak self] (movie,status,message) in
                               if status {
                                   guard let self = self else {return}
                                   guard let _movie = movie else {return}
                                let movieFromTable = self.movies.listOfMovies[indexPath.section].movies[indexPath.row]
                                var details = Details(title: _movie.title, image: _movie.posterPath ?? "", myRaiting: movieFromTable.myRating, raiting: _movie.rating, summary: _movie.summary, releaseDate: _movie.releaseDate ?? "", genre: [], duration: _movie.duration, category: movieFromTable.category, section: indexPath.section, row: indexPath.row)
                                _movie.genres?.forEach({ genre in
                                    details.genre.append(genre.name)
                                })
                                self.performSegue(withIdentifier: "openMovieDetails", sender: details)
                               }
        }
    }
    
    private func handleCompletition() {

    }
    private func handleRemove(section: Int, row: Int) {
        movies.remove(section: section, row: row)
        
        var indexPaths = [IndexPath]()
        indexPaths.append(IndexPath(row: row, section: section))
        moviesTableView.deleteRows(at: indexPaths, with: .fade)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "✅Complete") { [weak self] (action, view, completitionHandler) in
            self?.handleCompletition()
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
