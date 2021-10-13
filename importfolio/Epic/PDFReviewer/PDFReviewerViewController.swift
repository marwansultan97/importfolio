//
//  PDFReviewerViewController.swift
//  importfolio
//
//  Created by Marwan Osama on 12/10/2021.
//

import UIKit
import PDFKit

class PDFReviewerViewController: UIViewController, Storyboarded {

    @IBOutlet weak var pdfView: PDFView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPDF()
        
        let button = UIBarButtonItem(image: UIImage(named: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func share() {
        guard let url = url, let pdfDocument = PDFDocument(url: url), let data = pdfDocument.dataRepresentation() else { print("Empty URL"); return }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
            let alertController = UIAlertController(title: "Error", message: "Document was not found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func setupPDF() {
        title = "PDF"
        if let url = url, let pdfDocument = PDFDocument(url: url) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
        }
    }
    
    

}
