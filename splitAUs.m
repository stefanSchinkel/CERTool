function data = splitAUs(data)

	% 1:7, twice
	idx = [ reshape(repmat(1:7,2,1),1,14) 8:13 14 14 15 16 16 17:21];
			 
	data = data(idx,:);
	
