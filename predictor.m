clear all;
clc;

pkg load io; # Loading Package
# Loading CSV file 
A = xlsread('/home/teja/Downloads/Documents/Weather/atechdatalogger.csv'); 

Y = importdata('/home/teja/Downloads/Documents/Weather/atechdatalogger.csv','\t');

Samples = size(A(:,1))(1) # To determine number of Samples in the data set
X = [ones(Samples,1) zeros(Samples,1) zeros(Samples,1) zeros(Samples,1) zeros(Samples,1) zeros(Samples,1)];
for i = 2:Samples
  h = strsplit(strsplit(Y{i},{","}){2},{" ","-",":"});
    for j = 1:5
      X((j*Samples)+i) = str2num(h{j});
      end
  end
prompt = {'dd-mm-yyyy','hh(in 24hr format):mm'};
title = 'Enter Date & Time to Predict';
predict = inputdlg(prompt,title); # Taking Input from the user

C = strsplit(predict{1},{"-","/"});
D = strsplit(predict{2},{":","-"});

Date = str2num(C{1});
Month = str2num(C{2});
Year = str2num(C{3});

Hour = str2num(D{1});
Minute = str2num(D{2});
if Date < 0 || Date > 31 || Month > 12 || Year < 0 || Hour < 0 || Hour > 24 || Minute < 0 || Minute > 60 
  printf("Sorry ! Your given date is %d-%d-%d %d:%d is invalid \n",Date,Month,Year,Hour,Minute);
else
  X = X(2:end,:);
  Z = pinv(X'*X)*X';
  b = [1 Date Month Year Hour Minute];
  # To print output(Predicted) values
  printf("Predicted Weather values on %d-%d-%d %d:%d :\n",Date,Month,Year,Hour,Minute);
  Temparature = b*(Z*(A(2:end,3))) # Predicted Temparature
  Humidity = b*(Z*(A(2:end,4))) # Predicted Humidity
  Wind_Speed = b*(Z*(A(2:end,5)))# Predicted Wind_Speed
  Wind_Direction = b*(Z*(A(2:end,6))); # Predicted Wind_Direction
  if Wind_Direction < 0
    Wind_Direction= 0
  else
    Wind_Direction
  end
  Dew_Point = b*(Z*(A(2:end,7))) # Predicted Dew_Point
  Rainfall = b*(Z*(A(2:end,8))) # Predicted Rainfall
  Solar_Radiation = b*(Z*(A(2:end,9))) # Predicted Solar_Radiation
end
