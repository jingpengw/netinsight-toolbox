﻿%% quantitative analysis of barrel cortex field(include PMBSF barrel and septa)
%% undefined parameters
B_vessel_path = ''; % the path of barrel cortex vessels data(.swc)
B_soma_path = ''; % the path of barrel cortex somas data(.swc)
Block_Size = 0; % the size of a block assigned from cortex outside surface, unit : ��m
SegImg = ''; % the path of a cortex template
stpSize = 5; % the statistic step length, unit : ��m {DEFAULT: 5 ��m}
Ms = 0; % barrel cortex field size(x-coordinate) , unit : ��m
Ns = 0; % barrel cortex field size(y-coordinate), unit : ��m
T_B = []; % threshold for microvasculature , unit : ��m
bm_path = ''; % the path of image for barrels
bm_ev_path = ''; % the path of image for PMBSF(barrels and septa)
%% load vessels and somas
% [vessels vessel1] = nio_load_tree(B_vessel_path);
soma = load_tree(B_soma_path);
% num_tree_vessels = length(vessels); % number of root nodes
%% transform the coordinates for adapting to Matlab
% vessels = nio_coordinate_transform( vessels, [1 1 1] );
% vessel = cell(1,1);
% vessel{1} = vessel1;
% vessel = nio_coordinate_transform( vessel, [1 1 1] );
% vessel1 = vessel{1};
somas = cell(1,1);
somas{1} = soma;
somas = nio_coordinate_transform( somas, [0.35 0.35 0.35] );
soma = somas{1};
%% generate binary images for every block and determine cortex area
% barrel_mask = imread(bm_path);
% barrel_mask_ev = imread(bm_ev_path);
% barrel_mask = im2bw(barrel_mask, 0.7) ; % binaryzation
% barrel_mask_ev = im2bw(barrel_mask_ev, 0.7) ; % binaryzation
[BM_a] = nio_generate_block( Ms, Ns, Block_Size, '');
num_part = length(BM_a);
[z_st z_en] = nio_cortex_area( BM_a, SegImg, 1);
z_st = z_st+25;
z_en = z_en-25;
%% microvasculature
% vessels_c = cell(1, num_tree_vessels);
% for ward = 1 : num_tree_vessels
%     vessels_c{ward} = nio_extract_microvessels (vessels{ward}, T_B); % threshold
% end
%% fractional vascular volume(fv), vascular length density(ld) and diameter distribution(dia)
% for every block, _a;for barrel field in a block, _b;septa field in a
% block, _s
fv_a = cell(1, num_part); ld_a = cell(1, num_part); 
% fv_b = cell(1, num_part); ld_b = cell(1, num_part);
% fv_a_c = cell(1, num_part); ld_a_c = cell(1, num_part);
% fv_b_c = cell(1, num_part); ld_b_c = cell(1, num_part);
% fv_s = cell(1, num_part); ld_s = cell(1, num_part);
% fv_s_c = cell(1, num_part); ld_s_c = cell(1, num_part);
dia_a = cell(1, num_part);
% dia_b = cell(1, num_part);
% dia_s = cell(1, num_part);
for ward = 1 : num_part
    ward
    [fv_a{ward} ld_a{ward} dia_a{ward}] = nio_vessel_single_block(vessels, BM_a{ward}, z_st(ward), z_en(ward));
%     [fv_a_c{ward} ld_a_c{ward}, ~] = nio_vessel_single_block(vessels_c, BM_a{ward}, z_st(ward), z_en(ward));
%     [fv_b{ward} ld_b{ward} dia_b{ward}] = nio_vessel_single_block(vessels, BM_b{ward}, z_st(ward), z_en(ward));
%     [fv_b_c{ward} ld_b_c{ward}, ~] = nio_vessel_single_block(vessels_c, BM_b{ward}, z_st(ward), z_en(ward));
%     [fv_s{ward} ld_s{ward} dia_s{ward}] = nio_vessel_single_block(vessels, BM_s{ward}, z_st(ward), z_en(ward));
%     [fv_s_c{ward} ld_s_c{ward}, ~] = nio_vessel_single_block(vessels_c, BM_s{ward}, z_st(ward), z_en(ward));
end
%% soma density(ds)
ds_a = cell(1, num_part);
% ds_b = cell(1, num_part);
% ds_s = cell(1, num_part);
for ward = 1 : num_part
    ward
    ds_a{ward} = nio_soma(soma, BM_a{ward}, z_st(ward), z_en(ward), '');
%     ds_b{ward} = nio_soma(soma, BM_b{ward}, z_st(ward), z_en(ward));
%     ds_s{ward} = nio_soma(soma, BM_s{ward}, z_st(ward), z_en(ward));
end
%% distance between soma to microvessel(dtm)
% m_dtm: average distance at different depth percentage of cortex
% e_dtm: std of blocks
% dtm: original data
% Ks = max(ceil(vessel1.Z), ceil(soma.Z));
% [ m_dtm_a e_dtm_a dtm_a d_cortex, ~] = nio_soma2tree( vessels, vessels_c, soma, Ms, Ns, Ks, Block_Size, z_st, z_en);