import UIKit

class SerieCategoryHeaderView : UICollectionReusableView {
    
    @IBOutlet weak var colapseExpandButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}

class SerieViewCell : UICollectionViewCell {
    
    @IBOutlet weak var serieImage: UIImageView!
    @IBOutlet weak var serieTitle: UILabel!
    @IBOutlet weak var serieRaiting: UILabel!
    @IBOutlet weak var serieNextEpisode: UILabel!
}
