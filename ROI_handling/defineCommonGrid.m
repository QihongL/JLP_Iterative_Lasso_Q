function [dxyz,mxyz] = defineCommonGrid(XYZ, dxyz,stepsize)
  if nargin < 3
		stepsize = 0.25;
	end
  if nargin < 2
		dxyz = ones(1,size(XYZ{1},2));
	end

	mxyz = min(cell2mat(XYZ));
	XYZ_adj = XYZ;
	XYZm = cellfun(@(x) bsxfun(@minus,x,min(x)), XYZ, 'unif', 0);;
	N = cellfun(@(x) size(x,1), XYZ);
	ndim = length(dxyz);

	d = -1;
	breakloop = false;
	while true
		for i = 1:length(XYZ)
			xyz = XYZm{i};
			xyz = roundto(xyz, dxyz);
			xyz_u = unique(xyz,'rows');

			if size(xyz_u, 1) < N(i)
				breakloop = true;
				dxyz(dd) = dxyz(dd) - stepsize;
				break
			else
				dd = mod(d,ndim)+1;
				d = d + 1;
				dxyz(dd) = dxyz(dd) + stepsize;
			end
		end

		if breakloop
			break
		end

	end
end
