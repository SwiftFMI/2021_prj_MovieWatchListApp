import UIKit

class SeriesViewController: UIViewController {

    @IBOutlet weak var seriesCollectionView: UICollectionView!
    //change to series and the logic below
    var mockMovies = MockModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addBackground()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            super.prepare(for: segue, sender: sender)
//            if segue.identifier == "openSerieDetails" {
//                    if let next = segue.destination as! DetailViewController? {
//                        next.details = sender as? Details
//                            }
//            }
//    }

}
extension SeriesViewController : UICollectionViewDataSource {
    
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
            seriesCollectionView.deleteItems(at: indexPaths)
        }
        else{
            seriesCollectionView.insertItems(at: indexPaths)
        }
        
        button.setImage(UIImage(systemName: isExpanded ? "chevron.right" : "chevron.down"), for: .normal)
        
        
    }
}

extension SeriesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = Details(title: mockMovies.listOfMovies[indexPath.section].movies[indexPath.row].title, image: "", raiting: 10)
        self.performSegue(withIdentifier: "openMovieDetails", sender: details)
    }
}


