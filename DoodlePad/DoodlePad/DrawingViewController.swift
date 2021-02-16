//
//  DrawingViewController.swift
//  DoodlePad
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
        
        if let sketch = sketch {
            canvasView.drawing = sketch.drawing
        }
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        canvasView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        canvasView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        canvasView.backgroundColor = UIColor.lightGray
        
//        setupSimpleTools()
        setupToolPicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateSketch()
    }
    
    func updateSketch() {
        guard let sketch = sketch else { return }
        sketch.drawing = canvasView.drawing
        sketchDataSource?.generateThumbnail(for: sketch)
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
    
    func setupToolPicker() {
        if let window = self.parent?.view.window,
           let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
            
            toolPicker.addObserver(self)
            updateTools(toolPicker)
        }
    }
    
    @IBAction func undo(_ sender: UIBarButtonItem) {
        undoManager?.undo()
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
        undoManager?.redo()
    }
}

extension DrawingViewController: PKToolPickerObserver {
    func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        if let tool = toolPicker.selectedTool as? PKEraserTool {
            print("Eraser: \(tool.eraserType)")
        } else if let tool = toolPicker.selectedTool as? PKInkingTool {
            print("Int: \(tool.inkType) Color: \(tool.color) Width: \(tool.width)")
        } else if let _ = toolPicker.selectedTool as? PKLassoTool {
            print("Lasso tool")
        }
    }
    
    func toolPickerIsRulerActiveDidChange(_ toolPicker: PKToolPicker) {
        print("Ruler active: \(toolPicker.isRulerActive)")
    }
    
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
       updateTools(toolPicker)
    }
    
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        updateTools(toolPicker)
    }
    
    func updateTools(_ toolPicker: PKToolPicker) {
        let obscuredFrame = toolPicker.frameObscured(in: view)
        if obscuredFrame.isNull {
            navigationItem.leftBarButtonItems = []
        } else {
            navigationItem.leftBarButtonItems = [undoButton, redoButton]
        }
    }
}
