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
        window.rootViewController = UINavigationController(rootViewController: LoginController())
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
        let tabs = UITabBarController()
        let supervisor = Store.shared.supervisor
        let pages: [(UIViewController,String,String)] = supervisor ?
            [(DashboardController(),"Resumen","chart.bar.fill"),(SalesController(),"Ventas","receipt"),
             (CatalogController(products: true),"Productos","shippingbox"),(CatalogController(products: false),"Clientes","person.2"),
             (AccountController(),"Cuenta","person.crop.circle")] :
            [(CatalogController(products: true),"Productos","shippingbox"),(CatalogController(products: false),"Clientes","person.2"),
             (SaleController(),"Venta","plus.circle"),(SalesController(),"Mis ventas","receipt"),
             (AccountController(),"Cuenta","person.crop.circle")]
        tabs.viewControllers = pages.map { vc, title, icon in
            vc.title = title
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: icon), selectedImage: nil)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground(); appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: Theme.navy, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
            nav.navigationBar.standardAppearance = appearance; nav.navigationBar.scrollEdgeAppearance = appearance
            return nav
        }
        tabs.tabBar.tintColor = Theme.copper
        view.window?.rootViewController = tabs
    }
}
final class LoginController: UIViewController {
    let user = Theme.field("Usuario")
    let password = Theme.field("Clave", secure: true)
    let errorLabel = Theme.label("", size: 14)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas Tecsup"
        let logo = UIImageView(image: UIImage(named: "Tecsup"))
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 94).isActive = true
        errorLabel.textColor = .systemRed
        formLayout(Theme.stack([
            logo, Theme.label("Ventas Tecsup", size: 32, bold: true),
            Theme.label("Inicia sesión para continuar", size: 18), Theme.label("ACCESO A TU ESPACIO", size: 12, bold: true),
            Theme.card([Theme.label("Iniciar sesión", size: 20, bold: true), user, password, errorLabel]),
            Theme.button("Ingresar", action: UIAction { [weak self] _ in
                guard let self else { return }
                do { try Store.shared.login(usuario: self.user.text ?? "", clave: self.password.text ?? ""); self.showApp() }
                catch { self.errorLabel.text = error.localizedDescription }
            }),
            Theme.button("Crear cuenta", action: UIAction { [weak self] _ in
                self?.navigationController?.pushViewController(RegisterController(), animated: true)
            })

        ]))
    }
}
final class RegisterController: UIViewController {
    let name = Theme.field("Nombre completo")
    let user = Theme.field("Usuario")
    let password = Theme.field("Clave de 6 caracteres o más", secure: true)
    let confirm = Theme.field("Confirmar clave", secure: true)
    let role = UISegmentedControl(items: Role.allCases.map(\.rawValue))
    let errorLabel = Theme.label("", size: 14)
    override func viewDidLoad() {
        super.viewDidLoad(); title = "Crear cuenta"; role.selectedSegmentIndex = 0
        errorLabel.textColor = .systemRed
        formLayout(Theme.stack([
            Theme.label("Empieza a operar", size: 30, bold: true), Theme.label("Crea tu acceso al equipo comercial."),
            name, user, password, confirm, Theme.label("Rol de la cuenta", bold: true), role, errorLabel,
            Theme.button("Registrarme", action: UIAction { [weak self] _ in
                guard let self else { return }
                do {
                    _ = try Store.shared.register(nombre: self.name.text ?? "", usuario: self.user.text ?? "",
                        clave: self.password.text ?? "", confirmacion: self.confirm.text ?? "",
                        rol: Role.allCases[self.role.selectedSegmentIndex])
                    self.showApp()
                } catch { self.errorLabel.text = error.localizedDescription }
            })
        ]))
    }
}
final class AccountController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let u = Store.shared.current
        formLayout(Theme.stack([
            Theme.label("Mi espacio", size: 30, bold: true), Theme.label(u?.nombre ?? "", size: 23, bold: true),
            Theme.label("@"+(u?.usuario ?? "")), Theme.label(u?.rol ?? ""), Theme.label("Ventas · Grupo A · Semana 12"),
            Theme.button("Cerrar sesión", action: UIAction { [weak self] _ in
                Store.shared.current = nil
                self?.view.window?.rootViewController = UINavigationController(rootViewController: LoginController())
            })
        ]))
    }
}
