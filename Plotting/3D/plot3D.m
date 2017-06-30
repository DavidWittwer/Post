function [fHandle] = plot3D( dataTitle, freq, data )
    theta_d=[0:1:180]';
    phi_d=[0:1:360]';
    theta_r=pi/180 .* theta_d;
    phi_r=pi/180 .* phi_d;

    freq_MHz = freq./10^6;
    xtrans = (cos(phi_r) * sin(theta_r)')';
    ytrans = (sin(phi_r) * sin(theta_r)')';
    ztrans = (ones(length(phi_r),1) * cos(theta_r)')';

    % plot 3D pattern
    Tampmin=(min(min(data(:,:))));
    Tampscl=(max(max(data(:,:))));
    Tampplot=data(:,:) - min(min(data(:,:)));
    Tampcolor=10.^( (data(:,:) )./10);
    Z = ztrans .* Tampplot;
    X = xtrans .* Tampplot;
    Y = ytrans .* Tampplot;

    axmax=1.25*max(max(Tampplot));
    axext=[0, axmax];
    noext=[0,0];

    fHandle = figure;
    colormap(jet);
    surf(X,Y,Z,(Tampcolor));
    hold on;

    plot3(axext, noext, noext, 'LineWidth', 2,'Color','k'); % X-axis
    plot3(noext, axext, noext, 'LineWidth', 2,'Color','k'); % Y-axis
    plot3(noext, noext, axext, 'LineWidth', 2,'Color','k'); % Z-axis
    text(1.1*axmax, 0, 0, '+X', 'FontSize',20,'FontWeight', 'bold') %X-axis label
    text( 0, 1.1*axmax, 0, '+Y', 'FontSize',20,'FontWeight', 'bold') %Y-axis label
    text( 0, 0, 1.1*axmax, '+Z', 'FontSize',20,'FontWeight', 'bold') %Z-axis label

    shading interp;
    title (dataTitle);
    axis vis3d;
    numticks=8;
    Ytlinmax=10.^(Tampscl/10);
    Ytlinmin=10.^(Tampmin/10);
    dYtlin=(Ytlinmax-Ytlinmin)/numticks;
    Ytlinspc=[Ytlinmin:dYtlin:Ytlinmax];
    Ytlogspc=round(100*(10*log10(Ytlinspc)))/100;
    Yloglbl=num2cell(Ytlogspc);
    colorbar('Ylim',[Ytlinmin, Ytlinmax], 'YTick', Ytlinspc,'YTickLabel',Yloglbl);

    
return;