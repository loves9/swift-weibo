
import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS7以后只需要设置tintColor, 那么图片和文字都会按照tintColor渲染
        tabBar.tintColor = UIColor.orange
        
        // 添加子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.addSubview(centerButton)
        
        // 保存按钮尺寸
        let rect = centerButton.frame
        // 计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        // 设置按钮的位置
        centerButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    
    /// 添加所有子控制器
    func addChildViewControllers()
    {
        // 1.读取json文件
        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else
        {
            
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else
        {
            
            return
        }
        
        // 2. 将json 将JSON数据转换为对象(数组字典)
        do
        {
            let objc = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
            for dict in objc {
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                
                addChildViewController(childControllerName: vcName, title: title, imageName: imageName)
                
            }
            
        }
        catch
        {
            addChildViewController(childControllerName: "HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController(childControllerName: "MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController(childControllerName: "NullViewController", title: "", imageName: "")
            addChildViewController(childControllerName: "DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController(childControllerName: "ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }

    // override代表重写父类的方法
    // Swift支持方法的重载, 也就是说只要方法的参数个数或者数据类型不相同, 那么系统就会认为是两个方法
    /// 添加一个子控制器
    
    // MARK: - 创建视图
    private func addChildViewController(childControllerName: String?, title: String?, imageName: String?) {
        
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
        
            return;
        }
        
        var cls: AnyObject? = nil
        if let vcName = childControllerName
        {
            cls = NSClassFromString(name + "." + vcName)
        }
        
        guard let typeCls = cls as? UITableViewController.Type else {
            
            return;
        }
        
        let childController = typeCls.init()
        
        // 该方法会由内向外的设置标题
        childController.title = title
        if let ivName = imageName
        {
            childController.tabBarItem.image = UIImage(named: ivName)
            childController.tabBarItem.selectedImage = UIImage(named: ivName + "_highlighted")
        }
        
        // 1.3包装一个导航控制器
        let nav = UINavigationController(rootViewController: childController)
        // 1.4将子控制器添加到UITabBarController中
        addChildViewController(nav)
    }
    
    // MARK: - 懒加载
    private lazy var centerButton: UIButton = {
        () -> UIButton
        in
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        btn.addTarget(self, action: #selector(centerBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    @objc private func centerBtnClick (btn: UIButton)
    {
    }
}
