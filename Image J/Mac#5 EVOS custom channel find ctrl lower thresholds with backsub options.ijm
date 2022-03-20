starting_folder = getDirectory("Select Folder");
setBatchMode(false);
Dialog.create("Custom analysis of average auto threshold lower bound for control images");
Dialog.addString("Prefix for control images from which to get autothreshold information?", "Control");
ch_options = newArray("DAPI", "GFP", "TX Red");
Dialog.addChoice("Image channel to anaylse", ch_options, "TX Red");
Dialog.addCheckbox("Rolling ball background subtraction before thresholding?", true);
Dialog.addNumber("Rolling ball radius:", 100);
Dialog.show();
ctrl_prefix = Dialog.getString();
channel = Dialog.getChoice();
backsub_bool = Dialog.getCheckbox();
backsub = Dialog.getNumber();

//channel = getString("DAPI, GFP, or TX Red", "TX Red");
//backsub_bool = getBoolean("Use rolling ball background subtraction?");
//if(backsub_bool){
//	backsub = getNumber("Rolling ball background subtraction radius to use", 100);
//}
//ctrl_prefix = getString("Prefix for control images from which to get autothreshold information?", "");
if(backsub_bool){
	print("Extracting lower autothreshold bound values from '"+ctrl_prefix+"' "+channel+" images with "+backsub+" pixel background subtraction");
}
else {
	print("Extracting lower autothreshold bound values from '"+ctrl_prefix+"' "+channel+" images with no background subtraction");
}
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
	tif_val = indexOf(curr_img,filetype);
	channel_val = indexOf(curr_img,channel);
	ctrl_val = indexOf(curr_img, ctrl_prefix);
		if(tif_val>0){
			if(channel_val>=0){
				if(ctrl_val>=0){
				tif_list = Array.concat(tif_list, curr_img);
				//tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));	
				}
			}
		}
}
//Array.print(tif_list);
setBatchMode(true);
ctrl_thresholds = newArray(0);
dots = ".";
print(dots);
for(p=0; p<tif_list.length; p++){
	open(starting_folder + tif_list[p]);
	selectWindow(tif_list[p]);
	if(backsub_bool){
		run("Subtract Background...", "rolling="+backsub);
	}
	setAutoThreshold("Default dark");
	getThreshold(lower, upper);
	ctrl_thresholds = Array.concat(ctrl_thresholds,lower);
	run("Close All");
	dots=dots+" .";
	print("\\Update:"+dots);
	//print(dots);
}
Array.print(ctrl_thresholds);
Array.getStatistics(ctrl_thresholds, min, max, mean, stdDev);
if(backsub_bool){
	print("Average control "+channel+" image lower threshold using "+backsub+" pixel background subtraction and default autothresholding:"+mean);
}
else {
	print("Average control "+channel+" image lower threshold using default autothresholding with no prior background subtraction:"+mean);
}
