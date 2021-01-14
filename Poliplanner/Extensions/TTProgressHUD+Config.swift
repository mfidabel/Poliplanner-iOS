//
//  TTProgressHUD+Config.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-13.
//

import Foundation
import TTProgressHUD

extension TTProgressHUDConfig {
    // MARK: Configuraciones
    
    /// Progreso al importar un horario
    static func importandoHorario(nombreHorario nombre: String) -> TTProgressHUDConfig {
        TTProgressHUDConfig(title: "Importando horario", caption: nombre)
    }
    
    /// Progreso cuando se termina de importar
    static func horarioImportado(nombreHorario nombre: String) -> TTProgressHUDConfig {
        TTProgressHUDConfig(type: .Success,
                            title: "Horario importado",
                            caption: nombre,
                            shouldAutoHide: true,
                            autoHideInterval: 1.0)
    }
    
    /// Error de importación
    static let errorImportar: TTProgressHUDConfig = TTProgressHUDConfig(type: .Error,
                                                                        title: "Error al importar",
                                                                        shouldAutoHide: true,
                                                                        autoHideInterval: 3.0)
    
    /// Advertencia de importación
    static func advertencia(_ caption: String) -> TTProgressHUDConfig {
        TTProgressHUDConfig(type: .Warning, caption: caption, shouldAutoHide: true, autoHideInterval: 3.0)
    }
}
