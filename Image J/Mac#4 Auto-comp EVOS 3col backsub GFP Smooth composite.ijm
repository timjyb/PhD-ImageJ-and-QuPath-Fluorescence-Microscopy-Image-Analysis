//FUNCTIONS...............................................
array=newArray(1);
function ArrayUnique(array) {
	array	= Array.sort(array);
	array 	= Array.concat(array, 999999);
	uniqueA = newArray();
	i = 0;	
   	while (i<(array.length)-1) {
		if (array[i] == array[(i)+1]) {
			//print("found: "+array[i]);			
		} else {
			uniqueA = Array.concat(uniqueA, array[i]);
		}
   		i++;
   	}
	return uniqueA;
}


starting_folder = getDirectory("Select Folder");
BSrad = getNumber("Rolling ball background subtraction radius (px) to apply to each channel. E.g. 100px gives good broad subtraction for 10x images", 100);
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
//print(starting_folder);
desired_channels = newArray("DAPI", "TX Red", "GFP");
//choose custom colour-channel designation
//ch_defs = newArray(getString("Red - intended channel", "NA"),getString("Green - intended channel", "NA"), getString("Blue - intended channel", "NA"),
//getString("Grey - intended channel", "NA"), getString("Cyan - intended channel", "NA"), getString("Magenta - intended channel", "NA"),
//getString("Yellow - intended channel", "NA"));
//Array.print(ch_defs);
filetype = ".tif";
//Create new composites folder in which to save all comps
output = starting_folder+"3col_BS Mac#4_rad"+BSrad+"_GFP_Smooth\\";
//print(output);
File.makeDirectory(output);

//Create array of all images in folder
img_list = getFileList(starting_folder_only);
Array.print(img_list);

//Start loop to run through cond_list, selecting each folder iteratively
tif_list = newArray(0);
tif_prefix_list = newArray(0);
for(i=0; i<img_list.length; i++){
	curr_img=img_list[i];
	tif_val = indexOf(img_list[i],filetype);
		if(tif_val>0){
			tif_list = Array.concat(tif_list, img_list[i]);
			tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));
		}
}
//Array.print(tif_list);
//Array.print(tif_prefix_list);
//now have tif_list, an array of all imgs in the starting folder, excluding any other entries in that folder
//Run through tif_prefix_list and make unique array of image prefixes 
unique_prefix_list = ArrayUnique(tif_prefix_list);
//Array.print(unique_prefix_list);

for(k=0; k<unique_prefix_list.length; k++){
	print(unique_prefix_list[k]);
	for(p=0; p<tif_list.length; p++){
		if(indexOf(tif_list[p], unique_prefix_list[k]+"_TX Red")>=0){
			//print(img_fold_path + img_tifs[p])
			open(starting_folder + tif_list[p]);
			selectWindow(tif_list[p]);
			run("Subtract Background...", "rolling="+BSrad);
			
		}
		if(indexOf(tif_list[p], unique_prefix_list[k]+"_GFP")>=0){
			//print(img_fold_path + img_tifs[p])
			open(starting_folder + tif_list[p]);
			selectWindow(tif_list[p]);
			run("Subtract Background...", "rolling="+BSrad);
			run("Smooth");
		}
		if(indexOf(tif_list[p], unique_prefix_list[k]+"_DAPI")>=0){
			//print(img_fold_path + img_tifs[p])
			open(starting_folder + tif_list[p]);
			selectWindow(tif_list[p]);
			run("Subtract Background...", "rolling="+BSrad);
		
		}
	}
	wait(20);
	//set up merge channel instruction based on starting information
	merge_instr = " c1=[" + unique_prefix_list[k] + "_TX Red.tif] c2=[" + unique_prefix_list[k] + "_GFP.tif] c3=[" + unique_prefix_list[k] + "_DAPI.tif] create";
	print(merge_instr);
//	for(l=0; l<ch_defs.length; l++){
	//	if(indexOf(ch_defs[l], "NA")<0){
		//	merge_instr = merge_instr + "c" + (l+1) + "=" + unique_img_pref_list[k] + ch_defs[l] + ".tif ";
			//print(instr_string);
	//	}
	//perform merge channel
	//merge_instr = merge_instr + "create";
	//print(merge_instr);
	run("Merge Channels...", merge_instr);
	//Save to new directory as set up at the start, close and move on
	saveAs("tiff", output + unique_prefix_list[k] + "_3col_BS_GFP_SM");
	//close();
	run("Close All");
}


