import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Alumno.apellido) private var alumnos: [Alumno]
    @State private var alumnoSeleccionado: Alumno?
    @State private var mostrarFormulario = false
    @State private var alumnoAEditar: Alumno?
    @State private var busqueda = ""

    private var alumnosFiltrados: [Alumno] {
        if busqueda.isEmpty { return alumnos }
        return alumnos.filter { $0.apellido.localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $alumnoSeleccionado) {
                ForEach(alumnosFiltrados) { alumno in
                    NavigationLink(value: alumno) {
                        HStack(spacing: 14) {
                            Image(systemName: "person.fill")
                                .font(.title3)
                                .foregroundStyle(.indigo)
                                .frame(width: 46, height: 46)
                                .background(.indigo.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(alumno.apellido), \(alumno.nombre)").font(.headline)
                                Label(alumno.dni, systemImage: "person.text.rectangle")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteAlumnos)
            }
            .searchable(text: $busqueda, prompt: "Buscar por apellido")
            .navigationTitle("Alumnos")
            .overlay {
                if alumnosFiltrados.isEmpty {
                    ContentUnavailableView(
                        busqueda.isEmpty ? "Aún no hay alumnos" : "Sin resultados",
                        systemImage: busqueda.isEmpty ? "person.2.crop.square.stack" : "magnifyingglass",
                        description: Text(busqueda.isEmpty ? "Agrega un alumno con el botón +." : "Prueba con otro apellido.")
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem {
                    Button { mostrarFormulario = true } label: {
                        Label("Nuevo Alumno", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button { asignarCursoDemo() } label: {
                        Label("Curso demo", systemImage: "book")
                    }
                }
            }
        } detail: {
            if let alumno = alumnoSeleccionado {
                List {
                    Section {
                        VStack(spacing: 10) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(.indigo)
                            Text("\(alumno.nombre) \(alumno.apellido)")
                                .font(.title2.bold())
                            Text("Alumno").font(.subheadline).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .listRowBackground(Color.clear)
                    }
                    Section("Información") {
                        Label(alumno.dni, systemImage: "person.text.rectangle")
                        Label(alumno.curso?.nombre ?? "Sin curso", systemImage: "book.closed")
                    }
                    Section {
                        Button { alumnoAEditar = alumno } label: {
                            Label("Editar alumno", systemImage: "pencil")
                        }
                    }
                }
                .navigationTitle("Detalle")
            } else {
                ContentUnavailableView("Selecciona un alumno", systemImage: "person.crop.circle",
                                       description: Text("Elige un alumno para ver sus datos."))
            }
        }
        .sheet(isPresented: $mostrarFormulario) { NuevoAlumnoView() }
        .sheet(item: $alumnoAEditar) { alumno in
            EditarAlumnoView(alumno: alumno)
        }
        .tint(.indigo)
    }

    private func deleteAlumnos(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let alumno = alumnosFiltrados[index]
                if alumnoSeleccionado == alumno { alumnoSeleccionado = nil }
                modelContext.delete(alumno)
            }
        }
    }

    // DEMOSTRACIÓN de relación: crea un curso y se lo asigna a todos los alumnos
    private func asignarCursoDemo() {
        let curso = Curso(nombre: "Programación en Móviles")
        modelContext.insert(curso)
        for alumno in alumnos {
            alumno.curso = curso
        }
    }
}

#Preview {
    ContentView().modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
