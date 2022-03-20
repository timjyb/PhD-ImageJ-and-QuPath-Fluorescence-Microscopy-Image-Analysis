//7.1 updates: Streamlined analysis protocol, one analyse particles step removed; Dialog added to choose settings; metadata now
//embedded in results table, and in output folder name and metadata txt file within if choosing to save masks
//To add in future:
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
month=month+1;
year = substring(year, 2);
if(month<10){
	month="0"+month;
}
if(dayOfMonth<10){
	dayOfMonth="0"+dayOfMonth;
}
if(second<10){
	second="0"+second;
}
if(minute<10){
	minute="0"+minute;
}
if(hour<10){
	hour="0"+hour;
}
date= year+"-"+month+"-"+dayOfMonth;
print(date);

starting_folder = getDirectory("Select Folder");
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
filetype = ".tif";

setBatchMode(false);
Dialog.create("Measure Objects Settings");
ch_options = newArray("DAPI", "GFP", "TX Red");
Dialog.addChoice("Image channel to anaylse", ch_options, "TX Red");
Dialog.addCheckbox("Rolling ball background subtraction before thresholding?", true);
Dialog.addNumber("Rolling ball radius:", 100);
Dialog.addNumber("Lower threshold limit to use:", 5);
Dialog.addNumber("Lower particle size limit:", 500);
Dialog.addNumber("Upper particle size limit:", 6000);
Dialog.addCheckbox("Have macro create an output folder and save masks?", false);
Dialog.show();
channel = Dialog.getChoice();
backsub_bool = Dialog.getCheckbox();
backsub = Dialog.getNumber();
lower = Dialog.getNumber();;
part_lower = Dialog.getNumber();;;
part_upper = Dialog.getNumber();;;;
save_bool = Dialog.getCheckbox();;
if(!backsub_bool){
	backsub="NA";
}
//Create new composites folder in which to save all comps
if(save_bool){
	output = starting_folder+year+""+month+""+dayOfMonth+" "+hour+"-"+minute+"-"+second+" Particle analysis masks/";
	File.makeDirectory(output);
}



//Create array of all images in folder
img_list = getFileList(starting_folder_only);
Array.print(img_list);

//loop to run through img_list and create tif_list containing all images that are tiffs and are of the TX Red channel
tif_list = newArray(0);
tif_prefix_list = newArray(0);
for(i=0; i<img_list.length; i++){
	curr_img=img_list[i];
	tif_val = indexOf(img_list[i],filetype);
	ch_val = indexOf(img_list[i],channel);
		if(tif_val>0){
			if(ch_val>0){
				tif_list = Array.concat(tif_list, img_list[i]);
				//tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));
			}
		}
}
dots = ".";
print(dots);
setBatchMode(true);
run("Set Measurements...", "area perimeter bounding fit shape display redirect=None decimal=3");
updateResults();
run("Clear Results");
for(p=0; p<tif_list.length; p++){
	open(starting_folder + tif_list[p]);
	selectWindow(tif_list[p]);
	if(backsub_bool){
		run("Subtract Background...", "rolling="+backsub);
		//print(backsub_bool+" "+backsub);
	}
	setThreshold(lower, 255);
	run("Convert to Mask");
	run("Open");
	run("Smooth");
	run("Convert to Mask");
	run("Fill Holes");
	run("Analyze Particles...", "size="+part_lower+"-"+part_upper+" show=[Overlay Masks] display exclude summarize");
	if(save_bool){
		saveAs("tiff", output + substring(tif_list[p],0,indexOf(tif_list[p],"TX Red")-1) + " Mask");
	}
	run("Close All");
	dots=dots+" .";
	if(lengthOf(dots)>20){
		dots = ".";
	}
	print("\\Update:"+dots);
	//print(dots);
}
selectWindow("Results");
Table.set("Folder", 0, starting_folder_only);
Table.set("Channel", 0, channel);
Table.set("Backsub radius", 0, backsub);
Table.set("Lower threshold", 0, lower);
Table.set("Lower particle limit", 0, part_lower);
Table.set("Upper particle limit", 0, part_upper);
Table.set("Date (YYMMDD)", 0, date);
if(save_bool){
	text_meta_path = output + "Particle analysis metadata.txt";
	f = File.open(text_meta_path);
	print(f, dayOfMonth+"/"+month+"/"+year+" \r"+hour+":"+minute+":"+second+" \r"+"Channel analysed: "+channel+ " \r"+
	"Rolling ball background subtraction?: "+backsub_bool+" \r"+"Rolling ball radius: "+backsub+" \r"+
	"Lower threshold: "+lower+" \r"+"Particle size: "+part_lower+"-"+part_upper);
}
print("\\Update:Analysis of "+tif_list.length+" images complete. Masks saved alongside metadata.txt: "+save_bool);
print("Results table available to save (metadata embedded)");
saveAs("Results");

