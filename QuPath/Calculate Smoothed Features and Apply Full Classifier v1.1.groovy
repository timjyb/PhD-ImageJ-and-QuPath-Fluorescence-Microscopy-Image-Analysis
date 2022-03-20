resetDetectionClassifications();
selectAnnotations();
runPlugin('qupath.lib.plugins.objects.SmoothFeaturesPlugin', '{"fwhmPixels": 20.0,  "smoothWithinClasses": false}');
runObjectClassifier("211117 Full Classifier v1.1");