//
//  ViewController.swift
//  apple_lab11_01_UIKit_CoreData
//
//  Created by Luis DB on 5/11/26.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TablaContacto: UITableView!

    var contactos = [Contacto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()
    }

    // MARK: - Conexión con Core Data

    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func mostrarRutaBaseDeDatos() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta"
        print("Base de datos SQLite en: \(ruta)")
    }

    // MARK: - READ: leer los datos

    func cargarInfoCoreData() {
        let contexto = conexion()
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]

        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar la BD: \(error)")
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contacto = contactos[indexPath.row]
        celda.textLabel?.text = contacto.nombre
        celda.detailTextLabel?.text = "\(contacto.telefono ?? "") | \(contacto.direccion ?? "")"
        return celda
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar Contacto", message: "Nuevo Contacto", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre" }
        alerta.addTextField {
            $0.placeholder = "Teléfono"
            $0.keyboardType = .phonePad
        }
        alerta.addTextField { $0.placeholder = "Dirección" }

        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self, weak alerta] _ in
            guard let self, let campos = alerta?.textFields,
                  let nombre = campos[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !nombre.isEmpty else { return }

            let contexto = self.conexion()
            let contacto = Contacto(context: contexto)
            contacto.nombre = nombre
            contacto.telefono = campos[1].text ?? ""
            contacto.direccion = campos[2].text ?? ""

            do {
                try contexto.save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                contexto.delete(contacto)
                print("Error al guardar el dato: \(error)")
            }
        })
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }
}
