import qupath.imagej.gui.ImageJMacroRunner
import qupath.lib.plugins.parameters.ParameterList

// Create a macro runner so we can check what the parameter list contains
def params = new ImageJMacroRunner(getQuPath()).getParameterList()
print ParameterList.getParameterListJSON(params, ' ')

// Change the value of a parameter, using the JSON to identify the key
params.getParameters().get('sendROI').setValue(false)
print ParameterList.getParameterListJSON(params, ' ')

// Get the macro text and other required variables
def macro = new File('C:/Users/timjy/OneDrive - University of Cambridge/CAMBRIDGE PHD/Biochemistry/Scripts and Code/Image J/Microglia nuclei-based watershed from QP v2.ijm').text
def imageData = getCurrentImageData()
createSelectAllObject(true)
def annotation = getSelectedObject()

ImageJMacroRunner.runMacro(params, imageData, null, annotation, macro)
print 'Done!'

