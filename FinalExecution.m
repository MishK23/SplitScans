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
   Block_Size = 500;
   Number_Of_Blocks_Vertically = floor(Image_Height/Block_Size);
   Number_Of_Blocks_Horizontally = floor(Image_Width/Block_Size);
   Image_Blocks = struct('Blocks',[]);
   group = extractBetween(name,11,12);
   iteration = extractBetween(name,14,15);
   timepoint = extractBetween(name,17,30);
   
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

   % Main split processing and array writing
   for Row = 1: +Block_Size: Number_Of_Blocks_Vertically*Block_Size
     for Column = 1: +Block_Size: Number_Of_Blocks_Horizontally*Block_Size
     
     % Image descriptors
     Row_End = Row + Block_Size - 1;
     Column_End = Column + Block_Size - 1;
        
     if Row_End > Image_Height
       Row_End = Image_Height;
     end
    
     if Column_End > Image_Width
       Column_End = Image_Width;
     end
     
     %Pick random subimages from scan
     arr = randperm(Number_Of_Blocks_Vertically,2);
     for z = 1:Number_Of_Blocks_Vertically

       Temporary_Tile = Image(Row:Row_End,Column:Column_End,:);
       Image_Blocks(Index).Blocks = Temporary_Tile;
       if ismember(Index,arr)
       figName = append(string(num),'.jpg');
       subplot(Number_Of_Blocks_Vertically,Number_Of_Blocks_Horizontally,Index); imshow(Temporary_Tile);
       f = gcf;
       exportgraphics(f,figName,'BackgroundColor','none');    
       numstr = string(num);
       finalArr((num+1),:) = [numstr,name,group,treatment,iteration,timepoint];
       num = num + 1;
       end
       clf;
       Index = Index + 1;
       %Create subimages, plot them, then export plots into jpg and create
       %array of parameters describing the random subimages
     end
    end  
   end
   writematrix(finalArr,'TestMetaData.txt'); %Write array into text file
end
