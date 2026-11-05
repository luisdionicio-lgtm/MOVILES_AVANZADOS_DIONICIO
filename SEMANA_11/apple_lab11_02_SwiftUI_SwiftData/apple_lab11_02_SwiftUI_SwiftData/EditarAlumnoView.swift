import SwiftUI
import SwiftData

// UPDATE: editar un alumno existente.
// @Bindable enlaza los campos directamente a las propiedades del modelo.
struct EditarAlumnoView: View {
    @Bindable var alumno: Alumno
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    Label { TextField("Apellido", text: $alumno.apellido) } icon: { Image(systemName: "person") }
                    Label { TextField("Nombre", text: $alumno.nombre) } icon: { Image(systemName: "person.fill") }
                    Label { TextField("DNI", text: $alumno.dni).keyboardType(.numberPad) } icon: { Image(systemName: "person.text.rectangle") }
                }
            }
            .navigationTitle("Editar Alumno")
            .tint(.indigo)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EditarAlumnoView(alumno: Alumno(apellido: "García", nombre: "Ana", dni: "12345678"))
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
