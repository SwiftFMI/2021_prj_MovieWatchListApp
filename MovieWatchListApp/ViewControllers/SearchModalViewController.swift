import UIKit

protocol SearchFilterDelegate {
    func updateFilter(searchFilter: SearchFilter)
}

class SearchModalViewController : UIViewController {
    
    var delegate: SearchFilterDelegate? = nil
    var isMovie: Bool!
    var genres: [Genre] = []
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var applySearchButton: UIButton!
    @IBOutlet weak var titleSearchField: UITextField!
    @IBOutlet weak var genrePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalViewContainer.layer.cornerRadius = 30
        applySearchButton.layer.cornerRadius = applySearchButton.frame.height/2
        if isMovie {
            genres = Utilities.readGenres(fileName: "movieGenres")
            
        }
        else{
            genres = Utilities.readGenres(fileName: "seriesGenres")
        }
        pickerData.append("All")
        genres.forEach { genre in
            if genre.id != 0{
                pickerData.append(genre.name)
            }
        }
    }

    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ApplyFilters(_ sender: Any) {
        let genreFromPicker = pickerData[genrePicker.selectedRow(inComponent: 0)]
        var genreId = 0
        if isMovie {
            genreId = Utilities.getGenreIdFromStringMovie(name: genreFromPicker)
        }
        else{
//            genreId = Utilities.getfor series
        }
        
        let titleFromField = titleSearchField.text == "" ? nil : titleSearchField.text
        let filter = SearchFilter(title: titleFromField, genre: genreId == 0 ? nil : genreId, isApplied: true)
        delegate?.updateFilter(searchFilter: filter)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchModalViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}

