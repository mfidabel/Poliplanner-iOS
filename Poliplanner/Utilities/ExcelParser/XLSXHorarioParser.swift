//
//  XLSXHorarioParser.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import Foundation
import CoreXLSX

class XLSXHorarioParser: ArchivoHorarioParser {
    private var archivoURL: URL
    private var archivoXLSX: XLSXFile!
    private var sharedStrings: SharedStrings!
    private var hojas: [CarreraSigla: Worksheet] = [:]
    
    required init(archivoURL url: URL) {
        // Copiamos la url a la instancia
        self.archivoURL = url
        // Proveemos acceso al archivo
        guard archivoURL.startAccessingSecurityScopedResource() else {
            return
        }
    }
    
    func generarHorario(paraCarreras carreras: [CarreraSigla]) throws -> HorarioClase {
        // Recopilar las hojas del excel
        try recopilarHojas(paraCarreras: carreras)
        
        // Recopilar horario de cada carrera
        let horarioClase: HorarioClase = HorarioClase()
        var horariosCarrera: [HorarioCarrera] = []
        
        try carreras.forEach { carrera in
            let horarioGenerado = try generarHorarioCarrera(paraCarrera: carrera)
            horariosCarrera.append(horarioGenerado)
        }
        
        // TODO: Agregar atributos faltantes
        horarioClase.horariosCarrera.append(objectsIn: horariosCarrera)
        horarioClase.nombre = self.archivoURL.deletingPathExtension().lastPathComponent
        
        return horarioClase
    }
    
    // swiftlint:disable function_body_length cyclomatic_complexity
    private func generarHorarioCarrera(paraCarrera carrera: CarreraSigla) throws -> HorarioCarrera {
        // Horario a ser creado
        let horarioCarrera: HorarioCarrera = HorarioCarrera()
        
        // Buscar la hoja
        let hojaActualFilas: [Row] = hojas[carrera]!.data?.rows ?? []
        
        if hojaActualFilas.count == 0 {
            return HorarioCarrera()
        } else {
            print("\(carrera.nombreLargo) tiene \(hojaActualFilas.count) filas.")
        }
        
        // Buscar fila del encabezado
        let indexFilaEncabezado: Int? = hojaActualFilas.firstIndex { fila in
            return fila.cells.first?.stringValue(sharedStrings) == EncabezadoXLSX.item.rawValue
        }
        
        if indexFilaEncabezado == nil {
            throw ArchivoHorarioParserError.encabezadoInvalido(descripcion: "No se encontró el encabezado ítem")
        }
        
        // Obtener las posiciones de las cabezas agrupadas
        var columnasEncabezados: [String: EncabezadoXLSX] = [:]
        hojaActualFilas[indexFilaEncabezado!-1].cells.forEach { celda in
            if let texto = celda.stringValue(sharedStrings), let cabeza = EncabezadoXLSX(rawValue: texto) {
                columnasEncabezados[celda.reference.column.value] = cabeza
            }
        }
        
        // Obtener las posiciones de las cabezas sin agrupar TODO: Corrección de aulas usando enumerated
        for (index, celda) in hojaActualFilas[indexFilaEncabezado!].cells.enumerated() {
            if let texto = celda.stringValue(sharedStrings), let cabeza = EncabezadoXLSX(rawValue: texto) {
                columnasEncabezados[celda.reference.column.value] = cabeza
                
                // Agregar cabecera de aula de clase
                if  cabeza == .aula,
                    hojaActualFilas[indexFilaEncabezado!].cells.count > index + 1,
                    let siguienteTexto = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                        .stringValue(sharedStrings),
                    let siguienteCabeza = EncabezadoXLSX(rawValue: siguienteTexto) {
                
                    switch siguienteCabeza {
                    case .lunes:
                        columnasEncabezados[celda.reference.column.value] = .lunesAula
                    case .martes:
                        columnasEncabezados[celda.reference.column.value] = .martesAula
                    case .miercoles:
                        columnasEncabezados[celda.reference.column.value] = .miercolesAula
                    case .jueves:
                        columnasEncabezados[celda.reference.column.value] = .juevesAula
                    case .viernes:
                        columnasEncabezados[celda.reference.column.value] = .viernesAula
                    case .sabado:
                        columnasEncabezados[celda.reference.column.value] = .sabadoAula
                    default:
                        break
                    }
                }
            }
        }
        
        // Parsear cada sección
        var seccionesGeneradas: [Seccion] = []
        for indexFila in (indexFilaEncabezado!+1)..<hojaActualFilas.count {
            let fila: Row = hojaActualFilas[indexFila]
            
            // Evitamos que siga leyendo filas vacias
            if fila.cells.count == 0 {
                break
            }
            
            var cabezaValor: [EncabezadoXLSX: String] = [:]
            
            fila.cells.forEach { celda in
                let columna: ColumnaXLSX = celda.reference.column.value
                if let cabeza = columnasEncabezados[columna] {
                    cabezaValor[cabeza] = celda.stringValue(sharedStrings)
                }
            }
            
            let seccionGenerada = generarSeccion(paraValores: cabezaValor)
            
            seccionesGeneradas.append(seccionGenerada)
        }
        
        horarioCarrera.secciones.append(objectsIn: seccionesGeneradas)
        
        // Obtener información básica
        horarioCarrera.nombreCarrera = carrera.rawValue
        
        return horarioCarrera
    }
    
    private func generarSeccion(paraValores valores: [EncabezadoXLSX: String]) -> Seccion {
        let seccion: Seccion = Seccion()
        let asignatura: Asignatura = Asignatura()
        let carrera: Carrera = Carrera()
        var clases: [Clase] = []
        
        // Obtener asignatura
        asignatura.departamento = valores[.departamento] ?? ""
        asignatura.nivel = valores[.nivel] ?? ""
        asignatura.nombre = valores[.asignatura] ?? ""
        asignatura.semGrupo = valores[.semGrupo] ?? ""
        
        seccion.asignatura = asignatura
        
        // Obtener carrera
        carrera.sigla = valores[.siglaCarrera] ?? ""
        carrera.enfasis = valores[.enfasis] ?? ""
        carrera.plan = valores[.plan] ?? ""
        
        seccion.carrera = carrera
        
        // Atributos de la sección TODO: Revisar las secciones con doble profe
        let docente: String = "\(valores[.titulo] ?? "") \(valores[.nombre] ?? "") \(valores[.apellido] ?? "")"
        let codigo: String = valores[.seccion] ?? ""
        
        seccion.docente = docente
        seccion.codigo = codigo
        
        // Generar clases
        EncabezadoXLSX.diasClases.forEach { dia in
            if let valor = valores[dia] {
                let claseDraft: Clase = Clase()
                
                // Seleccionamos el día
                switch dia {
                case .lunes:
                    claseDraft.setDia(.LUNES)
                    claseDraft.aula = valores[.lunesAula] ?? ""
                case .martes:
                    claseDraft.setDia(.MARTES)
                    claseDraft.aula = valores[.martesAula] ?? ""
                case .miercoles:
                    claseDraft.setDia(.MIERCOLES)
                    claseDraft.aula = valores[.miercolesAula] ?? ""
                case .jueves:
                    claseDraft.setDia(.JUEVES)
                    claseDraft.aula = valores[.juevesAula] ?? ""
                case .viernes:
                    claseDraft.setDia(.VIERNES)
                    claseDraft.aula = valores[.viernesAula] ?? ""
                case .sabado:
                    claseDraft.setDia(.SABADO)
                    claseDraft.aula = valores[.sabadoAula] ?? ""
                default:
                    break // No puede ser otro caso
                }
                
                // Seleccionamos la hora de inicio y fin
                claseDraft.setHora(valor)
                
                // Agregamos la clase a la lista
                clases.append(claseDraft)
            }
        }
        
        seccion.clases.append(objectsIn: clases)
        
        // TODO: Generar examenes
        return seccion
    }
    // swiftlint:enable function_body_length cyclomatic_complexity
    
    private func recopilarHojas(paraCarreras carreras: [CarreraSigla]) throws {
        do {
            //archivoXLSX = try XLSXFile(data: Data(contentsOf: archivoURL)) Tarda 0,5 segundos más
            archivoXLSX = XLSXFile(
                filepath: archivoURL.absoluteString.removingPercentEncoding!
                    .replacingOccurrences(of: "file://", with: "")
            )
            let workbooks = try archivoXLSX.parseWorkbooks()
            for wbk in workbooks {
                for (name, path) in try archivoXLSX.parseWorksheetPathsAndNames(workbook: wbk) {
                    if let worksheetName = name, carreras.contieneCarrera(carrera: worksheetName) {
                        print("Se cargó la hoja: \(worksheetName)")
                        hojas[CarreraSigla(rawValue: worksheetName)!] = try archivoXLSX.parseWorksheet(at: path)
                    }
                }
            }
            sharedStrings = try archivoXLSX.parseSharedStrings()
        } catch let error as NSError {
            print(error)
            throw ArchivoHorarioParserError.archivoInaccesible
        }
    }
    
    deinit {
        // Removemos el acceso al archivo
        archivoURL.stopAccessingSecurityScopedResource()
    }
}

private enum EncabezadoXLSX: String {
    case item = "Item"
    case departamento = "DPTO."
    case asignatura = "Asignatura"
    case nivel = "Nivel"
    case semGrupo = "Sem/Grupo"
    case siglaCarrera = "Sigla carrera"
    case enfasis = "Enfasis"
    case plan = "Plan"
    case turno = "Turno"
    case seccion = "Sección"
    case titulo = "Tít"
    case apellido = "Apellido"
    case nombre = "Nombre"
    case correoInstitucional = "Correo Institucional"
    case primeraParcial = "1er. Parcial"
    case segundaParcial = "2do. Parcial"
    case primeraFinal = "1er. Final"
    case segundaFinal = "2do. Final"
    case revision = "Revisión"
    case lunes = "Lunes"
    case martes = "Martes"
    case miercoles = "Miércoles"
    case jueves = "Jueves"
    case viernes = "Viernes"
    case sabado = "Sábado"
    case sabadoTurnoNoche = "Fechas de clases de sábados (Turno Noche)"
    case aula = "AULA"
    case lunesAula
    case martesAula
    case miercolesAula
    case juevesAula
    case viernesAula
    case sabadoAula
        
    static let diasClases: [EncabezadoXLSX] = [.lunes, .martes, .miercoles, .jueves, .viernes, .sabado]
    
}

private typealias ColumnaXLSX = String
