import UIKit


extension UIView {
func addBackground() {
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    backgroundImageView.image = UIImage(named: "background.png")
    backgroundImageView.contentMode = UIView.ContentMode.scaleToFill

    self.addSubview(backgroundImageView)
    self.sendSubviewToBack(backgroundImageView)
}}

class MoviesViewController : UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
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

extension MoviesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mockMovies.listOfMovies.count
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
        
        let category = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
        category.text = mockMovies.listOfMovies[section].category
        category.textColor = .white
        category.font = .systemFont(ofSize: 22, weight: .bold)
        header.addSubview(category)
        
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
        if !mockMovies.listOfMovies[section].isExpanded
        {
            return 0
        }
        return mockMovies.listOfMovies[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MoviewTableViewCell
        let moviesForCategory = mockMovies.listOfMovies[indexPath.section].movies
        cell.movieTitle.text = moviesForCategory[indexPath.row].title
//        cell.movieRaiting.text =  moviesForCategory[indexPath.row].raiting?.description
//        cell.movieImage.image = moviesForCategory[indexPath.row].posterImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mockMovie = mockMovies.listOfMovies[indexPath.section].movies[indexPath.row]
        let details = Details(title: mockMovie.title, image: "", raiting: 10, summary: mockMovie.summary, releaseDate: mockMovie.releaseDate!, genre: ["Action", "Comedy", "Horror"], length: 132)

        self.performSegue(withIdentifier: "openMovieDetails", sender: details)
    }
    
}
