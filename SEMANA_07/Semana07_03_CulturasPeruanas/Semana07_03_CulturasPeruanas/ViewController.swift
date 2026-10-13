import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let culturas = Cultura.ejemplos

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "culturaCell", for: indexPath) as! CulturaTableViewCell
        let cultura = culturas[indexPath.row]
        cell.nombreCultura.text = cultura.nombre
        cell.regionCultura.text = cultura.region
        cell.imagenCultura.image = UIImage(named: cultura.imagen)
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seleccion = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: seleccion, animated: true)
        }
    }
}
