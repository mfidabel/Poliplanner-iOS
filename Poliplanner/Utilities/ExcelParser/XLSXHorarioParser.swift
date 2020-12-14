//
//  XLSXHorarioParser.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import Foundation
import CoreXLSX

// TODO: Separar lógica
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
        
        for (index, celda) in hojaActualFilas[indexFilaEncabezado!-1].cells.enumerated() {
            if let texto = celda.stringValue(sharedStrings), let cabeza = EncabezadoXLSX(rawValue: texto) {
                columnasEncabezados[celda.reference.column.value] = cabeza
                
                // En caso de que sea un examen, fijarse si hay hora
                if cabeza.esExamen(),
                   hojaActualFilas[indexFilaEncabezado!].cells.count > index + 1,
                   let siguienteTexto = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                       .stringValue(sharedStrings),
                   EncabezadoXLSX(rawValue: siguienteTexto) == .some(.hora) {
                    
                    // Abajo a la derecha es una hora de examen, procedemos a registrar
                    // dependiendo de que examen sea lo guardamos
                    let celdaHora = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                    
                    columnasEncabezados[celdaHora.reference.column.value] = cabeza.examenHora()
                }
            }
        }
        
        // Obtener las posiciones de las cabezas sin agrupar
        for (index, celda) in hojaActualFilas[indexFilaEncabezado!].cells.enumerated() {
            if let texto = celda.stringValue(sharedStrings), let cabeza = EncabezadoXLSX(rawValue: texto) {
                // Agregar cabecera de aula de clase
                if  cabeza == .aula,
                    hojaActualFilas[indexFilaEncabezado!].cells.count > index + 1,
                    let siguienteTexto = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                        .stringValue(sharedStrings),
                    let siguienteCabeza = EncabezadoXLSX(rawValue: siguienteTexto) {
                
                    columnasEncabezados[celda.reference.column.value] = siguienteCabeza.claseAula()
                }
                // Agregar hora de examen
                else if cabeza == .hora {
                    // Por ahora nada
                } else {
                    columnasEncabezados[celda.reference.column.value] = cabeza
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
        var examenes: [Examen] = []
        
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
        
        // Generar examenes TODO: Detener un mal parseo
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_PY")
        dateFormatter.dateFormat = "dd/MM/yy"
        
        EncabezadoXLSX.examenes.forEach { examen in
            if  let valor = valores[examen],
                let indiceEspacio = valor.firstIndex(of: " ") {
                // TODO: Agregar regex a la fecha
                // Convertir fecha a date
                let fechaString = String(valor[valor.index(after: indiceEspacio)..<valor.endIndex])
                    .split(separator: "/")
                
                var fechaExamenComponents: DateComponents = .componentesReferencia
                
                // Agarramos la fecha sin la hora
                fechaExamenComponents.day = Int(fechaString[0])
                fechaExamenComponents.month = Int(fechaString[1])
                fechaExamenComponents.year = Int(fechaString[2]) != nil ? Int(fechaString[2])! + 2000 : nil
                
                // Intentamos agarrar la hora
                let horaExamenString = valores[examen.examenHora()] ?? ""
                
                if NSRegularExpression.horaComun.matches(horaExamenString) {
                    // Tiene formato HH:mm
                    fechaExamenComponents.hour = Int(horaExamenString.split(separator: ":").first!)
                    fechaExamenComponents.minute = Int(horaExamenString.split(separator: ":").last!)
                } else if let horaDouble = Double(horaExamenString), horaDouble < 1, horaDouble > 0 {
                    // Tiene formato OLE
                    let tiempoDouble = horaDouble * 24.0
                    fechaExamenComponents.hour = Int(tiempoDouble)
                    fechaExamenComponents.minute = Int( (tiempoDouble - Double(fechaExamenComponents.hour!) ) * 60 )
                } else {
                    #if DEBUG
                    print(horaExamenString) // Caso no esperado
                    #endif
                }
                
                
                if let fechaSeparada = Calendar.current.date(from: fechaExamenComponents) {
                    let examenDraft: Examen = Examen()
                    // Pasamos la fecha
                    examenDraft.fecha = fechaSeparada
                    // Pasamos el tipo de examen
                    examenDraft.tipoEnum = examen.examenTipo()
                    // Agregamos el examen
                    examenes.append(examenDraft)
                }
            }
        }
        
        seccion.examenes.append(objectsIn: examenes)
        
        // Generar clases
        EncabezadoXLSX.diasClases.forEach { dia in
            if let valor = valores[dia] {
                let claseDraft: Clase = Clase()
                
                // Seleccionamos el día
                claseDraft.diaEnum = dia.claseDia()
                claseDraft.aula = valores[dia.claseAula()] ?? ""
                
                // Seleccionamos la hora de inicio y fin
                claseDraft.setHora(valor)
                
                // Agregamos la clase a la lista
                clases.append(claseDraft)
            }
        }
        
        seccion.clases.append(objectsIn: clases)
        
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
    case hora = "Hora"
    case lunesAula
    case martesAula
    case miercolesAula
    case juevesAula
    case viernesAula
    case sabadoAula
    case primeraParcialHora
    case segundaParcialHora
    case primeraFinalHora
    case segundaFinalHora
        
    static let diasClases: [EncabezadoXLSX] = [.lunes, .martes, .miercoles, .jueves, .viernes, .sabado]
    static let examenes: [EncabezadoXLSX] = [.primeraParcial, .segundaParcial, .primeraFinal, .segundaFinal]
    
    func esDiaClase() -> Bool {
        return Self.diasClases.contains(self)
    }
    
    func esExamen() -> Bool {
        return Self.examenes.contains(self)
    }
    
    func esHora() -> Bool {
        switch self {
        case .primeraParcialHora,
             .segundaParcialHora,
             .primeraFinalHora,
             .segundaFinalHora:
            return true
        default:
            return false
        }
    }
    
    func examenHora() -> EncabezadoXLSX {
        switch self {
        case .primeraParcial:
            return .primeraParcialHora
        case .segundaParcial:
            return .segundaParcialHora
        case .primeraFinal:
            return .primeraFinalHora
        case .segundaFinal:
            return .segundaFinalHora
        default:
            return .hora
        }
    }
    
    func claseAula() -> EncabezadoXLSX {
        switch self {
        case .lunes:
            return .lunesAula
        case .martes:
            return .martesAula
        case .miercoles:
            return .miercolesAula
        case .jueves:
            return .juevesAula
        case .viernes:
            return .viernesAula
        case .sabado:
            return .sabadoAula
        default:
            return .aula
        }
    }
    
    func claseDia() -> DiaClase {
        switch self {
        case .lunes:
            return .LUNES
        case .martes:
            return .MARTES
        case .miercoles:
            return .MIERCOLES
        case .jueves:
            return .JUEVES
        case .viernes:
            return .VIERNES
        case .sabado:
            return .SABADO
        default:
            return .LUNES
        }
    }
    
    func examenTipo() -> TipoExamen {
        switch self {
        case .primeraParcial:
            return .primerParcial
        case .segundaParcial:
            return .segundoParcial
        case .primeraFinal:
            return .primerFinal
        case .segundaFinal:
            return .segundoFinal
        default:
            return .evaluacion
        }
    }
}

private typealias ColumnaXLSX = String
