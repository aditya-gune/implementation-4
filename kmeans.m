% Runs kmeans on data, creating k clusters.
function assignments = kmeans(data, k)
% Initialize the clusters randomly
[assignments, vectors] = initializeClusters(data, k);

numPoints = size(data, 1);
% Run while the clusters are still evening out 
change = true;
while change
   change = false;

   [change, assignments] = updateAssignments(data, assignments, vectors);
   
   if change
       vectors = updateVectors(data, assignments, vectors);
   end
end

end

% Randomly initializes k clusters in the data set. 
% vectors represents the clusters' centers.
function [assignments, vectors] = initializeClusters(data, k)
% Check that data is big enough
if k > size(data, 1)
    return;   
end

remainingData = data;
assignments = zeros(size(data, 1));
vectors = zeros(k); 

% choose k data points randomly
for i = 1:k
    vertexIndex = ceiling(rand()*size(remainingData, 1));
    % Record the selected vertex as a cluster center
    vectors(i) = remainingData(vertexIndex, :);
    % and remove it from the remaining possibilities
    remainingData(vertexIndex, :) = [];
end

% Assign data points to the initialized clusters
for i = 1:size(data, 1)
    assignments(i) = nearestCluster(data(i), vectors);
end
end

% Assigns each data point to the closest cluster, returning change=true if
% any changes were made
function [change, assignments] = updateAssignments(data, assignments, vectors)
numPoints = size(data, 1);
for i = 1:numPoints
   newCluster = nearestCluster(data(i), vectors);
   if newCluster ~= assignments(i)
      assignments(i) = newCluster;
      change = true; % a data point is now in a different cluster
   end
end
end

% Updates centers of gravity for all vectors, given data and clusters.
function vectors = updateVectors(data, assignments, vectors)
numPoints = size(data, 1);
for i = 1:numPoints
    centroid = 0;
    count = 0;
    for j = 1:numPoints
        if assignments(j) == i
            centroid = centroid + data(j);
            count = count + 1;
        end
    end
    % reestablish center of gravity
    vectors(i) = centroid/count;
end
end

% returns the index of the cluster nearest to the given data point
function nearCluster = nearestCluster(dataPt, vectors)
    closestDistance = inf;
    for i = 1:size(vectors, 1)
       distance = norm(dataPt - vectors(i));
       if distance < closestDistance
          closestDistance = distance;
          nearCluster = i;
       end
    end
end