import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    // Paso 11: lista de profesores del ejemplo de la guía.
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software"),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC"),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC"),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC"),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC"),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC"),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC")
    ]

    // Paso 12: una fila por cada profesor.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Paso 13: reutilizar la celda Subtitle definida en el Storyboard.
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        cell.textLabel?.text = listaProfesores[indexPath.row].nombre
        cell.detailTextLabel?.text = listaProfesores[indexPath.row].cargo
        return cell
    }
}
