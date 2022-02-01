import UIKit

class MoviesViewController: UIViewController {
    
    var mockMovies = MockModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

//extension MoviesViewController : UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "openMovieDetails", sender: nil)
////        self.openDetails(details: Details)
//    }
//}
//
//extension MoviesViewController {
////    func openDetails(details: Details){
////        self.performSegue(withIdentifier: "openDetails", sender: nil)
////    }
//}
