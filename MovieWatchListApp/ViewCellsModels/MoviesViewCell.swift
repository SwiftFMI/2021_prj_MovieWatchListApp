import UIKit

class MovieCategoryHeaderView : UICollectionReusableView {
    
    @IBOutlet weak var movieCategoryHeader: UILabel!
    @IBOutlet weak var expandCollapseButton: UIButton!
}

class MovieViewCell : UICollectionViewCell{
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRaiting: UILabel!
}
