import SwiftUI
import SwiftData

struct NuevoAlumnoView: View {
    @Environment(\.modelContext) private var modelContext // Contexto del modelo (insertar, guardar, eliminar)
    @Environment(\.dismiss) private var dismiss // Cierra esta vista (como un "volver")

    @State private var apellido = ""
    @State private var nombre = ""
    @State private var dni = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    Label { TextField("Apellido", text: $apellido) } icon: { Image(systemName: "person") }
                    Label { TextField("Nombre", text: $nombre) } icon: { Image(systemName: "person.fill") }
                    Label { TextField("DNI", text: $dni).keyboardType(.numberPad) } icon: { Image(systemName: "person.text.rectangle") }
                }

                Button {
                    // CREATE: crear el objeto e insertarlo en el contexto
                    let nuevoAlumno = Alumno(apellido: apellido, nombre: nombre, dni: dni)
                    modelContext.insert(nuevoAlumno)

                    // Guardamos de inmediato para asegurar la persistencia
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error al guardar alumno: \(error)")
                    }

                    dismiss() // Cierra el formulario
                } label: {
                    Label("Guardar Alumno", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .disabled(apellido.isEmpty || nombre.isEmpty || dni.isEmpty) // Desactiva si hay campos vacíos
            }
            .navigationTitle("Nuevo Alumno")
            .tint(.indigo)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss() // Cierra el formulario sin guardar
                    }
                }
            }
        }
    }
}

#Preview {
    NuevoAlumnoView().modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
