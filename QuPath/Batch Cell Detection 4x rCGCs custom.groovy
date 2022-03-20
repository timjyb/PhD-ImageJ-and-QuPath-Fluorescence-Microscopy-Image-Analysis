setImageType('FLUORESCENCE');
clearAllObjects();
createSelectAllObject(true);
runPlugin('qupath.imagej.detect.cells.WatershedCellDetection', '{"detectionImage": "Channel 3",  "backgroundRadius": 15.0,  "medianRadius": 0.0,  "sigma": 1,  "minArea": 10.0,  "maxArea": 1000.0,  "threshold": 10.0,  "watershedPostProcess": true,  "cellExpansion": 5.0,  "includeNuclei": true,  "smoothBoundaries": true,  "makeMeasurements": true}');