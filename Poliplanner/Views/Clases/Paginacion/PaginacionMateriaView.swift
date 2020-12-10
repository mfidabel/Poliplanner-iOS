//
//  PaginacionMateriaView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
// TODO: Ordenar todo

import SwiftUI
import UIKit
import Parchment

struct PaginacionMateriaView: View {
    let paginas: [InfoPaginaDia]
    
    var body: some View {
        PaginacionMateriaController(paginas: paginas)
    }
    
    struct PaginacionMateriaController: UIViewControllerRepresentable {
        let paginas: [InfoPaginaDia]
        
        func makeUIViewController(context: Context) -> PagingViewController {
            let viewController = PagingViewController(options: .horarioClase)
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: PagingViewController, context: Context) {
            context.coordinator.parent = self
            
            if uiViewController.dataSource == nil {
                uiViewController.dataSource = context.coordinator
            } else {
                uiViewController.reloadData()
            }
        }
        
        func makeCoordinator() -> Coordinator {
          Coordinator(self)
        }
    }
    
    class Coordinator: PagingViewControllerDataSource {
        var parent: PaginacionMateriaController
        
        init(_ parent: PaginacionMateriaController) {
            self.parent = parent
        }
        
        func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
            parent.paginas.count
        }
        
        func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
            let view = PaginaClase(pagina: parent.paginas[index])
            return UIHostingController(rootView: view)
        }
        
        func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
            return PagingIndexItem(index: index, title: parent.paginas[index].dia.rawValue)
        }
    }
}
