%{
%% General Information
% status is a boolean array which stores 0 for no partitioning and 1 for partitioning
% rEV = Required Eigen Vector i.e. the second smallest one, stores the eigen vectors
eveytime we partition the graph, which helps in plotting different clusters
% XY contains the coordinates which helps in plotting with axis
% maxIterations can be changed to the required value to continue further clustering
% threshold indicates the number of nodes after which clustering will be
performed
%}

clc;
clear all;
close all;

global W; % dataset is global
global rEV; % eigen vectors are global
global XY; % coordinates are global

%%
maxIterations = 3; % clustering will be done 3 times
threshold = 6; % if number of nodes is less than or equal to 6, no further clustering will be done

%% dataset

% remove the comment and add dataset

%{
W=[%1  2  3  4  5
    0 90 90  0  0;%1
   90  0  0  0  1;%2
   90  0  0  0  0;%3
    0  0  0  0  0;%4
    0  1  0  0  0;%5
];
%}

%% optional (change accordingly)
% X and Y coordinates to plot a proper graph
%{
XY= [3,2; %1
    4,2; %2
    3,1; %3
    1,-1; %4
    5,2; %5
];
%}

n = size(W,1); % stores the total number of nodes
clusters = {}; % stores the ranges of positive and negative eigen vectors

%% initial plot
%{
figure;
h=plot(graph(W));
for i = 1 : n
    highlight(h,[i],'NodeColor','b');
end
%}

figure;
%subplot(1,1,1);
t=tiledlayout('flow');

nexttile
gplot(W,XY,'.-b');
set (gca, 'XTick',-1:1:9);
set (gca, 'YTick',-4:1:3);
axis ([0 9 -4 3]);
title('Initial dataset');

%% clustering and plotting each cluster
for x = 1 : maxIterations % xth partition 
    arr = [1,n]; % temporary array to store the ranges of positive and negative eigen vectors
    status = 0; % stores whether the corresponding range will be further partitioned or not
    c = Property(); % to store the ranges and status
    if (x == 1) % for the first time the entire graph is one cluster
        c.status = [1]; % hence it will be partitioned
        c.ranges = arr; % entire range is positive
        clusters{x} = c; % store object to array
        rEV = getEigenVector(W,n,x); % getting the required eigen vector
    else % for all the further iterations
        arr = getRanges(rEV(x-1,1:n),clusters{x-1}.ranges); % get the ranges of previous clusters
        rEV(x,1:n) = zeros(1,n); % add a new row to store new eigen vectors
        c.status = zeros(size(arr,1),1); % initialize status to 0
        c.ranges = arr; % store the ranges
        clusters{x} = c; % store object to array
        for row = 1 : size(clusters{x}.ranges,1) % for each range
            len = clusters{x}.ranges(row,2)-clusters{x}.ranges(row,1)+1; % store its length
            if (len > threshold) % if there are more than 6 nodes, partition will be done
                l = clusters{x}.ranges(row,1); % store the beginning of the range
                r = clusters{x}.ranges(row,2); % store the end of the range
                v = getEigenVector(W(l:r,l:r),len,x); % getting the required eigen vector
                s = size(v,2);
                rEV(x,l:r) = v(1,1:s); % store the vector to the global variable
                clusters{x}.status(row) = 1; % set status to 1
            end
        end
    end
    rearrangeClusters(n,x,clusters{x}.ranges,clusters{x}.status); % rearrange the rows and columns of the dataset
    plotCurrentState(clusters,x,n); % graph plot
end

