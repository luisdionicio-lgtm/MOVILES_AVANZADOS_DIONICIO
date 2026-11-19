import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting session: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default", sessionRole: session.role)
    }
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.tintColor = Theme.copper
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        window.makeKeyAndVisible()
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--verify") {
            Verification.run()
        }
        #endif
    }
}
enum Theme {
    static let navy = UIColor(red: 0.07, green: 0.13, blue: 0.23, alpha: 1)
    static let copper = UIColor(red: 0.69, green: 0.36, blue: 0.17, alpha: 1)
    static let background = UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1)
    static func money(_ n: Double) -> String { String(format: "S/ %.2f", n) }
    static func label(_ text: String, size: CGFloat = 16, bold: Bool = false) -> UILabel {
        let l = UILabel(); l.text = text; l.numberOfLines = 0
        l.font = bold ? .systemFont(ofSize: size, weight: .bold) : .systemFont(ofSize: size)
        l.textColor = navy
        return l
    }
    static func card(_ items: [UIView], padding: CGFloat = 18) -> UIStackView {
        let card = stack(items); card.spacing = 10
        card.backgroundColor = .white; card.layer.cornerRadius = 18
        card.layer.borderWidth = 1; card.layer.borderColor = UIColor.black.withAlphaComponent(0.035).cgColor
        card.isLayoutMarginsRelativeArrangement = true
        card.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
        return card
    }
    static func field(_ placeholder: String, secure: Bool = false) -> UITextField {
        let f = UITextField(); f.placeholder = placeholder; f.isSecureTextEntry = secure
        f.borderStyle = .roundedRect; f.backgroundColor = .white
        f.autocapitalizationType = .none; f.autocorrectionType = .no
        f.heightAnchor.constraint(equalToConstant: 49).isActive = true
        f.accessibilityIdentifier = placeholder
        return f
    }
    static func button(_ title: String, action: UIAction) -> UIButton {
        let b = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = title; config.baseBackgroundColor = navy; config.baseForegroundColor = .white
        config.cornerStyle = .large; config.contentInsets = .init(top: 17, leading: 20, bottom: 17, trailing: 20)
        b.configuration = config; b.addAction(action, for: .touchUpInside)
        return b
    }
    static func stack(_ views: [UIView]) -> UIStackView {
        let s = UIStackView(arrangedSubviews: views); s.axis = .vertical; s.spacing = 15
        return s
    }
}
extension UIViewController {
    func message(_ text: String) {
        let a = UIAlertController(title: "Ventas", message: text, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(a, animated: true)
    }
    func formLayout(_ stack: UIStackView) {
        view.backgroundColor = Theme.background
        let scroll = UIScrollView(); scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ])
    }
    func showApp() {
        let tabs = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppTabs") as! UITabBarController

        let order = Store.shared.supervisor ? ["Resumen", "VentasEquipo", "Productos", "Clientes", "Cuenta"] : ["Productos", "Clientes", "NuevaVentaNav", "VentasEquipo", "Cuenta"]
        let all = tabs.viewControllers ?? []
        tabs.viewControllers = order.compactMap { id in all.first { $0.restorationIdentifier == id } }
        if !Store.shared.supervisor, let nav = tabs.viewControllers?[3] as? UINavigationController {
            nav.tabBarItem.title = "Mis ventas"; nav.topViewController?.title = "Mis ventas"
        }
        tabs.tabBar.tintColor = Theme.copper
        view.window?.rootViewController = tabs
    }
}
final class LoginController: UIViewController {
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func login(_ sender: Any) {
        do { try Store.shared.login(usuario: user.text ?? "", clave: password.text ?? ""); showApp() }
        catch { errorLabel.text = error.localizedDescription }
    }
}
final class RegisterController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func register(_ sender: Any) {
        do {
            _ = try Store.shared.register(nombre: name.text ?? "", usuario: user.text ?? "", clave: password.text ?? "", confirmacion: confirm.text ?? "", rol: Role.allCases[role.selectedSegmentIndex])
            showApp()
        } catch { errorLabel.text = error.localizedDescription }
    }
}
final class AccountController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = Store.shared.current?.nombre; userLabel.text = "@" + (Store.shared.current?.usuario ?? "")
        roleLabel.text = Store.shared.current?.rol
    }
    @IBAction func logout(_ sender: Any) {
        Store.shared.current = nil
        view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }
}
