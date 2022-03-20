setImageType('FLUORESCENCE');
clearAllObjects();
createSelectAllObject(true);
runPlugin('qupath.imagej.detect.cells.WatershedCellDetection', '{"detectionImage": "Channel 1",  "backgroundRadius": 0.0,  "medianRadius": 0.0,  "sigma": 5.0,  "minArea": 180.0,  "maxArea": 5000.0,  "threshold": 5.0,  "watershedPostProcess": true,  "cellExpansion": 0.0,  "includeNuclei": true,  "smoothBoundaries": true,  "makeMeasurements": true}');