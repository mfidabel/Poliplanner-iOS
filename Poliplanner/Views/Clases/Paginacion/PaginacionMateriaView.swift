//
//  PaginacionMateriaView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
// TODO: Ordenar todo

import SwiftUI
import UIKit
import Parchment

// MARK: - View de Paginación

/// View que convierte páginas de clases en una Interfaz paginada
struct PaginacionMateriaView: View {
    // MARK: Propiedades
    
    /// La información de las páginas que se van a mostrar
    let paginas: [InfoPaginaDia]
    
    // MARK: Body
    
    var body: some View {
        PaginacionMateriaController(paginas: paginas)
    }
    
    // MARK: SwiftUI View Controller
    
    /// View Controller que funciona de puente de `PagingViewController` a SwiftUI
    struct PaginacionMateriaController: UIViewControllerRepresentable {
        // MARK: Propiedades
        
        /// La información de las páginas que se van a mostrar
        let paginas: [InfoPaginaDia]
        
        // MARK: Protocolo UIViewControllerRepresentable
        
        /// Genera el `PagingViewController` del View
        func makeUIViewController(context: Context) -> PagingViewController {
            let viewController = PagingViewController(options: .horarioClase)
            return viewController
        }
        
        /// Actualiza el view controller cuando hay cambios.
        /// En este caso, asigna el data source si todavia no lo ha hecho.
        /// Si ya tiene un data source, entonces procede a recargar los datos.
        func updateUIViewController(_ uiViewController: PagingViewController, context: Context) {
            context.coordinator.parent = self
            
            if uiViewController.dataSource == nil {
                uiViewController.dataSource = context.coordinator
            } else {
                uiViewController.reloadData()
            }
        }
        
        /// Crea un coordinador para el `PagingViewController`
        func makeCoordinator() -> Coordinator {
          Coordinator(self)
        }
    }
    
    // MARK: Coordinador
    
    /// Coordinador de `PaginacionMateriaController`
    class Coordinator: PagingViewControllerDataSource {
        // MARK: Propiedades
        
        /// `PaginacionMateriaController` que usaremos para obtener la información
        var parent: PaginacionMateriaController
        
        // MARK: Constructor
        
        /// Constructor para el coordinador (data source) de `PaginacionMateriaController`
        /// - Parameter parent: `PaginacionMateriaController` que usaremos para obtener los datos
        init(_ parent: PaginacionMateriaController) {
            self.parent = parent
        }
        
        // MARK: Protocolo PagingViewControllerDataSource
        
        /// Número de páginas
        func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
            parent.paginas.count
        }
        
        /// Página para cada índice
        func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
            let view = PaginaClase(pagina: parent.paginas[index])
            return UIHostingController(rootView: view)
        }
        
        /// Item de Página para cada índice
        func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
            return PagingIndexItem(index: index, title: parent.paginas[index].dia.rawValue)
        }
    }
}
