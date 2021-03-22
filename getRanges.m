function [ranges] = getRanges (vector, split)
%{
	% vector contains the current eigen vector
	% split contains the ranges of the previous eigen vector, which helps to distinguish between
	current consecutive ranges which were separate in the previous vector
	% signs matrix is created to make the condition easier
%}
	n = size(vector,2); % getting the length

	% create the signs matrix
	signs = zeros(1,n); 
	for j = 1 : n
		if (vector(j) < 0)
			signs(j) = -1;
		elseif (vector(j) > 0)
			signs(j) = 1;
		end
	end

	ranges = zeros(1,2); % contains the actual ranges (one range in each row)
	temp = zeros(1,2); % contains the ranges in a single row
	index = 1; % counter for temp
	for i = 1 : size(split,1) % for each range of previous eigen vector
		for j = split(i,1) : split(i,2) % for each value
			if (j == split(i,1)) % if the value is at the starting border of previous eigen vector
				temp(index) = j; % store its position
				index = index+1;
			elseif (j == split(i,2)) % if the value is at the ending border of previous eigen vector
				temp(index) = j; % store its position
				index = index+1;
			elseif (signs(j) ~= signs(j-1)) % if the sign changes
				temp(index) = j-1; % store the previous position
				index = index+1;
				temp(index) = j; % store the current position
				index = index+1;
			end
		end
	end

	% converting the row vector into Nx2 matrix
	i = 1; % counter for temp
	index = 1; % counter for ranges
	while (i <= size(temp,2))
		ranges(index,1:2) = temp(1,i:i+1);
		i = i+2;
		index = index+1;
	end
end