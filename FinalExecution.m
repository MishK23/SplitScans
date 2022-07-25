% Setting up initial variables: num is WellIndex and finalArr contains
% parameters which will be printed to the screen
num = 1;
finalArr = strings(length(myFiles),6);
finalArr(1,:) = ["WellIndex","FileName","Type","Treatment","Iteration","TimePoint"];
for j = 1:length(myFiles)
   
   % Reading image and getting filename, which is used to make parameters   
   clf;
   name = myFiles(j).name;
   current_image = extractAfter(name,2);
   Image = imread(current_image);
   Index = 1;
   [Image_Height,Image_Width,Number_Of_Colour_Channels] = size(Image);
   Block_Size = floor(Image_Height/3);
   Number_Of_Blocks_Vertically = floor(Image_Height/Block_Size);
   Number_Of_Blocks_Horizontally = floor(Image_Width/Block_Size);
   group = extractBetween(name,11,12);
   iteration = extractBetween(name,14,15);
   timepoint = extractBetween(name,17,34);
   
   % Setting treatment based on group
   if strcmp(group,"B2")
       treatment = "no stress";
   end
   if strcmp(group,"B3")
       treatment = "50 nM PLX";
   end
   if strcmp(group,"B4")
       treatment = "5% EtOH";
   end
   if strcmp(group,"C2")
       treatment = "0.5 mM H2";
   end
   if strcmp(group,"C3")
       treatment = "no glucose";
   end
   if strcmp(group,"C4")
       treatment = "50 nM thapsagargin";
   end

   %Pick random subimages from scan
   arr = randperm(Number_Of_Blocks_Vertically,2);
   ratio = Number_Of_Blocks_Horizontally/Number_Of_Blocks_Vertically;
   for start = Block_Size: Block_Size: Image_Height-Block_Size
   first = randi([start-Block_Size,start]);
   Temporary_Tile = Image(first:first+Block_Size,ratio*first:ratio*(first+Block_Size));
   figName = append(string(num),'.jpg');
   imshow(Temporary_Tile);
   f = gcf;
   set(gcf,'Color','none');
   exportgraphics(f,figName,'BackgroundColor','none');    
   numstr = string(num);
   finalArr((num+1),:) = [numstr,name,group,treatment,iteration,timepoint];
   num = num + 1;
   clf;
   Index = Index + 1;
   end
       %Create subimages, plot them, then export plots into jpg and create
       %array of parameters describing the random subimages
end 
writematrix(finalArr,'MetaData.txt'); %Write array into text file
