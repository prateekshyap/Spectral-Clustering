function [vector] = getEigenVector(W, n, iter)
	D = zeros(n,n);

	% calculating the diagonal matrix
	for i = 1 : n
	    D(i,i) = sum(W(i,1:n));
	end

	L = D-W; % Graph Laplacian
	[V,G] = eig(L); % find out eigen vectors and eigen values
    %figure;
    %plotting the eigen values
    %nexttile
    %len = size(V,1);
    %x = zeros(1,len);
    %y = zeros(1,len);
    %for i = 1 : len
    %    x(i) = i;
    %    y(i) = G(i,i);
    %end
    %plot(x,y);
    %set (gca, 'XTick',1:1:5);
    %xlabel('index');
    %ylabel('eigen values');
    
	vector = V(1:n,2)'; % the required eigen vector in row format
end