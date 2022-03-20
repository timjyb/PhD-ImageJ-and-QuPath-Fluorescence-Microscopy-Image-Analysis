starting_folder = getDirectory("Select Folder");

setBatchMode(false);
Dialog.create("Analysis options using background subtraction and autothresholding (e.g. to measure % positive area of image)");
ch_options = newArray("DAPI", "GFP", "TX Red");
Dialog.addChoice("Image channel to anaylse", ch_options, "TX Red");
Dialog.addCheckbox("Rolling ball background subtraction before thresholding?", true);
Dialog.addNumber("Rolling ball radius:", 100);
Dialog.addNumber("Lower threshold limit to use:", 5);
Dialog.show();
channel = Dialog.getChoice();
backsub_bool = Dialog.getCheckbox();
backsub = Dialog.getNumber();
lower = Dialog.getNumber();;

if(backsub_bool){
	print("Analysing "+channel+" images with "+backsub+" pixel background subtraction and threshold lower limit set to "+lower);
}
else {
	print("Analysing "+channel+" images with no background subtraction and threshold lower limit set to "+lower);
}
//lower = getNumber("Lower Threshold to Use", 0);
//print("Analysing images based on lower threshold of "+lower);
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
filetype = ".tif";
//Create new composites folder in which to save all comps
//output = starting_folder+"Ib4 Morphology Masks\\";
//print(output);
//File.makeDirectory(output);

//Create array of all images in folder
img_list = getFileList(starting_folder_only);
//Array.print(img_list);

//loop to run through img_list and create tif_list containing all images that are tiffs and are of the TX Red channel
tif_list = newArray(0);
tif_prefix_list = newArray(0);
for(i=0; i<img_list.length; i++){
	curr_img=img_list[i];
	tif_val = indexOf(img_list[i],filetype);
	channel_val = indexOf(img_list[i], channel);
		if(tif_val>0){
			if(channel_val>=0){
				tif_list = Array.concat(tif_list, img_list[i]);
				//tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));
			}
		}
}
setBatchMode(true);
dots = ".";
print(dots);
Table.create("Summary");
if(!backsub_bool){
	backsub="NA";
}
Table.set("Channel", 0, channel);
Table.set("Backsub radius", 0, backsub);
Table.set("Lower threshold", 0, lower);
for(p=0; p<tif_list.length; p++){
	open(starting_folder + tif_list[p]);
	selectWindow(tif_list[p]);
	if(backsub_bool){
		run("Subtract Background...", "rolling="+backsub);
	}
	setThreshold(lower, 255);
	run("Convert to Mask");
	run("Analyze Particles...", "summarize");
	//saveAs("tiff", output + substring(tif_list[p],0,indexOf(tif_list[p],"TX Red")-1) + " Mask");
	run("Close All");
	dots=dots+" .";
	if(lengthOf(dots)>20){
		dots = ".";
	}
	print("\\Update:"+dots);
}
if(backsub_bool){
	print("\\Update:Analysis of "+tif_list.length+" "+channel+" images complete, using "+backsub+" pixel background subtraction and threshold lower limit of "+lower);
	print("Summary table available to save");
}
else {
	print("\\Update:Analysis of "+tif_list.length+" "+channel+" images complete, without background subtraction and using a threshold lower limit of "+lower);
	print("Summary table available to save");
}
saveAs("Results");