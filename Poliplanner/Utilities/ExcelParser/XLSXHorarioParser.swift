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
                
                // Fijarse si hay aula para el examen
                if cabeza.esExamen(),
                   hojaActualFilas[indexFilaEncabezado!].cells.count > index + 2,
                   let siguienteTexto = hojaActualFilas[indexFilaEncabezado!].cells[index + 2]
                    .stringValue(sharedStrings),
                   EncabezadoXLSX(rawValue: siguienteTexto) == .some(.aula) {
                    let celdaAula = hojaActualFilas[indexFilaEncabezado!].cells[index + 2]
                    
                    columnasEncabezados[celdaAula.reference.column.value] = cabeza.examenAula()
                }
                
                // Cargar el dia de la revisión si es que encuentra el examen a la cual pertenece
                if cabeza == .revision,
                   let examenTexto = hojaActualFilas[indexFilaEncabezado!-1].cells[index - 3]
                    .stringValue(sharedStrings),
                   let examen = EncabezadoXLSX(rawValue: examenTexto),
                   examen.esExamen() {
                    // Cargamos la revisión
                    columnasEncabezados[celda.reference.column.value] = examen.examenRevision()
                    
                    // Verificamos si podemos encontrar la hora de la revisión
                    if hojaActualFilas[indexFilaEncabezado!].cells.count > index + 1,
                       let horaTexto = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                        .stringValue(sharedStrings),
                       EncabezadoXLSX(rawValue: horaTexto) == .some(.hora) {
                        
                        let celdaHoraRevision = hojaActualFilas[indexFilaEncabezado!].cells[index + 1]
                        
                        columnasEncabezados[celdaHoraRevision.reference.column.value] = examen
                            .examenRevision()
                            .revisionHora()
                    }
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
                } else if cabeza == .hora {
                    // Por ahora nada
                } else if cabeza == .aula {
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
        
        // Atributos de la sección
        let docente: String = {
            // Datos del docente
            let titulos = (valores[.titulo] ?? "").split(separator: "\n")
            let nombres = (valores[.nombre] ?? "").split(separator: "\n")
            let apellidos = (valores[.apellido] ?? "").split(separator: "\n")
            
            // Recogemos la cantidad minima de docentes encontrados (Mejor Esfuerzo)
            let cantidad: Int = min(titulos.count, min(nombres.count, apellidos.count) )
            
            var docente: String = ""
            
            for index in 0..<cantidad {
                docente.append("\(titulos[index]) \(nombres[index]) \(apellidos[index])")
                if index < cantidad - 1 {
                    docente.append("\n")
                }
            }
            
            return docente
        }()
        let codigo: String = valores[.seccion] ?? ""
        
        seccion.docente = docente
        seccion.codigo = codigo
        
        // Generar examenes TODO: Detener un mal parseo
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_PY")
        dateFormatter.dateFormat = "dd/MM/yy"
        
        EncabezadoXLSX.examenes.forEach { examen in
            if  let valor = valores[examen],
                var fechaExamenComponents = ExcelHelper.obtenerFechaComponentes(para: valor) {
                
                // Intentamos agarrar la hora
                if let horaExamenString = valores[examen.examenHora()],
                   let horaParseada = ExcelHelper.obtenerHora(para: horaExamenString) {
                    fechaExamenComponents.hour = horaParseada.hora
                    fechaExamenComponents.minute = horaParseada.minuto
                }
                                
                if let fechaSeparada = Calendar.current.date(from: fechaExamenComponents) {
                    let examenDraft: Examen = Examen()
                    // Pasamos la fecha
                    examenDraft.fecha = fechaSeparada
                    // Pasamos el tipo de examen
                    examenDraft.tipoEnum = examen.examenTipo()
                    // Pasamos e aula
                    examenDraft.aula = valores[examen.examenAula()] ?? ""
                    // Agregamos el examen
                    examenes.append(examenDraft)
                }
            }
        }
        
        // Generar revisiones
        EncabezadoXLSX.revisiones.forEach { revision in
            // Buscamos el examen que le corresponde a esta revisión
            let examen: Examen! = examenes.first { examen in
                return examen.tipoEnum == revision.revisionExamen().examenTipo()
            }
            
            // Verificamos si encontró el examen y la revisión
            guard examen != nil,
                  let valor = valores[revision],
                  var fechaComponentes = ExcelHelper.obtenerFechaComponentes(para: valor)
            else {
                return
            }
            
            // Intentamos agarrar la hora
            if let horaString = valores[revision.revisionHora()],
               let horaParseada = ExcelHelper.obtenerHora(para: horaString) {
                fechaComponentes.hour = horaParseada.hora
                fechaComponentes.minute = horaParseada.minuto
            }
            
            if let fechaSeparada = Calendar.current.date(from: fechaComponentes) {
                let revisionDraft: Revision = Revision()
                
                // Pasamos la fecha
                revisionDraft.fecha = fechaSeparada
                
                // Insertamos en el examen que le conviene
                examen.revision = revisionDraft
            }
        }
        
        seccion.examenes.append(objectsIn: examenes)
        
        // Generar clases
        EncabezadoXLSX.diasClases.forEach { dia in
            if let valor = valores[dia] {
                let clasesGeneradas: [Clase] = ExcelHelper
                    .obtenerClases(para: valor, elDia: dia.claseDia(), enAula: valores[dia.claseAula()])
                
                // Agregamos la clase a la lista
                clases.append(contentsOf: clasesGeneradas)
            }
        }
        
        seccion.clases.append(objectsIn: clases)
        
        return seccion
    }
    
    // swiftlint:enable function_body_length cyclomatic_complexity
    private func recopilarHojas(paraCarreras carreras: [CarreraSigla]) throws {
        do {
            // archivoXLSX = try XLSXFile(data: Data(contentsOf: archivoURL)) Tarda 0,5 segundos más
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

private typealias ColumnaXLSX = String
