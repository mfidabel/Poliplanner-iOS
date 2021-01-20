//
//  ImportarTests.swift
//  PoliplannerTests
//
//  Created by Mateo Fidabel on 2021-01-18.
//

import XCTest
@testable import Poliplanner

class ImportarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    private func generarHoraOLE(hora: Int, minuto: Int) -> String {
        "\(Float(hora * 60 + minuto) / 1440.0)"
    }

    /// Testea la capacidad de obtener la hora del excel desde una cadena `ExcelHelper.obtenerHora(para:)`
    func testObtenerHoraParser() {
        // Casos de prueba
        var casosPrueba: [String: (hora: Int, minuto: Int)?]
            = [ // Casos HH:mm
                "19:00": (19, 00), "23:59": (23, 59), "09:00": (9, 0), "9:00": (9, 0), "00:00": (0, 0),
                // Casos OLE
               generarHoraOLE(hora: 23, minuto: 59): (23, 59),
               generarHoraOLE(hora: 0, minuto: 0): (0, 0),
               generarHoraOLE(hora: 12, minuto: 52): (12, 52)
            ]
        
        // Generamos más pruebas
        for hora in 1...23 {
            casosPrueba["\(hora)00"] = nil
            casosPrueba["\(hora)30"] = nil
            casosPrueba[generarHoraOLE(hora: hora, minuto: 0)] = (hora, 0)
            casosPrueba[generarHoraOLE(hora: hora, minuto: 30)] = (hora, 30)
            casosPrueba[generarHoraOLE(hora: hora, minuto: 45)] = (hora, 45)
        }
        
        // Por cada caso probamos
        for caso in casosPrueba {
            // Respuesta del parser
            let veredicto = ExcelHelper.obtenerHora(para: caso.key)
            
            // Verificar que sea nulo cuando el caso es nulo
            if caso.value == nil {
                XCTAssert(veredicto == nil, "El caso de prueba era nulo pero se parseó una hora -> \(veredicto!)")
            }
            // Verificar que tenga valor cuando se pasó un caso valido
            else {
                // Verificar que parsee
                XCTAssert(veredicto != nil,
                          "El caso de prueba era valido pero no se pudo parsear una hora -> '\(caso.key)'")
                
                // Verificar que la hora coincida
                XCTAssertEqual(caso.value!.hora,
                               veredicto!.hora,
                               "La hora parseada no coincide para -> '\(caso.key)'")
                
                // Verificar que el minuto
                XCTAssertEqual(caso.value!.minuto,
                               veredicto!.minuto,
                               "El minuto parseado no coincide para -> '\(caso.key)'")
            }
        }
    }
    
    /// Testea la capacidad de obtener las clases a partir de una cadena
    func testObtenerClaseParser() {
        // Casos de prueba
        let casosPrueba: [CasoPruebaClase] = [
            CasoPruebaClase(aula: "G01",
                            cadena: "13:00 - 15:15 (L)",
                            clases: [Clase(value: ["horaInicio": "13:00", "horaFin": "15:15", "aula": "G01"])],
                            dia: .LUNES),
            CasoPruebaClase(aula: "",
                            cadena: "10:00 - 12:15",
                            clases: [Clase(value: ["horaInicio": "10:00", "horaFin": "12:15", "aula": ""])],
                            dia: .MARTES),
            CasoPruebaClase(aula: "G01\nF35",
                            cadena: "07:30 - 09:45 (L) Grupo I\n10:00 - 12:15",
                            clases: [Clase(value: ["horaInicio": "07:30", "horaFin": "09:45", "aula": "G01"]),
                                     Clase(value: ["horaInicio": "10:00", "horaFin": "12:15", "aula": "F35"])],
                            dia: .MIERCOLES),
            CasoPruebaClase(aula: "F35",
                            cadena: "07:30 - 09:45 (L) Grupo I\n10:00 - 12:15",
                            clases: [Clase(value: ["horaInicio": "07:30", "horaFin": "09:45", "aula": "F35"]),
                                     Clase(value: ["horaInicio": "10:00", "horaFin": "12:15", "aula": ""])],
                            dia: .MIERCOLES),
            CasoPruebaClase(aula: nil,
                            cadena: "14:15 - 16.30(L) Grupo Q 12:00 - 14:15 (L) Grupo R",
                            clases: [Clase(value: ["horaInicio": "14:15", "horaFin": "16:30", "aula": "Lab"]),
                                     Clase(value: ["horaInicio": "12:00", "horaFin": "14:15", "aula": "Lab"])],
                            dia: .JUEVES)
        ]
        
        // Probamos cada caso
        for caso in casosPrueba {
            let veredicto = ExcelHelper.obtenerClases(para: caso.cadena, elDia: caso.dia, enAula: caso.aula)
            
            // Verificamos que parsee la misma cantidad
            XCTAssertEqual(caso.clases.count, veredicto.count, "No se parsearon la misma cantidad de clases")
            
            // Verificamos que coincidan los resultados
            for (index, claseGenerada) in veredicto.enumerated() {
                let claseCorrecta = caso.clases[index]
                
                // Verificamos que coincidan las horas
                XCTAssertEqual(claseGenerada.horaInicio, claseCorrecta.horaInicio, "No coinciden las horas de inicio")
                XCTAssertEqual(claseGenerada.horaFin, claseCorrecta.horaFin, "No coinciden las horas de fin")
                
                // Verificamos que coincidan los aulas
                XCTAssertEqual(claseGenerada.aula, claseCorrecta.aula, "No coinciden los aulas")
                
                // Verificamos que se haya cargado el mismo dia
                XCTAssertEqual(claseGenerada.diaEnum, caso.dia, "No coinciden los días")
            }
        }
    }
    
    /// Testea la capacidad de obtener los componentes de una fecha en cadena
    func testObtenerFechaParser() {
        /// Casos de prueba
        let casosPrueba: [CasoPruebaFecha] = [
            CasoPruebaFecha(cadena: "Vie 19/03/21", fecha: DateComponents(year: 2021, month: 3, day: 19)),
            CasoPruebaFecha(cadena: "Lun 24/05/21", fecha: DateComponents(year: 2021, month: 5, day: 24)),
            CasoPruebaFecha(cadena: "Vie 25/06/21", fecha: DateComponents(year: 2021, month: 6, day: 25)),
            CasoPruebaFecha(cadena: "Mar12 9/06/21", fecha: DateComponents(year: 2021, month: 6, day: 9)),
            CasoPruebaFecha(cadena: "Mar 09/0621", fecha: nil),
            CasoPruebaFecha(cadena: "Mar 29/06/2021", fecha: DateComponents(year: 2021, month: 6, day: 29))
        ]
        
        /// Verificación
        for caso in casosPrueba {
            let veredicto = ExcelHelper.obtenerFechaComponentes(para: caso.cadena)
            
            // Verificamos que generen las mismas fechas
            XCTAssertEqual(caso.fecha, veredicto, "No coinciden las fechas")
        }
    }
}

/// Estructura de un caso de prueba de clases
private struct CasoPruebaClase {
    var aula: String?
    var cadena: String
    var clases: [Clase]
    var dia: DiaClase
}

/// Estructura de un caso de prueba de fecha
private struct CasoPruebaFecha {
    var cadena: String
    var fecha: DateComponents?
    
    init(cadena: String, fecha: DateComponents?) {
        self.cadena = cadena
        if fecha != nil {
            // Debe ser en relación a la referencia
            self.fecha = .componentesReferencia
            self.fecha?.day = fecha?.day
            self.fecha?.month = fecha?.month
            self.fecha?.year = fecha?.year
        }
    }
}
