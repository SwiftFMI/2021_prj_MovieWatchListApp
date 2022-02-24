import UIKit

class DiscoverViewController: UIViewController, SearchFilterDelegate, AddToDB {
    
    var searchResult: MovieSearch?
    var movie:Movie?
    var movies: [MovieShort]?
    var movieSearch: MovieSearch?
    var serieSearch: SeriesSearch?
    var filter = SearchFilter(title: nil, genre: nil, isApplied: false)
    var movieOrSeriesPickerData = ["Movies", "Series"]
    var isMovie: Bool = true
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var movieOrSeries: UIPickerView!
    @IBOutlet weak var searchTable: UITableView!
    @IBAction func unwindToDiscover(segue: UIStoryboardSegue) {}
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if filter.isApplied == false {
            performSegue(withIdentifier: "openSearchBox", sender: isMovie)
        }
        else {
            filter.isApplied = false
            filter.genre = nil
            filter.title = nil
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            getPopularMoviesOrSeries()
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
        if segue.identifier == "openSeriesDetails" {
            if let next = segue.destination as! SerieDetailViewController? {
                next.details = sender as? Details
                next.addDelegate = self
            }
        }
        if segue.identifier == "openSearchBox" {
            if let next = segue.destination as! SearchModalViewController? {
                next.isMovie = sender as? Bool
                next.delegate = self
                    }
        }
    }
    
    func addToDB(row: Int, category: String) {
        if isMovie {
            let movieToAdd = movieSearch?.results[row]
            UserService.shared.addMovie(movie: movieToAdd!, category: category)
        }
        else{
            let seriesToAdd = serieSearch?.results[row]
            UserService.shared.addSerie(series: seriesToAdd!, category: category)
        }

        
        //        let alert = UIAlertController(title: "Success", message: "You've added the movie to your list", preferredStyle: UIAlertController.Style.alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
    }
    
    func updateFilter(searchFilter: SearchFilter) {
        filter.isApplied = true
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
        
//        let mockMovie = Movie(uid:UUID().uuidString ,movieId:219537,title: "Captain Marvel", posterPath:"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg", summary:"The story follows Carol Danvers as she becomes one of the universe’s most powerful heroes when Earth is caught in the middle of a galactic war between two alien races. Set in the 1990s, Captain Marvel is an all-new adventure from a previously unseen period in the history of the Marvel Cinematic Universe.", language: "en",genresIDs:[28,12,878],rating: 6.9, releaseDate:"2019-03-06")
        
//     UserService.shared.addMovie(movie: mockMovie,category: Category.planedToWatched.rawValue)
//        
        
        
//
//        UserService.shared.getAllMovies()
//        UserService.shared.completionHandlerMovies { [weak self] (movies,status,message) in
//            if status {
//                guard let self = self else {return}
//                guard let _movies = movies else {return}
//                self.movies = _movies
//                if let movie = movies?.last {
//                    UserService.shared.updateMovie(movie: movie, category: .watched, rating: 9)
//                }
//            }
//        }
        
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
    
    private func getPopularMoviesOrSeries() {
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
            SeriesService.shared.popularSeries()
            SeriesService.shared.completionHandlerSearch { [weak self] (serieSearch,status,message) in
                if status {
                    guard let self = self else {return}
                    guard var _serieSearch = serieSearch else {return}
                    _serieSearch.totalResults = 20
                    _serieSearch.results = _serieSearch.results.prefix(20).shuffled()
                    self.serieSearch = _serieSearch
                }
            }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPopularMoviesOrSeries()
    }
    
}

extension DiscoverViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMovie {
            if movieSearch == nil {
                return 0
            }
            else{
                return movieSearch!.totalResults
            }
        }
        else{
            if serieSearch == nil {
                return 0
            }
            else{
                return serieSearch!.totalResults
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if isMovie {
            let data = movieSearch?.results[indexPath.row]
            cell.searchTitle.text = data?.title
            var rating = data?.rating == nil ? "-" : data?.rating.description
            rating?.append("/10⭐️")
            cell.searchRaiting.text = rating
            cell.searchImage.load(url: data!.posterURL)
        }
        else{
            let data = serieSearch?.results[indexPath.row]
            cell.searchTitle.text = data?.name
            var rating = data?.rating == nil ? "-" : data?.rating.description
            rating?.append("/10⭐️")
            cell.searchRaiting.text = rating
            cell.searchImage.load(url: data!.posterURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMovie {
            let movieId = movieSearch!.results[indexPath.row].movieId
            MovieService.shared.getMovie(id: movieId)
            MovieService.shared.completionHandlerDetails { [weak self] (movie,status,message) in
                                   if status {
                                       guard let self = self else {return}
                                       guard let _movie = movie else {return}
                                    var details = Details(title: _movie.title, image: _movie.posterURL, myRaiting: 0, raiting: _movie.rating, summary: _movie.summary, releaseDate: _movie.releaseDate ?? "", genre: [], duration: _movie.duration, category: nil, section: 0, row: indexPath.row)
                                        _movie.genres?.forEach({ genre in
                                            details.genre.append(genre.name)
                                        })
                                        self.performSegue(withIdentifier: "openMovieDetails", sender: details)
                                   }
                                }
        }
        else {
            let serieId = serieSearch!.results[indexPath.row].seriesId
            SeriesService.shared.getSeries(id: serieId)
            SeriesService.shared.completionHandlerDetails { [weak self] (serie,status,message) in
                                   if status {
                                       guard let self = self else {return}
                                       guard let _serie = serie else {return}
                                    var details = Details(title: _serie.name, image: _serie.posterURL, myRaiting: 0, raiting: _serie.rating, summary: _serie.summary, releaseDate: _serie.releaseDate ?? "", genre: [], duration: 0, category: nil, section: 0, row: indexPath.row)
                                    _serie.genres?.forEach({ genre in
                                            details.genre.append(genre.name)
                                        })
                                        self.performSegue(withIdentifier: "openSeriesDetails", sender: details)
                                   }
                                }
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if movieOrSeriesPickerData[row] == "Movies" {
            isMovie = true
        }
        else{
            isMovie = false
        }
        searchTable.reloadData()
    }
    
}
