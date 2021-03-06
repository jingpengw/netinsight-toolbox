%% build the t link 
function [unary, rays] = build_t_link_graph( local_stk, seed, map_id, T )
% the maximum intensity of the local stack
MAXINT = double( max( local_stk(:) ) );
% MEANINT = double( mean( local_stk(:) ) );

% the lower and upper threshold
T1 = double(T);
T2 = double( MAXINT );

% establish the weight lookup table of forground t link,
% cf = (255+T)/2; cb = T/2;
alpha = (T2+2*double( T1 ))/4;
beta = -T2/4/log(9);   % constant!
lut = single( 1./(1+exp( ((0:255)-alpha)./beta ) ) );
lut_wf = 1-lut;   %1- lut;
lut_wb = lut;

% initialize the unary matrix, CXN
unary = zeros( 2,  size( map_id, 1 ), 'single' );
unary(1,:) = lut_wf( map_id(:,4)+1 )';
unary(2,:) = lut_wb( map_id(:,4)+1 )';

% the t-link weight 
rays = cell( size(map_id, 1), 1 );
% get the feature vector
for idx = 1 : size( map_id, 1 )
    % get the voxel coordinates using bresenham's algorithm
    [vm, vn, vk] = bresenham_line3d( double(seed(1 : 3)), double(map_id(idx, 1:3)));
    if length(vm) <= 2
        continue;
    end
    
    % get the voxel intensity
    vi = zeros( size(vm), 'double' );
    for vidx = 1 : length(vm)
        vi( vidx ) = local_stk( vm(vidx), vn(vidx), vk(vidx) );
    end
    rays{idx} = [ vm' vn' vk' vi' ];
%     vi = double( vi( ceil(length(vi)/2) : length(vi) ) );
     
%     % the ideal distribution
%     vt = ones( 1,length(vi), 'double' ) * MEANINT;
%     % the Jaccard index
%     corr = dot(vt, vi) / ( dot(vt,vt) + dot(vi,vi) - dot(vt,vi));     
%     % adjust the weight of t-link
%     unary(1,idx) = (unary(1,idx) + 1-corr)/2;
end
% unary(2,:) = 1 - unary(1,:);