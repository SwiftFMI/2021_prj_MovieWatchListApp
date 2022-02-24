import UIKit

protocol UpdateDelegate {
    func update(entity: PickerReturnModel)
}
protocol UpdateTableData {
    func updateCategory(section: Int, row: Int, newCategory: String) -> (Int, Int)
    func updateRaiting(section: Int, row: Int, newRaiting: String)
}

protocol AddToDB {
    func addToDB(row: Int, category: String)
}


class MovieDetailViewController: UIViewController, UpdateDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var myRaitingButton: UIButton!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieLength: UILabel!
    @IBOutlet weak var movieRaiting: UILabel!
    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var detailsViewContainer: UIView!
    var details: Details!
    var delegate: UpdateTableData? = nil
    var addDelegate: AddToDB? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryButton.layer.cornerRadius = 25
        myRaitingButton.layer.cornerRadius = 25
        self.view.addBackground()
        detailsViewContainer.addBackground()
        
        if let details = details {
            navigationBar.title = details.title
            movieTitle.text = details.title
            movieGenres.text = details.genre.joined(separator: ", ")
            movieReleaseDate.text = Utilities.getFromatedDate(date: details.releaseDate)
            var duration = details.duration == 0 ? "-" : details.duration!.description
            if details.duration != 0
            {
                duration.append(" minutes")
            }
            movieLength.text = duration
            var raiting = details.raiting == nil ? "-" : details.raiting!.description
            raiting.append("/10⭐️")
            movieRaiting.text = raiting
            movieSummary.text = details.summary
            categoryButton.setTitle(details.category ?? "Add to List", for: .normal)
            if details.category == nil {
                myRaitingButton.isHidden = true
            }
            else{
                var myRaiting = details.myRaiting == 0 ? "-" : details.myRaiting!.description
                myRaiting.append("/10⭐️")
                myRaitingButton.setTitle(myRaiting, for: .normal)
            }
            movieImage.load(url: details.image)
        }
    }
    
    func update(entity: PickerReturnModel) {
        if entity.btnToUpdate == "category" {
            if categoryButton.titleLabel?.text == "Add to List" {
                addDelegate?.addToDB(row: details.row, category: entity.selectedItem)
            }
            else{
                categoryButton.setTitle(entity.selectedItem, for: .normal)
                let result = delegate?.updateCategory(section: details.section!, row: details.row, newCategory: entity.selectedItem)
                details.section = result?.0
                details.row = result?.1 ?? 0
            }

        }
        else {
            var title = entity.selectedItem
            title.append("/10⭐️")
            myRaitingButton.setTitle(title, for: .normal)
            delegate?.updateRaiting(section: details.section!, row: details.row, newRaiting: entity.selectedItem)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "openPicker" {
            if let next = segue.destination as! PickerModalViewController? {
                next.pickerData = sender as? PickerModel
                next.delegate = self
            }
        }
    }
    
    @IBAction func CategoryButtonClicked(_ sender: UIButton) {
        
        let data = ["Watched", "Plan to watch"]
        let index = data.firstIndex(of: (sender.titleLabel?.text)!)
        let pickerData = PickerModel(btnToUpdate: "category", selected: index ?? 0, btnText: sender.titleLabel?.text == "Add to List" ? "➕ Add" : "💾 Update", pickerData: data)
        
        performSegue(withIdentifier: "openPicker", sender: pickerData)
    }
    @IBAction func MyRaitingButtonClicked(_ sender: UIButton) {
        let data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        let separator = sender.titleLabel!.text!.firstIndex(of: "/")!
        let mySubstring = sender.titleLabel?.text?.prefix(upTo: separator)
        let index = (data.firstIndex(of: mySubstring!.description) ?? 0)
        let pickerData = PickerModel(btnToUpdate: "raiting", selected: index, btnText: "💾 Update", pickerData: data)
        
        performSegue(withIdentifier: "openPicker", sender: pickerData)
    }
}

class SerieDetailViewController: UIViewController, UpdateDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var serieImage: UIImageView!
    @IBOutlet weak var serieTitle: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var myRaitingButton: UIButton!
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var episodeButton: UIButton!
    @IBOutlet weak var serieGenres: UILabel!
    @IBOutlet weak var serieReleaseDate: UILabel!
    @IBOutlet weak var serieLength: UILabel!
    @IBOutlet weak var serieRaiting: UILabel!
    @IBOutlet weak var serieSummary: UILabel!
    @IBOutlet weak var detailsViewContainer: UIView!
    var details: Details!
    var delegate: UpdateTableData? = nil
    var addDelegate: AddToDB? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        detailsViewContainer.addBackground()
        categoryButton.layer.cornerRadius = 25
        myRaitingButton.layer.cornerRadius = 25
        seasonButton.layer.cornerRadius = 25
        episodeButton.layer.cornerRadius = 25
        if let details = details {
            navigationBar.title = details.title
            serieTitle.text = details.title
            serieGenres.text = details.genre.joined(separator: ", ")
            serieReleaseDate.text = Utilities.getFromatedDate(date: details.releaseDate)
            var duration = details.duration == 0 ? "-" : details.duration!.description
            if details.duration != 0
            {
                duration.append(" minutes")
            }
            serieLength.text = duration
            var raiting = details.raiting == nil ? "-" : details.raiting!.description
            raiting.append("/10⭐️")
            serieRaiting.text = raiting
            serieSummary.text = details.summary
            serieImage.load(url: details.image)
            categoryButton.setTitle(details.category ?? "Add to List", for: .normal)
            if details.category == nil {
                myRaitingButton.isHidden = true
                seasonButton.isHidden = true
                episodeButton.isHidden = true
            }
            else{
                var myRaiting = details.myRaiting == 0 ? "-" : details.myRaiting!.description
                myRaiting.append("/10⭐️")
                myRaitingButton.setTitle(myRaiting, for: .normal)
            }
        }
    }
    
    func update(entity: PickerReturnModel) {
        if entity.btnToUpdate == "category" {
            if categoryButton.titleLabel?.text == "Add to List" {
                addDelegate?.addToDB(row: details.row, category: entity.selectedItem)
            }
            else{
                categoryButton.setTitle(entity.selectedItem, for: .normal)
                let result = delegate?.updateCategory(section: details.section!, row: details.row, newCategory: entity.selectedItem)
                details.section = result?.0
                details.row = result?.1 ?? 0
            }
        }
        else {
            var title = entity.selectedItem
            title.append("/10")
            myRaitingButton.setTitle(title, for: .normal)
            delegate?.updateRaiting(section: details.section!, row: details.row, newRaiting: entity.selectedItem)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "openPicker" {
            if let next = segue.destination as! PickerModalViewController? {
                next.pickerData = sender as? PickerModel
                next.delegate = self
            }
        }
    }
    
    @IBAction func CategoryButtonClicked(_ sender: UIButton) {
        let data = ["Watched", "Watching", "Plan to watch"]
        let index = data.firstIndex(of: (sender.titleLabel?.text)!)
        let pickerData = PickerModel(btnToUpdate: "category", selected: index ?? 0, btnText: sender.titleLabel?.text == "Add to List" ? "➕ Add" : "💾 Update", pickerData: data)
        
        performSegue(withIdentifier: "openPicker", sender: pickerData)
    }
    @IBAction func RaitingButtonClicked(_ sender: UIButton) {
        let data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        let separator = sender.titleLabel!.text!.firstIndex(of: "/")!
        let mySubstring = sender.titleLabel?.text?.prefix(upTo: separator)
        let index = (data.firstIndex(of: mySubstring!.description) ?? 0)
        let pickerData = PickerModel(btnToUpdate: "raiting", selected: index, btnText: "💾 Update", pickerData: data)
        
        performSegue(withIdentifier: "openPicker", sender: pickerData)
    }
    @IBAction func SeasonButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func EpisodeButtonClicked(_ sender: UIButton) {
    }
}

class PickerModalViewController : UIViewController {
    
    var delegate: UpdateDelegate? = nil
    var pickerData: PickerModel!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var updateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 25
        if let pickerData = pickerData {
            picker.selectRow(pickerData.selected, inComponent: 0, animated: false)
            updateButton.setTitle(pickerData.btnText, for: .normal)
        }
    }
    @IBAction func dismissPickerModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func updateClicked(_ sender: UIButton) {
        
        let result = PickerReturnModel(btnToUpdate: pickerData.btnToUpdate, selectedItem: pickerData.pickerData[picker.selectedRow(inComponent: 0)])
        delegate?.update(entity: result)
        if sender.titleLabel?.text == "💾 Update" {
            dismiss(animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "returnToResults", sender: nil)
        }
        
    }
}

extension PickerModalViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData.pickerData[row]
    }
    
}
