# PhD-ImageJ-and-QuPath-Fluorescence-Microscopy-Image-Analysis
Contains code written over the course of my PhD, to streamline analysis of fluorescence microscopy images
Most images were epifluorescence microscopy (EVOS M5000) images of microglia or neuron-glia cocultures. Code will need to be modified for data output from alternative imaging systems to fit their specific file name and indexing structures

Example EVOS M5000 image file output for reference:
/Experiment Folder/
  Control Cells 1_0001.tif
  Control Cells 1_0001_DAPI.tif
  Control Cells 1_0001_GFP.tif
  Control Cells 1_0001_TX Red.tif
  Control Cells 1_0001_TRANS.tif
  Control Cells 1_0002.tif
  etc etc
  
"Control Cells 1" represents the user classified image name, 0001 represents the index of the image, DAPI/GFP/TX Red/TRANS represent the individual images for each channel
  

Image J macros facilitating batch processing and analysis - typically, macros include a file browser to specify the folder to analyse, which should directly contain all images to be analysed indexed appropriately by the imaging system (see example above to see what file structure I designed the macros to work with)
   - creation of composites from individual channel images, with GUI dialog boxes to customise the channels used and customise the application of rolling ball background subtraction and extra commands to each channel image prior to compositing
   - general thresholding and particle analysis for "positive-area" type analysis, or individual cell area and shape analysis
   - "from QP" macros designed to be run through QuPath for microglial morphology analysis, typically after classification of microglial nuclei via QuPath ML classification techniques

QuPath scripts enabling useful commands to be 'Run for project' via the QuPath script editor:
   - application of watershed cell detection algorithms
   - application of extra feature calculation commands
   - application of classifiers
   - application of Resolve Hierarchy command
   - export of images to Image J via the QuPath interface and application of a specified Image J macro to the image (again, can be run for the entire project when needed)
