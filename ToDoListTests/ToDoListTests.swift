import XCTest
@testable import ToDoList

class ToDoListTests: XCTestCase {
    
    var sut: ViewController!
    
    
    override func setUpWithError() throws {
        sut = ViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testAddTaskToTasks(){
        let task = "SecondTask"
        sut.save(title: task)
        let result = sut.tasks.last?.value(forKey: "title") as? String
        // then
        XCTAssert(result == task, "Task saved in tasks")
    }
    
    func testDeleteTask(){
        let arrayCount = sut.tasks.count
        if arrayCount > 0 {
            let indexPath = IndexPath(row: arrayCount - 1, section: 0)
            sut.deleteTask(indexPath: indexPath)
            XCTAssert(arrayCount == sut.tasks.count, "task delete from tasks")
        }
        
    }
    

}
