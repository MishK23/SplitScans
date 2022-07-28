% Setting up initial variables: num is WellIndex and finalArr contains
% parameters which will be printed to the screen
num = 1;
x = zeros(2*length(myFiles));
y = zeros(2*length(myFiles));
finalArr = strings(length(myFiles),6);
finalArr(1,:) = ["WellIndex","FileName","Type","Treatment","Iteration","TimePoint"];
for j = 1:1:length((myFiles))
   
   % Reading image and getting parameters from filename  
   clf;
   name = myFiles(j).name;
   group = extractBetween(name,11,12);
   iteration = extractBetween(name,14,15);
   timepoint = extractAfter(name,16);
   current_image = extractAfter(name,2);
   if length(name) == 37
      group = extractBetween(name,11,12);
      iteration = name(14);
      timepoint = extractAfter(name,15);
   end
   Image = imread(current_image);
   Index = 1;
   [Image_Width,Image_Height,Number_Of_Colour_Channels] = size(Image);
   Block_Size = 300;

   
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
   for i = 1:2
   firstx = randi(Image_Width-Block_Size);
   secondx = firstx+Block_Size;
   firsty = randi(Image_Height-Block_Size);
   secondy = firsty+Block_Size;
   centerx = (firstx+secondx)/2;
   centery = (firsty+secondy)/2;
   x(num) = centerx;
   y(num) = centery;
   %Create subimage
   Temporary_Tile = Image(firstx:secondx,firsty:secondy);
   figName = append(string(num),'.jpg');
   imshow(Temporary_Tile);
   %Save subplot with transparent background as a jpg file
   f = gcf;
   set(f,'Color','none');
   exportgraphics(f,figName,'BackgroundColor','none','Resolution',300);    
   numstr = string(num);
   %Add image parameters array element to finalArr
   finalArr((num+1),:) = [numstr,current_image,group,treatment,iteration,timepoint];
   num = num + 1;
   clf;
   Index = Index + 1;
   end
       %Create subimages, plot them, then export plots into jpg and create
       %array of parameters describing the random subimages
end 
clf;
%Plot to make sure of random image centers
plot(x, y,'linestyle','none','marker','o')
set(gcf,'Color','w');
lower = Block_Size/2;
xlim([0,Image_Width]);
ylim([0,Image_Height]);
writematrix(finalArr,'MetaData.txt'); %Write array into text file
