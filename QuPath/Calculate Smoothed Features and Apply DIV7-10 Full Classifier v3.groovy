resetDetectionClassifications();
selectAnnotations();
runPlugin('qupath.lib.plugins.objects.SmoothFeaturesPlugin', '{"fwhmPixels": 20.0,  "smoothWithinClasses": false}');
runObjectClassifier("2202 CGC DIV7-10 Full HNIb RT Classifier v3");