//
//  MenuHorarioClasesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation
import RealmSwift
import TTProgressHUD
import UniformTypeIdentifiers

// MARK: - View Model para el menú donde se muestran los horarios de clase

/// View Model del view `MenuModificarHorarioView`
class MenuHorarioClasesViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Todos los horarios de clase congelados cargados en la aplicación
    @Published private(set) var horariosClase: RealmSwift.Results<HorarioClase>
    
    /// Indica si es que esta en proceso de selección de archivos
    @Published var estaImportando: Bool = false
    
    /// Indica si es que esta en armando un horario de clases
    @Published var estaArmando: Bool = false
    
    /// Indica si se esta procesando un horario de clases
    @Published var estaProcesando: Bool = false
    
    /// Configuración del HUD Progress
    @Published var hudConfig = TTProgressHUDConfig()
    
    /// Indica si hay horarios de clases en la aplicación
    var hayHorario: Bool { !horariosClase.isEmpty }
    
    // MARK: Métodos
    
    /// Importa el archivo dado el resultado de una selección de archivo
    /// - Parameter resultado: Resultado que contiene la URL de un archivo o un error
    func importarArchivo(resultado: Result<URL, Error>) {
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
                        PoliplannerStore.shared.horarioClaseDraft = horarioGenerado!
                        self.hudConfig = .horarioImportado(nombreHorario: nombreArchivo)
                        self.estaArmando = true
                    }
                }
                
            }
            
        case .failure(let error):
            print("Hubo un error al importar. Error: \(error.localizedDescription)")
            hudConfig = .errorImportar
        }
    }
    
    // MARK: Constructor
    
    /// Constructor del ViewModel
    init() {
        // Inicializamos el valor de horarios de clase
        horariosClase = PoliplannerStore.shared.horariosClase
        
        // Hacemos que se actualice cuando cambie el horario
        PoliplannerStore.shared.$horariosClase
            .assign(to: &$horariosClase)
    }
}
