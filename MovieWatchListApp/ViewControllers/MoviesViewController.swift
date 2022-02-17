import UIKit


extension UIView {
func addBackground() {
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    backgroundImageView.image = UIImage(named: "background.png")
    backgroundImageView.contentMode = UIView.ContentMode.scaleToFill

    self.addSubview(backgroundImageView)
    self.sendSubviewToBack(backgroundImageView)
}}

class MoviesViewController: UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    var mockMovies = MockModel()
    var filter = MovieSearchFilter(title: nil, genre: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openMovieDetails" {
                    if let next = segue.destination as! MovieDetailViewController? {
                        next.details = sender as? Details
                            }
            }
            if segue.identifier == "openSearchBox" {
                let searchViewController = segue.destination as! SearchModalViewController
                searchViewController.delegate = self
            }
    }
    
    func updateFilter(searchFilter: MovieSearchFilter) {
        filter.title = searchFilter.title
        filter.genre = searchFilter.genre
    }

    @IBAction func searchClicked(_ sender: Any) {
        performSegue(withIdentifier: "openSearchBox", sender: nil)
    }
}

extension MoviesViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return mockMovies.listOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !mockMovies.listOfMovies[section].isExpanded
        {
            return 0
        }
        return mockMovies.listOfMovies[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let moviesForCategory = mockMovies.listOfMovies[indexPath.section].movies
        cell.movieTitle.text = moviesForCategory[indexPath.row].title
//        cell.movieRaiting.text =  moviesForCategory[indexPath.row].raiting?.description
//        cell.movieImage.image = moviesForCategory[indexPath.row].posterImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "movieCategoryHeader", for: indexPath) as! MovieCategoryHeaderView
        
        let headerData = mockMovies.listOfMovies[indexPath.section].category
        header.movieCategoryHeader.text = headerData
        header.expandCollapseButton.addTarget(self, action: #selector(handleExpandCollapse), for: .touchUpInside)
        header.expandCollapseButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width - 50, bottom: 0, right: 0)
        header.expandCollapseButton.tag = indexPath.section
        
        return header
    }
    
    @objc func handleExpandCollapse(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for movie in mockMovies.listOfMovies[section].movies.indices {
            let indexPath = IndexPath(row: movie, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = mockMovies.listOfMovies[section].isExpanded
        mockMovies.listOfMovies[section].isExpanded = !isExpanded
        
        if isExpanded {
            moviesCollectionView.deleteItems(at: indexPaths)
        }
        else{
            moviesCollectionView.insertItems(at: indexPaths)
        }
        
        button.setImage(UIImage(systemName: isExpanded ? "chevron.right" : "chevron.down"), for: .normal)
        
        
    }
    
    
}

extension MoviesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mockMovie = mockMovies.listOfMovies[indexPath.section].movies[indexPath.row]
        let details = Details(title: mockMovie.title, image: "", raiting: 10, summary: mockMovie.summary, releaseDate: mockMovie.releaseDate!, genre: ["Action", "Comedy", "Horror"], length: 132)
        
        self.performSegue(withIdentifier: "openMovieDetails", sender: details)
    }
}
