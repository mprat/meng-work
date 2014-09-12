function boxes = detect_pose(im, model, thresh)
% boxes = detect(im, model, thresh)
% Detect objects in input using a model and a score threshold.
% Higher threshold leads to fewer detections.
%
% The function returns a matrix with one row per detected object.  The
% last column of each row gives the score of the detection.  The
% column before last specifies the component used for the detection.
% Each set of the first 4 columns specify the bounding box for a part

% Compute the feature pyramid and prepare filter
pyra     = featpyramid_pose(im,model);
interval = model.interval;
levels   = 1:length(pyra.feat);

% Cache various statistics derived from model
[components,filters,resp] = modelcomponents(model,pyra);
boxes = zeros(10000,length(components{1})*4+2);
cnt   = 0;

% Iterate over scales and components,
for rlevel = levels,
  for c  = 1:length(model.components),
    parts    = components{c};
    numparts = length(parts);

    % Local scores
    for k = 1:numparts,
      f     = parts(k).filterid;
      level = rlevel-parts(k).scale*interval;
      if isempty(resp{level}),
        resp{level} = fconv(pyra.feat{level},filters,1,length(filters));
      end
      for fi = 1:length(f)
        parts(k).score(:,:,fi) = resp{level}{f(fi)};
      end
      parts(k).level = level;
    end
    
    % Walk from leaves to root of tree, passing message to parent
    for k = numparts:-1:2,
      par = parts(k).parent;
      [msg,parts(k).Ix,parts(k).Iy,parts(k).Ik] = passmsg(parts(k),parts(par));
      parts(par).score = parts(par).score + msg;
    end

    % Add bias to root score
    parts(1).score = parts(1).score + parts(1).b;
    [rscore Ik]    = max(parts(1).score,[],3);

    % Walk back down tree following pointers
    [Y,X] = find(rscore >= thresh);
    for i = 1:length(X)
      x = X(i);
      y = Y(i);
      k = Ik(y,x);
      box = backtrack(x,y,k,parts,pyra);
      cnt = cnt + 1;
      boxes(cnt,:) = [box c rscore(y,x)];
    end
  end
end

boxes = boxes(1:cnt,:);

% Cache various statistics from the model data structure for later use  
function [components,filters,resp] = modelcomponents(model,pyra)
  components = cell(length(model.components),1);
  for c = 1:length(model.components),
    for k = 1:length(model.components{c}),
      p = model.components{c}(k);
      [p.w,p.defI,p.starty,p.startx,p.step,p.level,p.Ix,p.Iy] = deal([]);
      [p.scale,p.level,p.Ix,p.Iy] = deal(0);
      
      % store the scale of each part relative to the component root
      par = p.parent;      
      assert(par < k);
      p.b = [model.bias(p.biasid).w];
      p.b = reshape(p.b,[1 size(p.biasid)]);
      p.biasI = [model.bias(p.biasid).i];
      p.biasI = reshape(p.biasI,size(p.biasid));
      
      for f = 1:length(p.filterid)
        x = model.filters(p.filterid(f));
        [p.sizy(f) p.sizx(f) foo] = size(x.w);
        p.filterI(f) = x.i;
      end
      for f = 1:length(p.defid)	  
        x = model.defs(p.defid(f));
        p.w(:,f)  = x.w';
        p.defI(f) = x.i;
        ax  = x.anchor(1);
        ay  = x.anchor(2);    
        ds  = x.anchor(3);
        p.scale = ds + components{c}(par).scale;
        % amount of (virtual) padding to hallucinate
        step     = 2^ds;
        virtpady = (step-1)*pyra.pady;
        virtpadx = (step-1)*pyra.padx;
        % starting points (simulates additional padding at finer scales)
        p.starty(f) = ay-virtpady;
        p.startx(f) = ax-virtpadx;      
        p.step   = step;
      end
      components{c}(k) = p;
    end
  end
  
  resp    = cell(length(pyra.feat),1);
  filters = cell(length(model.filters),1);
  for i = 1:length(filters),
    filters{i} = model.filters(i).w;
  end

% Given a 2D array of filter scores 'child',
% (1) Apply distance transform
% (2) Shift by anchor position of part wrt parent
% (3) Downsample if necessary
function [score,Ix,Iy,Ik] = passmsg(child,parent)
  INF = 1e10;
  K   = length(child.filterid);
  Ny  = size(parent.score,1);
  Nx  = size(parent.score,2);  
  Ix0 = zeros([Ny Nx K]);
  Iy0 = zeros([Ny Nx K]);
  score0 = repmat(-INF,[Ny Nx K]);

  for k = 1:K
    [score_tmp,Ix_tmp,Iy_tmp] = dt(child.score(:,:,k), child.w(1,k), child.w(2,k), child.w(3,k), child.w(4,k));
    
    % starting points
    startx = child.startx(k);
    starty = child.starty(k);
    step   = child.step;
    % ending points
    endy = starty+step*(Ny-1);
    endx = startx+step*(Nx-1);
    endy = min(size(child.score,1),endy);
    endx = min(size(child.score,2),endx);
    % y sample points
    iy = starty:step:endy;
    oy = sum(iy < 1);
    iy = iy(iy >= 1);
    % x sample points
    ix = startx:step:endx;
    ox = sum(ix < 1);
    ix = ix(ix >= 1);
    % sample scores
    sp = score_tmp(iy,ix);
    sx = Ix_tmp(iy,ix);
    sy = Iy_tmp(iy,ix);
    sz = size(sp);
    % define msgs
    iy  = oy+1:oy+sz(1);
    ix  = ox+1:ox+sz(2);
    
    score0(iy,ix,k) = sp;
    Ix0(iy,ix,k)    = sx;
    Iy0(iy,ix,k)    = sy;
  end

  % At each parent location, for each parent mixture 1:L, compute best child mixture
  L  = length(parent.filterid);
  N  = Nx*Ny;
  i0 = reshape(1:N,Ny,Nx);
  [score,Ix,Iy,Ix] = deal(zeros(Ny,Nx,L));
  for l = 1:L
    b = child.b(1,l,:);
    [score(:,:,l),I] = max(bsxfun(@plus,score0,b),[],3);
    i = i0 + N*(I-1);
    Ix(:,:,l)    = Ix0(i);
    Iy(:,:,l)    = Iy0(i);
    Ik(:,:,l)    = I;
  end

function box = backtrack(x,y,mix,parts,pyra)

  numparts = length(parts);
  ptr = zeros(numparts,3);
  box = zeros(numparts,4);
  k   = 1;
  p   = parts(k);
  scale = pyra.scale(p.level);
  x1  = (x - 1 - pyra.padx)*scale+1;
  y1  = (y - 1 - pyra.pady)*scale+1;
  x2  = x1 + p.sizx(mix)*scale - 1;
  y2  = y1 + p.sizy(mix)*scale - 1;
  ptr(k,:) = [x y mix];
  box(k,:) = [x1 y1 x2 y2];


  for k = 2:numparts,
    p   = parts(k);
    par = p.parent;
    x   = ptr(par,1);
    y   = ptr(par,2);
    mix = ptr(par,3);
    ptr(k,1) = p.Ix(y,x,mix);
    ptr(k,2) = p.Iy(y,x,mix);
    ptr(k,3) = p.Ik(y,x,mix);
    scale = pyra.scale(p.level);
    x1  = (ptr(k,1) - 1 - pyra.padx)*scale+1;
    y1  = (ptr(k,2) - 1 - pyra.pady)*scale+1;
    x2  = x1 + p.sizx(ptr(k,3))*scale - 1;
    y2  = y1 + p.sizy(ptr(k,3))*scale - 1;
    box(k,:) = [x1 y1 x2 y2];
  end
  box = reshape(box',1,4*numparts);
  
  
  
