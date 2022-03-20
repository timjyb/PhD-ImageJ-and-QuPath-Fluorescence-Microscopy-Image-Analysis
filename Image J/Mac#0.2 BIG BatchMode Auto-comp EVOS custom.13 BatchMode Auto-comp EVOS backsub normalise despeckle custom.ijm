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

//dialog to pick folder with images to process
folders = newArray(0);
folder_names = newArray(0);
another_folder_bool = "Yes - queue another folder for processing";
while (another_folder_bool == "Yes - queue another folder for processing"){
	new_folder = getDirectory("Select Folder");
	new_folder_name = File.getName(new_folder);
	folders = Array.concat(folders, new_folder);
	folder_names = Array.concat(folder_names, new_folder_name);
	yesno = newArray("Yes - queue another folder for processing", "No - continue to processing options");
	Dialog.create("Add another folder to the queue?");
	Dialog.addRadioButtonGroup("", yesno, 1, 2, "Yes - queue another folder for processing");
	Dialog.show();
	another_folder_bool = Dialog.getRadioButton();
}
numfolders = folders.length;
print(numfolders+" folders queued for processing:");
Array.print(folder_names);


//dialog to define channels to use 
channels = newArray("DAPI only", "GFP only", "TXRED only", "DAPI-GFP", "DAPI-TXRED", "GFP-TXRED", "DAPI-GFP-TXRED");

Dialog.create("Channel selection");
Dialog.addChoice("Channels to composite:", channels, "DAPI-GFP-TXRED");
Dialog.addCheckbox("Perform extra image processing?", true);
Dialog.addCheckbox("Include TRANS?", false);
Dialog.show();
process_bool = Dialog.getCheckbox();
TRANS_bool = Dialog.getCheckbox();;
chosen_ch = Dialog.getChoice();
DAPI_bool = (indexOf(chosen_ch, "DAPI")>=0);
GFP_bool = (indexOf(chosen_ch, "GFP")>=0);
TXRED_bool = (indexOf(chosen_ch, "TXRED")>=0);
if(process_bool){
	Dialog.create("Processing settings");
	Dialog.addCheckbox("Use same settings for each channel?", true);
	Dialog.show();
	same_set = Dialog.getCheckbox();
	
	
	//dialog to decide how to process each channel, either collectively or separately depending on same_set variable defined in previous dialog
	Dialog.create("Fluorescence processing customisation");
	DAPI_BSbool = "NA";
	GFP_BSbool = "NA";
	TXRED_BSbool = "NA";
	DAPI_rad = "NA";
	DAPI_norm = "NA";
	DAPI_despeckle = "NA";
	GFP_rad = "NA";
	GFP_norm = "NA";
	GFP_despeckle = "NA";
	TXRED_rad = "NA";
	TXRED_norm = "NA";
	TXRED_despeckle = "NA";
	if(same_set){
		Dialog.addMessage("All channels Processing               ", 18);
		Dialog.addCheckbox("Rolling ball background subtraction?", true);
		Dialog.addNumber("Rolling ball radius:", 100);
		Dialog.addCheckbox("Normalise intensity histograms?", false);
		Dialog.addCheckbox("Despeckle?", false);
		Dialog.show();
		DAPI_BSbool = Dialog.getCheckbox();
		GFP_BSbool = DAPI_BSbool;
		TXRED_BSbool = DAPI_BSbool;
		DAPI_rad = Dialog.getNumber();
		GFP_rad = DAPI_rad;
		TXRED_rad = DAPI_rad;
		DAPI_norm = Dialog.getCheckbox();;
		GFP_norm = DAPI_norm;
		TXRED_norm = DAPI_norm;
		DAPI_despeckle = Dialog.getCheckbox();;;
		GFP_despeckle = DAPI_despeckle;
		TXRED_despeckle = DAPI_despeckle;
	}
	else {
		if(DAPI_bool){
			Dialog.addMessage("DAPI Processing                   ", 18);
			Dialog.addCheckbox("Rolling ball background subtraction?", true);
			Dialog.addNumber("Rolling ball radius:", 100);
			Dialog.addCheckbox("Normalise intensity histogram?", false);
			Dialog.addCheckbox("Despeckle?", false);
		}
		if(GFP_bool){
			Dialog.addMessage("GFP Processing                   ", 18);
			Dialog.addCheckbox("Rolling ball background subtraction?", true);
			Dialog.addNumber("Rolling ball radius:", 100);
			Dialog.addCheckbox("Normalise intensity histogram?", false);
			Dialog.addCheckbox("Despeckle?", false);
		}
		if(TXRED_bool){
			Dialog.addMessage("TXRED Processing                   ", 18);
			Dialog.addCheckbox("Rolling ball background subtraction?", true);
			Dialog.addNumber("Rolling ball radius:", 100);
			Dialog.addCheckbox("Normalise intensity histogram?", false);
			Dialog.addCheckbox("Despeckle?", false);
		}
	Dialog.show();
	DAPI_rank = DAPI_bool;
	GFP_rank = GFP_bool + DAPI_bool;
	TXRED_rank = GFP_bool + DAPI_bool + TXRED_bool;
	if(DAPI_bool){
		DAPI_BSbool = Dialog.getCheckbox();
		DAPI_rad = Dialog.getNumber();
		DAPI_norm = Dialog.getCheckbox();;
		DAPI_despeckle = Dialog.getCheckbox();;;
	}
	if(GFP_bool){
		if(GFP_rank==1){
			GFP_BSbool = Dialog.getCheckbox();
			GFP_rad = Dialog.getNumber();
			GFP_norm = Dialog.getCheckbox();;
			GFP_despeckle = Dialog.getCheckbox();;;
		}
		if(GFP_rank==2){
			GFP_BSbool = Dialog.getCheckbox();;;;
			GFP_rad = Dialog.getNumber();;
			GFP_norm = Dialog.getCheckbox();;;;;
			GFP_despeckle = Dialog.getCheckbox();;;;;;
		}
	}
	if(TXRED_bool){
		if(TXRED_rank==1){
			TXRED_BSbool = Dialog.getCheckbox();
			TXRED_rad = Dialog.getNumber();
			TXRED_norm = Dialog.getCheckbox();;
			TXRED_despeckle = Dialog.getCheckbox();;;
		}
		if(TXRED_rank==2){
			TXRED_BSbool = Dialog.getCheckbox();;;;
			TXRED_rad = Dialog.getNumber();;
			TXRED_norm = Dialog.getCheckbox();;;;;
			TXRED_despeckle = Dialog.getCheckbox();;;;;;
		}
		if(TXRED_rank==3){
			TXRED_BSbool = Dialog.getCheckbox();;;;;;;
			TXRED_rad = Dialog.getNumber();;;
			TXRED_norm = Dialog.getCheckbox();;;;;;;;
			TXRED_despeckle = Dialog.getCheckbox();;;;;;;;;
		}
	}
	}
	//print(DAPI_bool);
	//print(DAPI_BSbool);
	//print(DAPI_rad);
	//print(DAPI_norm);
	//print(DAPI_despeckle);
	//print(GFP_bool);
	//print(GFP_BSbool);
	//print(GFP_rad);
	//print(GFP_norm);
	//print(GFP_despeckle);
	//print(TXRED_bool);
	//print(TXRED_BSbool);
	//print(TXRED_rad);
	//print(TXRED_norm);
	//print(TXRED_despeckle);
	//print(TRANS_bool);
}
//Set macro to batchmode - added 04/11/21
setBatchMode(true);
//Get date and time of processing start
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
print(year+"-"+month+"-"+dayOfMonth);
print(hour+":"+minute+":"+second);

for (n=0;n<folders.length; n++){
	StartTime = getTime();
	starting_folder = folders[n];
	//print(starting_folder);
	starting_folder_only = substring(starting_folder, 0, (lengthOf(starting_folder)-1));
	starting_folder_name = File.getName(starting_folder);
	print(starting_folder_name);
	
	filetype = ".tif";
	//Create new composites folder in which to save all comps
	output = starting_folder+year+""+month+""+dayOfMonth+" "+hour+"-"+minute+"-"+second+" Custom comps Mac#0.2/";
	//print(output);
	File.makeDirectory(output);
	
	//Create array of all images in folder
	img_list = getFileList(starting_folder_only);
	//Array.print(img_list);
	
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
	dots = ".";
	print(dots);
	for(k=0; k<unique_prefix_list.length; k++){
		//print(unique_prefix_list[k]);
		for(p=0; p<tif_list.length; p++){
			if(TXRED_bool){	
				if(indexOf(tif_list[p], unique_prefix_list[k]+"_TX Red")>=0){
					//print(img_fold_path + img_tifs[p])
					open(starting_folder + tif_list[p]);
					selectWindow(tif_list[p]);
					if(process_bool){
						if(TXRED_BSbool){
							run("Subtract Background...", "rolling="+TXRED_rad);
							//print("RedBS");
						}	
						if(TXRED_norm){
							run("Enhance Contrast...", "saturated=0.3 normalize");
							//print("RedNorm");
						}
						if(TXRED_despeckle){
							run("Despeckle");
							//print("RedDespeckle");
						}
					}
				}
			}	
			if(GFP_bool){
				if(indexOf(tif_list[p], unique_prefix_list[k]+"_GFP")>=0){
					//print(img_fold_path + img_tifs[p])
					open(starting_folder + tif_list[p]);
					selectWindow(tif_list[p]);
					if(process_bool){
						if(GFP_BSbool){
							run("Subtract Background...", "rolling="+GFP_rad);
							//print("GreenBS");
						}	
						if(GFP_norm){
							run("Enhance Contrast...", "saturated=0.3 normalize");
							//print("GreenNorm");
						}
						if(GFP_despeckle){
							run("Despeckle");
							//print("GreenDespeckle");
						}
					}	
				}
			}
			if(DAPI_bool){
				if(indexOf(tif_list[p], unique_prefix_list[k]+"_DAPI")>=0){
					//print(img_fold_path + img_tifs[p])
					open(starting_folder + tif_list[p]);
					selectWindow(tif_list[p]);
					if(process_bool){
						if(DAPI_BSbool){
							run("Subtract Background...", "rolling="+DAPI_rad);
							//print("BlueBS");
						}
						if(DAPI_norm){
							run("Enhance Contrast...", "saturated=0.3 normalize");
							//print("BlueNorm");
						}
						if(DAPI_despeckle){
							run("Despeckle");
							//print("BlueDespeckle");
						}
					}
				}
			}
			if(TRANS_bool){
				if(indexOf(tif_list[p], unique_prefix_list[k]+"_TRANS")>=0){
					open(starting_folder + tif_list[p]);
					//print("TRANSopen");
				}
			}
		}
		wait(20);
		//set up merge channel instruction based on starting information
		c1_redinstr = "";
		c2_greeninstr = "";
		c3_blueinstr = "";
		c4_greyinstr = "";
		merge_instr = " ";
		if(TXRED_bool){
			c1_redinstr = "c1=["+unique_prefix_list[k]+"_TX Red.tif] ";
		}
		if(GFP_bool){
			c2_greeninstr = "c2=["+unique_prefix_list[k]+"_GFP.tif] ";
		}
		if(DAPI_bool){
			c3_blueinstr = "c3=["+unique_prefix_list[k]+"_DAPI.tif] ";
		}
		if(TRANS_bool){
			c4_greyinstr = "c4=["+unique_prefix_list[k]+"_TRANS.tif] ";
		}
		merge_instr = c1_redinstr+c2_greeninstr+c3_blueinstr+c4_greyinstr+"create";
	//	merge_instr = " c1=[" + unique_prefix_list[k] + "_TX Red.tif] c2=[" + unique_prefix_list[k] + "_GFP.tif] c3=[" + unique_prefix_list[k] + "_DAPI.tif] create";
		//print(merge_instr);
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
		saveAs("tiff", output + unique_prefix_list[k] + "_custom");
		//close();
		run("Close All");
		//Try and clear up some memory - added 11/12/21
		run("Collect Garbage");
		dots=dots+" .";
		if(lengthOf(dots)>20){
			dots = ".";
		}
		print("\\Update:"+dots);
	}
	text_meta_path = output + "Composite processing metadata.txt";
	f = File.open(text_meta_path);
	//if processing then one thing, then within that either separate or same variables
	if(process_bool){
		if(same_set){
			print(f, "Processed using Mac#0.2 \r"+dayOfMonth+"/"+month+"/"+year+" \r"+hour+":"+minute+":"+second+" \r"+"Channels composited: "+chosen_ch+ "\r"+"TRANS included?: "+TRANS_bool+" \r"+"Extra image processing: \r"+"Same settings for all channels?: Yes \r"+
			"Rolling ball background subtraction?: "+DAPI_BSbool+" \r"+"Rolling ball radius: "+DAPI_rad+" \r"+"Intensity histogram normalisation?: "+DAPI_norm+" \r"+
			"Despeckle?: "+DAPI_despeckle);
		}
		else{
			print(f, "Processed using Mac#0.2 \r"+dayOfMonth+"/"+month+"/"+year+" \r"+hour+":"+minute+":"+second+" \r"+"Channels composited: "+chosen_ch+ "\r"+"TRANS included?: "+TRANS_bool+" \r"+"Extra image processing: \r"+"Same settings for all channels?: No \r \r"+
			"DAPI \r"+"Rolling ball background subtraction?: "+DAPI_BSbool+" \r"+"Rolling ball radius: "+DAPI_rad+" \r"+"Intensity histogram normalisation?: "+DAPI_norm+" \r"+
			"Despeckle?: "+DAPI_despeckle+" \r \r"+"GFP \r"+"Rolling ball background subtraction?: "+GFP_BSbool+" \r"+"Rolling ball radius: "+GFP_rad+" \r"+"Intensity histogram normalisation?: "+
			GFP_norm+" \r"+"Despeckle?: "+GFP_despeckle+" \r \r"+"TXRED \r"+"Rolling ball background subtraction?: "+TXRED_BSbool+" \r"+"Rolling ball radius: "+TXRED_rad+" \r"+
			"Intensity histogram normalisation?: "+TXRED_norm+" \r"+"Despeckle?: "+TXRED_despeckle);
		}
	}
	else{
		print(f, "Processed using Mac#0.2 \r"+dayOfMonth+"/"+month+"/"+year+" \r"+hour+":"+minute+":"+second+" \r"+"Channels composited: "+chosen_ch+ "\r"+"TRANS included?: "+TRANS_bool+" \r"+"No extra image processing");
	}
	//print completion message to Log - added 05/11/21
	EndTime = getTime();
	Elapsedsec = (EndTime-StartTime)/1000;
	ElapsedMin = Math.floor(Elapsedsec/60);
	RemainderSec = Elapsedsec-(60*ElapsedMin);
	numimgs = unique_prefix_list.length;
	if(ElapsedMin==0){
		endmsg = "Processing of "+starting_folder_name+" Completed! "+numimgs+" images processed in "+RemainderSec+" seconds.";
	}
	else{
		endmsg = "Processing of "+starting_folder_name+" Completed! "+numimgs+" images processed in "+ElapsedMin+" minutes and "+RemainderSec+" seconds.";
	}
	File.close(f);
	print(endmsg);
	beep();
}
totalmsg = "Processing of "+numfolders+" queued experiment folders complete";
print(totalmsg);
