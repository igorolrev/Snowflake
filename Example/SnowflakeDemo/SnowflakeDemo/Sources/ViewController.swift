import UIKit
import Snowflake

class ListController: UITableViewController {
  
  var items: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let path = Bundle.main.resourcePath,
      let contents = try? FileManager.default.contentsOfDirectory(atPath: path) {
      items = contents.flatMap { content in
        if content.hasSuffix("svg") {
          return content.replacingOccurrences(of: ".svg", with: "")
        }
        
        return nil
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    cell?.textLabel?.text = items[indexPath.row]
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = ViewController()
    controller.item = items[indexPath.row]
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

class ViewController: UIViewController {

  var item: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    
    load()
  }
  
  func load() {
    guard let path = Bundle.main.path(forResource: item, ofType: "svg"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
      let document = Snowflake.Document(data: data)
    else { return }
    
    document.views.forEach { view in
      view.center = self.view.center
      self.view.addSubview(view)
    }
  }
}

