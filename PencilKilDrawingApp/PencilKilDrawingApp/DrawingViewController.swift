//
//  DrawingViewController.swift
//  PencilKilDrawingApp
//
//  Created by Shanaka Senevirathne on 15/2/21.
//

import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    var sketch: Sketch?
    var canvasView: PKCanvasView!
    private var selectedPenIndex = 0
    var sketchDataSource: SketchDataSource?
    
    @IBOutlet weak var allowFingerButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var redoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftItemsSupplementBackButton = true
        
        let canvasView = PKCanvasView(frame: view.bounds)
        self.canvasView = canvasView
        canvasView.allowsFingerDrawing = false
        view.addSubview(canvasView)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        canvasView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        canvasView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        canvasView.backgroundColor = UIColor.lightGray
        
        setupSimpleTools()
    }
    
    @IBAction func togglePencil(_ sender: UIBarButtonItem) {
        canvasView.allowsFingerDrawing.toggle()
        allowFingerButton.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
    }
    
    func setupSimpleTools() {
        let segmentedControl = UISegmentedControl(items: ["Black", "Red"])
        segmentedControl.selectedSegmentIndex = 0
        let barButtonItem = UIBarButtonItem(customView: segmentedControl)
        segmentedControl.addTarget(self, action: #selector(penChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItems?.append(barButtonItem)
        
        updatePen()
    }
    
    @objc
    func penChanged(_ sender: UISegmentedControl) {
        selectedPenIndex = sender.selectedSegmentIndex
        
        updatePen()
    }
    
    func updatePen() {
        if selectedPenIndex == 0 {
            canvasView.tool = PKInkingTool(.pen, color: .systemFill, width: 10)
        } else {
            canvasView.tool = PKInkingTool(.pen, color: .systemRed, width: 10)
        }
    }
}
