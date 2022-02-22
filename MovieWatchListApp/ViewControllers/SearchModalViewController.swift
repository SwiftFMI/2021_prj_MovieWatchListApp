import UIKit

protocol DataEnteredDelegate {
    func updateFilter(searchFilter: MovieSearchFilter)
}

class SearchModalViewController : UIViewController {
    
    var delegate: DataEnteredDelegate? = nil
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var modalViewContainer: UIView!
    @IBOutlet weak var applySearchButton: UIButton!
    @IBOutlet weak var titleSearchField: UITextField!
    @IBOutlet weak var genrePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalViewContainer.layer.cornerRadius = 30
        applySearchButton.layer.cornerRadius = applySearchButton.frame.height/2
        pickerData = ["All", "Action", "Romance", "Triller", "Horror", "Comedy", "Cartoon"]
    }

    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ApplyFilters(_ sender: Any) {
        let genreFromPicker = pickerData[genrePicker.selectedRow(inComponent: 0)] == "All" ? nil : pickerData[genrePicker.selectedRow(inComponent: 0)]
        let titleFromField = titleSearchField.text == "" ? nil : titleSearchField.text
        let filter = MovieSearchFilter(title: titleFromField, genre: genreFromPicker, isApplied: true)
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

