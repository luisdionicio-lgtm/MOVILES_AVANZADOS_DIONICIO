import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    // Paso 11: lista de profesores del ejemplo de la guía.
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "jaime")),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "farfan")),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "leon")),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "montoya")),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "Teobaldo-Diaz-Espinoza")),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "garamendi")),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC", foto: UIImage(named: "Edwin-Huerto"))
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
        cell.imageView?.image = listaProfesores[indexPath.row].foto
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
}
