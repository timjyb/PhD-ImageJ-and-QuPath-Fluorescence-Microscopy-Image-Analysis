// Run macro manually on exported Full Classifier annotated image (i.e. with detection overlays) from QuPath

// Will retain and label all images from processing steps, available to view

// v2 changes: 
// - Huang autothresholding used (determined to be the best for this analyis, and works
//   for all microglial morphologies equally well by eye
// - Gaussian filter included before thresholding to improve thresholding of speckly-stained cells

// Possible future QoL changes:
// - Extra log outputs?
// - customisation
// - embedding of metadata in results table

// Get image name for current processing image and correct for deprecated " " coding
img = getInfo("image.filename");
img = replace(img, "\\%20", " ");

//Duplicate to retain original overlays as example and create image for Ib4 masks
rename("Only Microglia Nuclei Overlays");
run("Duplicate...", "duplicate");
rename("Original Image from QuPath");
run("Duplicate...", "  channels=1");
rename("For TXRED extraction");

// Delete overlay objects of non-microglial cells
selectWindow("Only Microglia Nuclei Overlays");
Overlay.copy;
Overlay.removeRois("PathAnnotationObject");
Overlay.removeRois("Neuron - nucleus");
Overlay.removeRois("Astrocyte - nucleus");
Overlay.removeRois("Other - nucleus");
Overlay.removeRois("Dead Cells - nucleus");
Overlay.removeRois("Debris - nucleus");
Overlay.removeRois("Neuron");
Overlay.removeRois("Astrocyte");
Overlay.removeRois("Other");
Overlay.removeRois("Dead Cells");
Overlay.removeRois("Debris");
Overlay.removeRois("Microglia");
Overlay.remove;
Overlay.paste;

// Take microglial nuclei objects to ROI manager, select all, and create a mask image of them
run("To ROI Manager");
run("Select All");
roiManager("Combine");
run("Create Mask");
rename("Microglial Nuclei");

// Make Ib4 Mask from previously copied channel 1 image
selectWindow("For TXRED extraction");
Overlay.remove;
run("Subtract Background...", "rolling=100");
run("Gaussian Blur...", "sigma=2");
setAutoThreshold("Huang dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Close-");
rename("Ib4 Mask");

//create edge outlines image using built-in ImageJ Find Edges
run("Duplicate...", " ");
rename("Ib4 Edges");
run("Find Edges");

//apply MorphoLibJ Marker-based Watershed Segmentation, with Ib4 Edges as input,
//Microglial Nuclei as Marker, and Ib4 Mask as Mask to cover background. Then threshold output to make into a binary mask
run("Marker-controlled Watershed", "input=[Ib4 Edges] marker=[Microglial Nuclei] mask=[Ib4 Mask] compactness=0 binary calculate use");
setThreshold(0.00000000001, 1000000000000000000000000000000.0000);
setOption("BlackBackground", false);
run("Convert to Mask");
rename(img);

// Mask cleanup - fill holes, crop image edge pixels (as were all set to 0 by close operation,
// which then means analyse particles cannot exclude objects touching image edges)
selectWindow(img);
run("Fill Holes");
makeRectangle(1, 1, 2046, 1534);
run("Crop");
run("Convert to Mask");

// Prepare results table and analyse all particles (crap will already be excluded by watershed, so can accept all particles)
run("Set Measurements...", "area perimeter bounding fit shape display redirect=None decimal=3");
updateResults();
run("Analyze Particles...", "size=0.0-Infinity display exclude");
print(img+" analysed");
rename("Segmented Microglia");
