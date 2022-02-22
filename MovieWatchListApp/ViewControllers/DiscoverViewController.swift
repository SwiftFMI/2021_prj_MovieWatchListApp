import UIKit

class DiscoverViewController: UIViewController {
    var searchResult: MovieSearch?
    var movie:Movie?
    var movieSearch: MovieSearch?
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var genresButton: UIButton!
    @IBOutlet weak var searchTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
        searchButton.layer.cornerRadius = searchButton.frame.height/2
        genresButton.layer.cornerRadius = genresButton.frame.height/2
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
                        print(movieSearch?.results[0].title)
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
    
    
}
