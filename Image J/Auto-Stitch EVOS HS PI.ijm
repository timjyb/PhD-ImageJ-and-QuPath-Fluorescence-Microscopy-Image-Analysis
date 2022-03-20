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

xgrid=getNumber("Horizontal Image #", 3);
ygrid=getNumber("Vertical Image #", 4);
starting_folder = getDirectory("Select Folder");
starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
//print(starting_folder);
filetype = ".tif";
//Create new composites folder in which to save all comps
output = starting_folder+"Stitched Images\\";
//print(output);
File.makeDirectory(output);

//Create array of all images in folder
img_list = getFileList(starting_folder_only);
//Array.print(img_list);

//Start loop to run through img_list, selecting each folder iteratively
tif_list = newArray(0);
tif_prefix_list = newArray(0);
well_list = newArray(0);
for(i=0; i<img_list.length; i++){
	curr_img=img_list[i];
	tif_val = indexOf(img_list[i],filetype);
		if(tif_val>0){
			tif_list = Array.concat(tif_list, img_list[i]);
			tif_prefix_list = Array.concat(tif_prefix_list, substring(curr_img, 0, (indexOf(img_list[i], "_")+5)));
			well_list = Array.concat(well_list, substring(curr_img, 0, (indexOf(img_list[i], "_"))));
		}
}
//Array.print(tif_list);
//Array.print(tif_prefix_list);
//now have tif_list, an array of all imgs in the starting folder, excluding any other entries in that folder
//Run through tif_prefix_list and make unique array of image prefixes 
unique_prefix_list = ArrayUnique(tif_prefix_list);
//Array.print(unique_prefix_list);
unique_well_list = ArrayUnique(well_list);
//Array.print(unique_well_list);

//NEED TO EXTRACT DIRECTORY INFO (just starting_folder?), FIRST TILE INDEX #, FILE NAMES FIELD, and how to define extra parameters. NB may be able to save for you
for(k=0; k<unique_well_list.length; k++){
	curr_well = unique_well_list[k];
	first_index_array = newArray(0);
	for(l=0; l<unique_prefix_list.length; l++){
		if(startsWith(unique_prefix_list[l], curr_well)){
			first_index_array = Array.concat(first_index_array, parseInt(substring(unique_prefix_list[l], (indexOf(unique_prefix_list[l], "_")+1))));
		}
	}
	first_index_array_s = Array.sort(first_index_array);
	first_index = first_index_array_s[0];
	curr_well_plus = curr_well+"_";
	print(curr_well_plus);
	print(first_index);
	print(starting_folder);
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x="+xgrid+" grid_size_y="+ygrid+" tile_overlap=20 ;first_file_index_i="+first_index+" directory=["+starting_folder+"] file_names=["+curr_well_plus+"{iiii}.tif] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap ignore_z_stage computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	wait(100);
	saveAs("tiff", output + curr_well + " Stitch");
	run("Close All");
}


