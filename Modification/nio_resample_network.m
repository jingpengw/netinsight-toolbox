%% resample points with 1 micron distance
% by jpwu, 2013/12/13
% 
% net = nio_resample_network(net, distance)
% -----------------------------------------------------------------------
% 
% resample the point distance in each section
% 
% Input
% -----
% - network:: the vectorized network
% - distance:: the point distance after resample
% 
% Output
% ------
% - network:: the vectorized network after resample
% 
% Attention
% ---------
% 1. the distance should reasonablly be positive
% 
% Example
% -------
% net = nio_resample_network(net, 1)
% 
% See also nio_intersection_stk nio_density_map
% Uses idpar_tree

function net = nio_resample_network(net, distance)

for si = 1 : length( net.sections )
    si
    
    sec = net.sections{si};
    
    if size(sec,1) == 1
        net.sections{si} = sec;
        continue;
    end
    % compute the total section length
    dsec = diff(sec);
    d = sum( sqrt( sum(dsec.*dsec,2) ));
    
    % change the replicated point
    idx = [];
    for k = 1 : size(sec, 1)-1
        if isequal(sec(k,:),sec(k+1,:))
            %sec(k,1) = sec(k,1) - 0.1;
            idx = [idx; k+1];
        end
    end
    sec(idx,:) = [];
    
    if size(sec,1) == 1
        net.sections{si} = sec;
        continue;
    end
    
    % interpolate evenly spaced points
    net.sections{si} = interparc(round(d), sec(:,1),sec(:,2),sec(:,3),sec(:,4) , 'spline');
end
