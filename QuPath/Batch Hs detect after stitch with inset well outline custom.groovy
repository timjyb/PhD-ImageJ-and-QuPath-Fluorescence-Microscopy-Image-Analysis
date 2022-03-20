
setImageType('FLUORESCENCE');
clearAllObjects();
//get width and height
def server = getCurrentServer()
def metadata = server.getMetadata()
def width = metadata.getAt('width')
def height = metadata.getAt('height')
//create well ellipse annotation
import qupath.lib.objects.PathObjects
import qupath.lib.roi.ROIs
import qupath.lib.regions.ImagePlane

int z = 0
int t = 0
def inset = 15
def plane = ImagePlane.getPlane(z, t)
def roi = ROIs.createEllipseROI(inset, inset, width-(inset*2), height-(inset*2), plane)
def annotation = PathObjects.createAnnotationObject(roi)
addObject(annotation)

selectAnnotations()

runPlugin('qupath.imagej.detect.cells.WatershedCellDetection', '{"detectionImage": "Channel 3",  "backgroundRadius": 0,  "medianRadius": 0.0,  "sigma": 2.0,  "minArea": 10.0,  "maxArea": 500.0,  "threshold": 5.0,  "watershedPostProcess": true,  "cellExpansion": 5.0,  "includeNuclei": true,  "smoothBoundaries": true,  "makeMeasurements": true}');
