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
    

  
  }
  
}
