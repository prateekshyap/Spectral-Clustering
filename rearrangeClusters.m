function [] = rearrangeClusters(n, rowNum, ranges, status)
%{
	% rowNum indicates to the latest eigen vector according to which we need to do the partitions
	% ranges contains the positive and negative ranges
	% status says whether the corresponsing range is partitioned or not	
	% negative values of eigen vectors are being considered before the positive ones 
	% eigen vectors are also being rearranged because it helps in plotting
%}
	global W;
	global rEV;
	global XY;

	Wnew = W; % store a copy
	rEVnew = rEV; % store a copy
	XYnew = XY; % create a copy

	l = 1; % beginning
	r = n; % end
	iter = size(ranges,1); % number of iterations

	%% arranging the rows
	for currRange = 1 : iter % for each different range
		l = ranges(currRange,1); % set beginning
		r = ranges(currRange,2); % set end
		if (status(currRange) == 1) % if status is 1
			index = l; % counter for storing
			for i = l:r % for each row
			    if (rEV(rowNum,i) < 0) % if eigen vector is negative
			        Wnew(index,1:n) = W(i,1:n); % store the row
			        index = index+1;
			    end
			end
			for i = l:r % for each row
			    if (rEV(rowNum,i) > 0) % if eigen vector is positive
			        Wnew(index,1:n) = W(i,1:n); % store the row
			        index = index+1;
			    end
			end
		else % if status is 0
			index = l; % counter for storing
			for i = l:r % for each row
				Wnew(index,1:n) = W(i,1:n); % copy without any condition
				index = index+1;
			end
		end
	end

	%% arranging the columns, the eigen vectors and the XY coordinates
	for currRange = 1 : iter
		l = ranges(currRange,1);
		r = ranges(currRange,2);
		if (status(currRange) == 1)
			index = l;
			for i = l:r
			    if (rEVnew(rowNum,i) < 0)
			        W(1:n,index) = Wnew(1:n,i);
			        rEV(1:rowNum,index) = rEVnew(1:rowNum,i); % store the eigen vector
			        XY(index,1:2) = XYnew(i,1:2); % store the coordinates
			        index = index+1;
			    end
			end
			for i = l:r
			    if (rEVnew(rowNum,i) > 0)
			        W(1:n,index) = Wnew(1:n,i);
			        rEV(1:rowNum,index) = rEVnew(1:rowNum,i); % store the eigen vector
			        XY(index,1:2) = XYnew(i,1:2); % store the coordinates
			        index = index+1;
			    end
			end
		else
			index = l;
			for i = l:r
				W(1:n,index) = Wnew(1:n,i);
			    rEV(1:rowNum,index) = rEVnew(1:rowNum,i); % copy without any condition
			    XY(index,1:2) = XYnew(i,1:2); % store the coordinates
			    index = index+1;
			end
		end
	end
end