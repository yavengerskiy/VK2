//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Beelab on 16/01/22.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    private let reuseIdentifier = "FriendsListTableViewCell"
    private var namesListFixed: [String] = []
    private var namesListModifed: [String] = []
    private var letersOfNames: [String] = []
    
    var currentUser: User!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return letersOfNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        // сравниваем массив букв и заглавные буквы каждого имени, выводим количество ячеек в соотвествии именам на отдельную букву
        for name in namesListModifed {
            if letersOfNames[section].contains(name.first!) {
                countOfRows += 1
            }
        }
        return countOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // получить ячейку класса FriendTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FriendsListTableViewCell else { return UITableViewCell() }

        // задать имя пользователя (ищет по буквам для расстановки по секциям) + сортировка по алфавиту
        cell.titleLabel.text = getNameFriendForCell(indexPath)
        cell.avatarImageView.image = UIImage(named: getAvatarFriendForCell(indexPath))
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let photosVC = segue.destination as? PhotosCollectionViewController else { return }
            let photoList = currentUser.friendsList[indexPath.row].photos
            photosVC.photoList = photoList
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toFriendsPhotos", sender: nil)
    }
    
}

extension FriendsTableViewController: UISearchBarDelegate {
    private func setup() {
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "FriendsListTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        searchBar.delegate = self
        makeNamesList()
        sortCharacterOfNamesAlphabet()
    }
    
    func makeNamesList() {
        namesListFixed.removeAll()
        for item in 0..<currentUser.friendsList.count {
            namesListFixed.append(currentUser.friendsList[item].name)
        }
        namesListModifed = namesListFixed
    }
    
    func sortCharacterOfNamesAlphabet() {
        var letersSet = Set<Character>()
        letersOfNames = []
        for name in namesListModifed {
            letersSet.insert(name[name.startIndex])
        }
        for leter in letersSet.sorted() {
            letersOfNames.append(String(leter))
        }
    }
    func getNameFriendForCell(_ indexPath: IndexPath) -> String {
        var namesRows = [String]()
        for name in namesListModifed.sorted() {
            if letersOfNames[indexPath.section].contains(name.first!) {
                namesRows.append(name)
            }
        }
        return namesRows[indexPath.row]
    }
    
    func getAvatarFriendForCell(_ indexPath: IndexPath) -> String {
        for friend in currentUser.friendsList {
            let namesRows = getNameFriendForCell(indexPath)
            if friend.name.contains(namesRows) {
                return friend.photos.first ?? ""
            }
        }
        return ""
    }
    
    
    // MARK: - searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        namesListModifed = searchText.isEmpty ? namesListFixed : namesListFixed.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        makeNamesList()
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    // настройка хедера ячеек
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        let leter: UILabel = UILabel(frame: CGRect(x: 30, y: 5, width: 20, height: 20))
        leter.textColor = UIColor.black.withAlphaComponent(0.5)
        leter.text = letersOfNames[section]
        leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        header.addSubview(leter)
        
        return header
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letersOfNames
    }
}
