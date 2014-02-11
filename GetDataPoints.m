function [PointsMatrix] = GetDataPoints(filename)
origin=readkeyword('ORIGIN',filename,':');
XX=ReadFromBlock(filename,'<BeginXX>','<EndXX>');
XX=origin(1)+XX(1:end-1)+(XX(2:end)-XX(1:end-1))/2;

YY=ReadFromBlock(filename,'<BeginYY>','<EndYY>');
YY=origin(2)+YY(1:end-1)+(YY(2:end)-YY(1:end-1))/2;

cols=length(YY);
rows=length(XX);

grd= ReadFromBlock(filename,'<BeginGridData2D>','<EndGridData2D>');
grd=flipud(rot90(reshape(grd,rows,cols)));

[lon,lat]=ndgrid(XX,YY);
lon=lon';
lat=lat';
surface(lon,lat,grd);shading flat;
c=caxis;caxis([0 c(2)]);
F=griddedInterpolant(lon',lat',grd');
[x,y]=ginputn;
box2d=round(F(x,y));
%clean from  land points
idx=find(box2d >=0);
x=x(idx);
y=y(idx);
box2d=box2d(idx);
PointsMatrix=[x y box2d];