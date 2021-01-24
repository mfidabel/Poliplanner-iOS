//
//  ArmarHorarioPasosViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation
import SwiftUI

class ArmarHorarioPasosViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Indica el paso actual en el momento de armar el horario de clases
    @Published private(set) var pasoActual: ArmarPasos = .seleccionCarreras
    
    /// Las materias que fueron seleccionadas en cada carrera. La cadena representa el nombre de la materia
    @Published private(set) var materiasSeleccionadas: [CarreraSigla: Set<InfoAsignatura> ] = [:]
    
    /// Las secciones que fueron seleccionadas
    @Published private(set) var seccionesSeleccionadas: Set<Seccion> = []
    
    /// Indica si se esta presentando el view para armar el horario de clases
    @Binding private var estaPresentando: Bool
    
    /// Las carreras que fueron seleccionadas
    private var carrerasSeleccionadas: [CarreraSigla] = []
    
    /// Indice la carrera de la cual se esta seleccionando sus materias actualmente
    private var indiceSeleccionMaterias: Int?
    
    // MARK: Métodos
    
    /// Cancela el armado del horario de clases
    func cancelar() {
        self.estaPresentando = false
    }
    
    /// Confirma la selección de carreras
    /// - Parameter carreras: Carreras que el usuario seleccionó en la pantalla
    func confirmarCarreras(carreras: [CarreraSigla]) {
        /// Guardamos las carreras seleccionadas
        self.carrerasSeleccionadas = carreras
        
        /// Nos ubicamos al principio de las carreras
        self.indiceSeleccionMaterias = 0
        
        /// Seleccionamos el paso actual para la primera carrera seleccionada
        self.pasoActual = .seleccionMaterias(carrera: carrerasSeleccionadas.first!)
    }
    
    func mostrarAnteriorSeleccionMaterias(materiasSeleccionadas: Set<InfoAsignatura>) {
        // Verificamos que estamos seleccionando materias
        guard let indice = self.indiceSeleccionMaterias else {
            return
        }
        
        // Verificamos si no estamos en la primera carrera
        guard indice > 0 else {
            self.pasoActual = .seleccionCarreras
            self.indiceSeleccionMaterias = nil
            self.materiasSeleccionadas = [:]
            return
        }
        
        // Almacenamos las materias seleccionadas
        self.materiasSeleccionadas[carrerasSeleccionadas[indice]] = materiasSeleccionadas
        
        self.indiceSeleccionMaterias = indice - 1
        
        // Pasamos a la anterior selección
        self.pasoActual = .seleccionMaterias(carrera: self.carrerasSeleccionadas[self.indiceSeleccionMaterias!])
    }
    
    /// Muestra la siguiente pantalla de selección de materias.
    /// Si ya se seleccionaron las materias de todas las carreras, se procede a la selección de secciones
    func mostrarSiguienteSeleccionMaterias(materiasSeleccionadas: Set<InfoAsignatura>) {
        // Verificamos que estamos seleccionando materias
        guard let indice = self.indiceSeleccionMaterias else {
            return
        }
        
        // Almacenamos las materias seleccionadas
        self.materiasSeleccionadas[carrerasSeleccionadas[indice]] = materiasSeleccionadas
        
        guard indice + 1 < carrerasSeleccionadas.count else {
            self.pasoActual = .seleccionSecciones
            self.indiceSeleccionMaterias = nil
            return
        }
        
        self.indiceSeleccionMaterias = indice + 1
        
        self.pasoActual = .seleccionMaterias(carrera: self.carrerasSeleccionadas[self.indiceSeleccionMaterias!])
    }
    
    func retroceder() {
        switch self.pasoActual {
        case .seleccionCarreras:
            self.cancelar()
        case .seleccionMaterias:
            // Tiene su propia implementación
            break
        case .seleccionSecciones:
            self.atrasSecciones()
        case .confirmacionClases:
            self.pasoActual = .seleccionSecciones
        case .confirmacionExamenes:
            self.pasoActual = .confirmacionClases
        case .fin:
            self.pasoActual = .confirmacionExamenes
        }
    }
    
    func avanzar() {
        switch self.pasoActual {
        case .seleccionCarreras,
             .seleccionMaterias,
             .seleccionSecciones:
            // Tiene su propia implementación
            break
        case .confirmacionClases:
            self.confirmarClases()
        case .confirmacionExamenes:
            self.confirmarExamenes()
        case .fin:
            self.confirmarHorario()
        }
    }
    
    private func atrasSecciones() {
        self.pasoActual = .seleccionMaterias(carrera: carrerasSeleccionadas.last!)
        self.indiceSeleccionMaterias = carrerasSeleccionadas.count - 1
    }
    
    func confirmarSecciones(secciones: Set<Seccion>) {
        self.seccionesSeleccionadas = secciones
        self.pasoActual = .confirmacionClases
    }
    
    private func confirmarClases() {
        self.pasoActual = .confirmacionExamenes
    }
    
    private func confirmarExamenes() {
        self.pasoActual = .fin
    }
    
    private func confirmarHorario() {
        // Marcamos todas las secciones como elegidas
        seccionesSeleccionadas.forEach { $0.elegido = true }
        
        // Marcamos el horario como activo
        PoliplannerStore.shared.horarioClaseDraft.estadoEnum = .ACTIVO
        
        // Agregamos el draft a la base de datos
        PoliplannerStore.shared.agregarHorarioClase(PoliplannerStore.shared.horarioClaseDraft, desactivandoViejos: true)
        
        // Cerramos el view
        self.estaPresentando = false
    }
    
    // MARK: Constructor
    
    /// Constructor del ViewModel de los pasos para armar el horario
    init(estaPresentando: Binding<Bool>) {
        self._estaPresentando = estaPresentando
    }
    
    // MARK: Pasos
    enum ArmarPasos {
        case seleccionCarreras
        case seleccionMaterias(carrera: CarreraSigla)
        case seleccionSecciones
        case confirmacionClases
        case confirmacionExamenes
        case fin
    }
}
