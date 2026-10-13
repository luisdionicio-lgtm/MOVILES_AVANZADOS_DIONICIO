import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    // Nombres del ejemplo; las fotografías son las que se agregaron a Assets.
    let personasArreglo = ["Jaime Gomez", "Juan León", "Silvia Montoya", "Theo Diaz", "Elliot Garamendi"]
    let personasImagenarreglo = ["jaime", "leon", "montoya", "Teobaldo-Diaz-Espinoza", "garamendi"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personasArreglo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCell", for: indexPath) as! PersonasTableViewCell
        cell.personaNombre.text = personasArreglo[indexPath.row]
        cell.PersonaImagen.image = UIImage(named: personasImagenarreglo[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alerta = UIAlertController(
            title: "El docente que seleccionó es:",
            message: personasArreglo[indexPath.row],
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alerta, animated: true)
    }
}
