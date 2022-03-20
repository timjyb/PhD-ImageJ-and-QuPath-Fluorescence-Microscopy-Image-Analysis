starting_folder = getDirectory("Select Folder");

setBatchMode(false);
Dialog.create("Analysis options");
ch_options = newArray("red", "green", "blue");
Dialog.addChoice("Image channel to anaylse", ch_options, "red");
Dialog.addNumber("Rolling ball radius:", 100);
Dialog.show();
channel = Dialog.getChoice();
backsub = Dialog.getNumber();

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
	channel_val = indexOf(img_list[i], "RGB Trans");
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
//Table.create("Summary");
//Table.set("Channel", 0, channel);
//Table.set("Backsub radius", 0, backsub);
for(p=0; p<tif_list.length; p++){
	open(starting_folder + tif_list[p]);
	selectWindow(tif_list[p]);
	run("Split Channels");
	selectWindow(tif_list[p] +" (blue)");
	close();
	selectWindow(tif_list[p] +" (green)");
	close();
	selectWindow(tif_list[p] +" (red)");
	run("Subtract Background...", "rolling="+backsub+" light");
	run("Invert");
	run("Gaussian Blur...", "sigma=5");
	run("Find Maxima...", "prominence=25 output=Count");
	//saveAs("tiff", output + substring(tif_list[p],0,indexOf(tif_list[p],"TX Red")-1) + " Mask");
	run("Close All");
	dots=dots+" .";
	if(lengthOf(dots)>20){
		dots = ".";
	}
	print("\\Update:"+dots);
}

saveAs("Results");