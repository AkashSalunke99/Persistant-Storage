import UIKit
import CoreData

class ContactsViewController: UITableViewController {
    let token: String
    lazy var container: PersistentContainer = {
        let container = PersistentContainer(name: "Person")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var persons: [Person] {
        var array: [Person] = []
        do {
            let fetchRequest = Person.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "token == %@", token)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
            array = try container.viewContext.fetch(fetchRequest) as [Person]
        }
        catch let error as NSError {
            fatalError("Error: \(error), \(error.userInfo)")
        }
        return array
    }
    
    init(token: String) {
        self.token = token
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc private func addButtonTapped() {
        let alertController = UIAlertController(title: "Add contact details", message: "contains first Name, last Name, phone no.", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter First Name"
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter Last Name"
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter Phone no."
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            let person = personModel()
            let textFields = alertController.textFields!
            guard let firstName = textFields[0].text, !firstName.isEmpty,
                  let lastName = textFields[1].text, !lastName.isEmpty,
                  let phoneNumber = textFields[2].text, !phoneNumber.isEmpty  else {
                return
            }
            person.setValue(firstName, forKeyPath: "firstName")
            person.setValue(lastName, forKeyPath: "lastName")
            person.setValue(phoneNumber, forKeyPath: "phoneNumber")
            person.setValue(token, forKey: "token")
            container.saveContext()
            let indexPath = IndexPath(row: self.persons.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func personModel() -> Person{
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: container.viewContext)
        let person = Person(entity: entity!, insertInto: container.viewContext)
        return person
    }
}


// MARK: UITableViewDataSource

extension ContactsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = persons[indexPath.row]
        let text = """
\(String(describing: person.firstName!)) \(String(describing: person.lastName!))
\(person.phoneNumber!)
"""
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
        return cell
    }
}

// MARK: UITableViewDelegate

extension ContactsViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            container.viewContext.delete(persons[indexPath.row])
            container.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = persons[indexPath.row]
        let alertController = UIAlertController(title: "Edit contact details", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = person.firstName
            textField.placeholder = "Enter First Name"
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
        }
        alertController.addTextField { textField in
            textField.text = person.lastName
            textField.placeholder = "Enter Last Name"
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
        }
        alertController.addTextField { textField in
            textField.text = person.phoneNumber
            textField.placeholder = "Enter Phone no."
            textField.textAlignment = .center
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .numberPad
        }
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            let textFields = alertController.textFields!
            guard let firstName = textFields[0].text, !firstName.isEmpty,
                  let lastName = textFields[1].text, !lastName.isEmpty,
                  let phoneNumber = textFields[2].text, !phoneNumber.isEmpty  else {
                return
            }
            person.setValue(firstName, forKeyPath: "firstName")
            person.setValue(lastName, forKeyPath: "lastName")
            person.setValue(phoneNumber, forKeyPath: "phoneNumber")
            container.saveContext()
            tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

