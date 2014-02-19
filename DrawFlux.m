function FluxesToDraw=DrawFlux(Box,BoxNum,TableOfFluxes,stemwidth)
% Draw fluxes related to the box BoxNum from file filename
% Box                    : Box structure
% BoxNum                 : Box number
% TableOfFluxes          : Table with first 3 columns containing :
%                          start box number, end box number, and flow value
    
%      MaxFlux = max(abs(TableOfFluxes(:,3)));
%      MinFlux = min(abs(TableOfFluxes(:,3)));
%      DF=MaxFlux-MinFlux;
%      MaxArrowWidth = 0.1;
%      MinArrowWidth = 0.01;
%      DS=MaxArrowWidth-MinArrowWidth;


if length(BoxNum)==1
     indices=find((TableOfFluxes(:,1)==BoxNum | TableOfFluxes(:,2)==BoxNum));
     FluxesToDraw=TableOfFluxes(indices,:);
else
    nboxes=length(BoxNum);
    indices=find((TableOfFluxes(:,1)==BoxNum(1)));
    FluxesToDraw=TableOfFluxes(indices,:);
    for i=2:nboxes
        indices=find((TableOfFluxes(:,1)==BoxNum(i)));
        M=TableOfFluxes(indices,:);
        FluxesToDraw=[FluxesToDraw;M];
    end
    indices=find((FluxesToDraw(:,2)==BoxNum(1)));
    M2=FluxesToDraw(indices,:);
    for i=2:nboxes
        indices=find((FluxesToDraw(:,2)==BoxNum(i)));
        M=FluxesToDraw(indices,:);
        M2=[M2;M];
    end
    FluxesToDraw=M2;
end




     [n,c]=size(FluxesToDraw);
     for i=1:n
     start=FluxesToDraw(i,1);
     fin=FluxesToDraw(i,2);
 
     points_group_start=[Box(start+1).pointsX Box(start+1).pointsY Box(start+1).pointsZ];  
     points_group_fin  =[Box(fin+1).pointsX Box(fin+1).pointsY Box(fin+1).pointsZ]; 
     
     [p1pos,p2pos]=mindistance(points_group_start,points_group_fin);
     p1=points_group_start(p1pos,:);
     p2=points_group_fin(p2pos,:);
     
     % Box 0 has one vertical layer only, so the height of the piont inside Box 0
     % is assumed to be the same as the height of the ending box
     if start ==0
         [p1pos,p2pos]=mindistance(points_group_start(:,1:2),points_group_fin(:,1:2));
         p2=points_group_fin(p2pos,:);
         p1=points_group_start(p1pos,:);
         p1(3)=p2(3);
     end
     % Box 0 has one vertical layer only, so the height of the point inside Box 0
     % is assumed to be the same as the height of the starting box
     if fin ==0
         [p1pos,p2pos]=mindistance(points_group_start(:,1:2),points_group_fin(:,1:2));
         p1=points_group_start(p1pos,:);
         p2=points_group_fin(p2pos,:);
         p2(3)=p1(3);
     end
     
     midpoint=(p1+p2)/2;
    
       
     % scale the arrow to the range of flux values
    % percent=(abs(FluxesToDraw(i,3))-MinFlux)/DF
    % ArrowWidth=MinArrowWidth+percent*DS
      
     % direction of the arrow is inverted if flow is negative
     if FluxesToDraw(i,3)>0 
         
     h(i)=mArrow3(p1,p2,'color','black','stemWidth',stemwidth,'tipWidth',stemwidth*3);
     %h=arrow3(p1,p2);
     else
         
     h(i)=mArrow3(p2,p1,'color','black','stemWidth',stemwidth,'tipWidth',stemwidth*3);
     %h=arrow3(p2,p1);
     end
     text_to_write=cat(2,'  ',num2str(abs(round(FluxesToDraw(i,3)))));
     text(midpoint(1),midpoint(2)+3*stemwidth,midpoint(3),text_to_write,'FontWeight','bold');
     end

 