import UIKit
import CoreData

class ViewController: UIViewController {
    //MARK: -  Properties
    @IBOutlet weak var tableView: UITableView!
    var tasks : [NSManagedObject] = []
    
    //MARK: - VC LC
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lookingSaveData()
    }
    
    //MARK: - Actions and methods
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Новая задача", message: "Добавьте задачу", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let taskToSave = textField.text else {
                return
            }
            self.save(title: taskToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func lookingSaveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("can't read \(error), \(error.userInfo)")
        }
    }
    
    func save(title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        task.setValue(title, forKey: "title")
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print("can't save \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = task.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, complete in
            self.deleteTask(indexPath: indexPath)
            tableView.reloadData()
            complete(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func deleteTask(indexPath: IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(self.tasks[indexPath.row])
        do {
            print(indexPath.row)
            print(indexPath.section)
            try managedContext.save()
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("can't save \(error), \(error.userInfo)")
        }
    }

}

