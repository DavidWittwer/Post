function [ success ] = PlotCDF( freq, Totgain, Effcheck, maxdBitest, S11dBmag, plotProperty )
%PLOTCDF Summary of this function goes here
%   Detailed explanation goes here

success = false;

numbeam1 = size(freq,1);

%logic for adding CDF functionality
edges = [-20:.5:10];
q=length(edges);
[tot_r,tot_c,totD] = size(Totgain);
compshell = ones(tot_r,tot_c,numbeam1);
for k=1:q
    compND=edges(k)*compshell;
    cumtot(k,1,:)=sum(sum(Totgain>compND));
end
cumperc = round(100*(cumtot./(tot_r*tot_c*ones(q,1,numbeam1))));
   
%plotting CDF
figure(10);
orient landscape;
for i=1:numbeam1
    plot(edges,cumperc(:,1,i),char(plotProperty.lnstyl(i)),'LineWidth',2.5);
hold on;
end

for i=1:numbeam1
     tmptxt=[ num2str(ceil(freq(i)/(1*10^6))), ...
             ' MHz : Gain_{peak', num2str(i), '} = ', num2str(round(100*maxdBitest(i))/100), ...
             ' dBi,  Eff_{term', num2str(i),'} = ', num2str(round(100*Effcheck(i))/100), '%', ...
             ' at S_{11} = ', num2str(round(100*S11dBmag(i))/100)];
     celltxt(i,:)=cellstr(tmptxt);
 end
[hleg1 hleg2 hleg3 hleg4]=legend(celltxt,4);

CDFtxt = strvcat( (plotProperty.autsernum), ('3D Pattern Statistics:  CDF of Terminal Gain (Power Sum)')  ) ;
title (CDFtxt);
xlabel(' Gain Level (dBi)');
ylabel ('% of Pattern Exceeding Gain Level');
grid on;

success = true;
