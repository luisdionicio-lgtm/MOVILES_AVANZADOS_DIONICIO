import SwiftUI
import SwiftData

@main // Punto de entrada principal de la aplicación
struct AlumnosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // Vista inicial: la lista de alumnos
                // Contenedor persistente para toda la app:
                // los datos se guardan en disco y no se borran al cerrar la app
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
