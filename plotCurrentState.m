function [] = plotCurrentState(clusters,x,n)
%{
	% clusters contains the information about the ranges and their partitioning status
	% x indicates the current plot state
	% signs matrix is created to make the plot easier
%}
	global rEV;
	global W;
	global XY;
    
    %% get the ranges
    c = Property();
    c.ranges = getRanges(rEV(x,1:n),clusters{x}.ranges); % get current ranges
    
	%% normal plot
	% create signs matrix
	signs = rEV;
    for i = 1 : size(signs,1)
        for j = 1 : size(signs,2)
            if (signs(i,j) < 0)
                signs(i,j) = -1;
            elseif (signs(i,j) > 0)
                signs(i,j) = 1;
            end
        end
    end

    % set colors
    nodeColors = {'b' 'g' 'r' 'y' 'c' 'm'};
    clr = 1;
    
    % plot
    %figure;
    %h=plot(graph(W));
    
    % create a copy
    Wnew = W;

    % omitting the edges
    for p = 1 : x % for all the paritions done till now
        for r = 1 : size(clusters{p}.ranges,1) % for each range
            for i = clusters{p}.ranges(r,1) : clusters{p}.ranges(r,2) % for all the values within the range
                for j = clusters{p}.ranges(r,1) : clusters{p}.ranges(r,2) % for all other values
                    if (W(i,j) ~= 0 && ((rEV(p,i) < 0 && rEV(p,j) > 0) || (rEV(p,i) > 0 && rEV(p,j) < 0))) % if edge is present and end points are of different signs
                        %highlight(h,[i j],'EdgeColor','w'); % omit the edge
                        % for axis plot set those edges to 0
                        Wnew(i,j) = 0;
                        Wnew(j,i) = 0;
                    end
                end
            end
        end
    end

    % setting node colors
    %{
clr = 1;
    for row = 1 : size(c.ranges,1); % for each range
    	l = c.ranges(row,1);
    	r = c.ranges(row,2);
    	for i = l : r
            highlight(h,[i],'NodeColor',nodeColors{clr}); % put one color for one range
        end
        clr = clr+1; % change the color
        if (clr > 6)
            clr = 1;
        end
    end
%}


    %% plot with axis on
    %figure;
    %nexttile
    %subplot(1,1,1);

    % copy the corresponding clusters from Wnew to Wcopy and plot
    colors = {'.-b' '.-g' '.-r' '.-y' '.-c' '.-m'};
    clr = 1;
    nexttile
    for row = 1 : size(c.ranges,1);
    	l = c.ranges(row,1);
    	r = c.ranges(row,2);
    	Wcopy = zeros(1,1);
    	Wcopy(1:(r-l+1),1:(r-l)+1) = Wnew(l:r,l:r); % get one cluster
        gplot(Wcopy,XY(l:r,1:2),colors{clr}); % plot it with one color
        set (gca, 'XTick',-1:1:9);
        set (gca, 'YTick',-4:1:3);
        axis ([0 9 -4 3]);
        title('Clustering- ',x);
        clr = clr + 1; % change the color
        if (clr > 6)
            clr = 1;
        end
    	hold on;
    end
end