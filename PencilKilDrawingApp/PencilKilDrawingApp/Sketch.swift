//
//  Sketch.swift
//  PencilKilDrawingApp
//
//  Created by Shanaka Senevirathne on 15/2/21.
//

import Foundation
import PencilKit

class Sketch {
    
  var thumbnailImage: UIImage?
  var drawing: PKDrawing
  
  init(drawing: PKDrawing) {
    self.drawing = drawing
  }
}

class SketchDataSource {
  var sketches: [Sketch] = []
  
  func addDrawing() {
    let sketch = Sketch(drawing: PKDrawing())
    sketches.append(sketch)
  }
  
  var count: Int {
    return sketches.count
  }
}
