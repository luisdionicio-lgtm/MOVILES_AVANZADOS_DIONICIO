// Desarrollado por: Luis Dionicio. Implementación asistida por IA.
import UIKit

class CatalogoViewController: UIViewController {
    let productos = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4)
    ]
    let carrito = CarritoModel()
    @IBOutlet weak var verCarritoButton: UIButton!
    @IBOutlet var productoButtons: [UIButton]!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verCarritoButton.setTitle("Ver carrito (" + String(carrito.cantidadTotal()) + ")", for: .normal)
        for boton in productoButtons {
            let producto = productos[boton.tag]
            boton.setTitle(producto.nombre + " · " + soles(producto.precio) + " · Stock " + String(producto.stock), for: .normal)
        }
    }

    @IBAction func productoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    @IBAction func verCarritoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verCarrito", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle",
           let boton = sender as? UIButton,
           let destino = segue.destination as? DetalleViewController {
            destino.producto = productos[boton.tag]
            destino.carrito = carrito
        } else if segue.identifier == "verCarrito",
                  let destino = segue.destination as? CarritoViewController {
            destino.carrito = carrito
        }
    }
}
