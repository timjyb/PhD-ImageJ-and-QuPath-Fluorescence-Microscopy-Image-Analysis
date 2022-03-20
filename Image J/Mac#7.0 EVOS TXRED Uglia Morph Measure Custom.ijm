//To add in future:
//Make settings into a dialog box
//Allow selection of channel
//Allow customisation of Analyze particles settings
//Allow customisation of rolling ball diameter
//Add some way of recording settings on completion
run("Set Measurements...", "area perimeter bounding fit shape display redirect=None decimal=3");
updateResults();
run("Clear Results");
starting_folder = getDirectory("Select Folder");
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
filetype = ".tif";
//Create new composites folder in which to save all comps
save_bool = getBoolean("Save Output Masks?");
if(save_bool){
	output = starting_folder+"Ib4 Morphology Masks\\";
	File.makeDirectory(output);
}



//Create array of all images in folder
thresh = getNumber("Lower intensity limit for thresholding (Max set at 255)", 5);
img_list = getFileList(starting_folder_only);
Array.print(img_list);

//loop to run through img_list and create tif_list containing all images that are tiffs and are of the TX Red channel
tif_list = newArray(0);
tif_prefix_list = newArray(0);
for(i=0; i<img_list.length; i++){
	curr_img=img_list[i];
	tif_val = indexOf(img_list[i],filetype);
	TXRED_val = indexOf(img_list[i],"TX Red");
		if(tif_val>0){
			if(TXRED_val>0){
				tif_list = Array.concat(tif_list, img_list[i]);
				//tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));
			}
		}
}
dots = ".";
print(dots);
setBatchMode(true);
for(p=0; p<tif_list.length; p++){
	open(starting_folder + tif_list[p]);
	selectWindow(tif_list[p]);
	run("Subtract Background...", "rolling=100");
	setThreshold(thresh, 255);
	run("Convert to Mask");
	run("Open");
	run("Analyze Particles...", "size=500-Infinity show=Masks exclude overlay");
	selectWindow("Mask of " + tif_list[p]);
	run("Smooth");
	run("Convert to Mask");
	run("Fill Holes");
	run("Analyze Particles...", "size=500-6000 show=[Overlay Masks] display exclude summarize");
	if(save_bool){
		saveAs("tiff", output + substring(tif_list[p],0,indexOf(tif_list[p],"TX Red")-1) + " Mask");
	}
	run("Close All");
	dots=dots+" .";
	if(lengthOf(dots)>20){
		dots = ".";
	}
	print("\\Update:"+dots);
}
print("\\Update:Analysis of "+tif_list.length+" images complete, using threshold lower limit of "+thresh+". Masks saved: "+save_bool);
print("Results table available to save");


