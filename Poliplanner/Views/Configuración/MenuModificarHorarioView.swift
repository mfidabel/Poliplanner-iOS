//
//  MenuArmarHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI
import UniformTypeIdentifiers
import RealmSwift
import TTProgressHUD

// MARK: Menu de Modificar Horarios

/// Interfaz del menu para modificar horarios.
/// Permite al usuario importar horarios.
struct MenuModificarHorarioView: View {
    // MARK: Propiedades
    
    /// Store de Poliplanner, se utiliza para cargar los borradores de los horarios de clase
    @ObservedObject var PPStore: PoliplannerStore = PoliplannerStore.shared
    
    /// Indica si es que esta en proceso de selección de archivos
    @State private var estaImportando: Bool = false
    
    /// Indica si es que esta en armando un horario de clases
    @State private var estaArmando: Bool = false
    
    /// Indica si se esta procesando
    @State private var estaProcesando: Bool = false
    
    /// Configuración del HUD
    @State var hudConfig = TTProgressHUDConfig()

    // MARK: Body
    
    var body: some View {
        ZStack {
            Form {
                // MARK: Crear horario
                Section(header: Text("Crear horario")) {
                    botonImportarArchivo
                }
                
                // MARK: Horarios Cargados
                Section(header: Text("Horarios de clases")) {
                    if PPStore.hayHorario {
                        ForEach(PPStore.horariosClase) { horario in
                            NavigationLink(
                                destination: InformacionHorarioView(horario)) {
                                Text(horario.nombre)
                            }
                        }
                    } else {
                        Text("No tienes horarios 😢")
                    }
                }
            }
            // MARK: Importación del Archivo
            .fileImporter(isPresented: $estaImportando,
                          allowedContentTypes: [.xlsx, .xls], onCompletion: importarArchivo)
            .sheet(isPresented: $estaArmando) {
                NavigationView {
                    ArmarSeleccionarCarrera(estaPresentando: $estaArmando)
                }
            }
            if estaProcesando {
                TTProgressHUD($estaProcesando, config: hudConfig)
            }
        }
        .navigationBarTitle("Horarios de clases")
    }
    
    /// View de la opción para importar un archivo
    var botonImportarArchivo: some View {
            Button {
                self.estaImportando = true
            } label: {
                Text("Importar desde un archivo")
            }
        
    }
    
    // MARK: Métodos
    
    /// Importa el archivo dado el resultado de una selección de archivo
    /// - Parameter resultado: Resultado que contiene la URL de un archivo o un error
    func importarArchivo(resultado: Result<URL, Error>) {
        // TODO: Pasar lógica a un view model
        switch resultado {
        case .success(let archivoURL):
            let nombreArchivo = archivoURL.lastPathComponent
            var parser: ArchivoHorarioParser
            
            estaProcesando = true
            
            switch UTType(filenameExtension: archivoURL.pathExtension) {
            case .some(.xlsx):
                parser = XLSXHorarioParser(archivoURL: archivoURL)
                hudConfig = .importandoHorario(nombreHorario: nombreArchivo)
            case .some(.xls):
                hudConfig = .advertencia("Los archivos XLS no estan soportados actualmente.")
                return
            default:
                hudConfig = .errorImportar
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let start = DispatchTime.now()
                let horarioGenerado = try? parser.generarHorario()
                let end = DispatchTime.now()
                
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                
                print("Tiempo de importación: \(timeInterval) seconds")
                
                if horarioGenerado != nil {
                    DispatchQueue.main.sync {
                        // Pasamos al PPStore el draft del horario de clase en el hilo principal
                        // provocando una actualización en la interfaz gráfica
                        // Como no esta manejado por realm todavía, es seguro pasar entre hilos el objeto
                        PPStore.horarioClaseDraft = horarioGenerado!
                        hudConfig = .horarioImportado(nombreHorario: nombreArchivo)
                        estaArmando = true
                    }
                }
                
            }
            
        case .failure(let error):
            print("Hubo un error al importar. Error: \(error.localizedDescription)")
            hudConfig = .errorImportar
        }
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
struct MenuArmarHorarioView_Previews: PreviewProvider {

    static var previews: some View {
        TabView {
            NavigationView {
                MenuModificarHorarioView()
                    .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
            }
        }
    }
}
#endif
