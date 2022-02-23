import UIKit

class DiscoverViewController: UIViewController, SearchFilterDelegate, AddToDB {
    
    var searchResult: MovieSearch?
    var movie:Movie?
    var movieSearch: MovieSearch?
    var filter = SearchFilter(title: nil, genre: nil, isApplied: false)
    var movieOrSeriesPickerData = ["Movies", "Series"]
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var movieOrSeries: UIPickerView!
    @IBOutlet weak var searchTable: UITableView!
    @IBAction func unwindToDiscover(segue: UIStoryboardSegue) {}
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if filter.isApplied == false {
            performSegue(withIdentifier: "openSearchBox", sender: nil)
        }
        else {
            filter.isApplied = false
            filter.genre = nil
            filter.title = nil
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            mockMovies.listOfMovies = getAllMoviesFrimDB();
//            moviesTableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openMovieDetails" {
                    if let next = segue.destination as! MovieDetailViewController? {
                        next.details = sender as? Details
                        next.addDelegate = self
                            }
            }
        if segue.identifier == "openSerieDetails" {
                if let next = segue.destination as! SerieDetailViewController? {
                    next.details = sender as? Details
                        }
        }
            if segue.identifier == "openSearchBox" {
                let searchViewController = segue.destination as! SearchModalViewController
                searchViewController.delegate = self
            }
    }
    
    func addToDB(row: Int) {
        let movieToAdd = movieSearch?.results[row]
        
//        let alert = UIAlertController(title: "Success", message: "You've added the movie to your list", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        //add to db
    }
    
    func updateFilter(searchFilter: SearchFilter) {
        filter.isApplied = true
//        let IsMovies = movieOrSeriesPickerData[movieOrSeries.selectedRow(inComponent: 0)]
        //searchMovies = getMoviesAndSeries by filters
//        searchTable.reloadData()
        searchButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        searchButton.layer.cornerRadius = searchButton.frame.height/2
        searchTable.tableFooterView = UIView(frame: .zero)
        
//        let mockMovie = Movie(uid:UUID().uuidString ,movieId:219537,title: "Captain MMarvel", posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", summary:"The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.", language: "en",genresIDs:[28,12,878],rating: 6.9, releaseDate:"2019-03-06")
        
        //        MovieService.shared.getMovie(id: 27205)
        //        MovieService.shared.completionHandlerDetails { [weak self] (movie,status,message) in
        //                   if status {
        //                       guard let self = self else {return}
        //                       guard let _movie = movie else {return}
        //                       self.movie = _movie
        //                   }
        //               }
        
        //        movie = MovieService.shared.getMovie(id: 27205)
        //MovieService.shared.setMovieDb(movie: mockMovie)
        
//        MovieService.shared.getMovieDb(movieId: mockMovie.movieId)
//        MovieService.shared.completionHandlerDetails {[weak self]
//            (movie,status,message) in
//            if status {
//                guard let self = self else {return}
//                guard let _movie = movie else {return}
//                self.movie = _movie
//                //reload
//                print(self.movie)
//            }
//        }
        
        //MovieService.shared.searchMovie(query: "Am")

        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieService.shared.popularMovies()
        MovieService.shared.completionHandlerSearch { [weak self] (movieSearch,status,message) in
                    if status {
                        guard let self = self else {return}
                        guard var _movieSearch = movieSearch else {return}
                        _movieSearch.totalResults = 20
                        _movieSearch.results = _movieSearch.results.prefix(20).shuffled()
                        self.movieSearch = _movieSearch
                        self.searchTable.reloadData()
                    }
                }
    }
    
    }

extension DiscoverViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieSearch == nil {
            return 0
        }
        else{
            return movieSearch!.totalResults
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        let data = movieSearch?.results[indexPath.row]
        cell.searchTitle.text = data?.title
        cell.searchRaiting.text = data?.rating.description
//        cell.searchImage.image =
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let IsMovies = movieOrSeriesPickerData[movieOrSeries.selectedRow(inComponent: 0)]
        if IsMovies == "Movies" {
            let movie = movieSearch!.results[indexPath.row]
            //create Movie and send thorugh segue to details
            let details = Details(title: movie.title, image: "", myRaiting: nil, raiting: movie.rating, summary: movie.summary, releaseDate: movie.releaseDate!, genre: ["Action", "Comedy", "Horror"], length: 132, category: nil, section: nil, row: indexPath.row)
            self.performSegue(withIdentifier: "openMovieDetails", sender: details)
        }
    }
    
}

extension DiscoverViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return movieOrSeriesPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return movieOrSeriesPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: movieOrSeriesPickerData[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
    }
    
}
