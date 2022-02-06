import UIKit


extension UIView {
func addBackground() {
    let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
    backgroundImageView.image = UIImage(named: "background.png")
    backgroundImageView.contentMode = UIView.ContentMode.scaleToFill

    self.addSubview(backgroundImageView)
    self.sendSubviewToBack(backgroundImageView)
}}

class MoviesViewController: UIViewController {
    
    var mockMovies = MockModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            if segue.identifier == "openMovieDetails" {
                    if let next = segue.destination as! DetailViewController? {
                        next.details = sender as? Details
                            }
            }
        }

}

extension MoviesViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mockMovies.listOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockMovies.listOfMovies[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieViewCell
        let moviesForCategory = mockMovies.listOfMovies[indexPath.section].movies
        cell.movieTitle.text = moviesForCategory[indexPath.row].title
        cell.movieRaiting.text =  moviesForCategory[indexPath.row].raiting?.description
        cell.movieImage.image = moviesForCategory[indexPath.row].posterImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "movieCategoryHeader", for: indexPath) as! MovieCategoryHeaderView
        
        let headerData = mockMovies.listOfMovies[indexPath.section].category
        header.movieCategoryHeader.text = headerData
        return header
    }
    
    
}

extension MoviesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = Details(title: mockMovies.listOfMovies[indexPath.section].movies[indexPath.row].title, image: "", raiting: 10)
        self.performSegue(withIdentifier: "openMovieDetails", sender: details)
    }
}
