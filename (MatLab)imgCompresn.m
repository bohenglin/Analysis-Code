imdata = imread('panises.jpg'); %load the image
A = im2double(imdata); %convert from uint8 matrix to double
[U,S,V] = svd(A); %compute SVD


%% 

s = svds(A,1225); %singular values in decreasing order
plt = plot(s); %plot out all singular values of A
% The singular values of A decay extremely fast, mimicing an exponential
% decay


%% 
% k=10
for N=10
 % store the singular values in a temporary variable
 C = S;
 % discard the diagonal values not required for compression
 C(N+1:end,:)=0;
 C(:,N+1:end)=0;
 % Construct an Image using the selected singular values
 Newim10=U*C*V';
 % display
 figure;
 imshow(Newim10);
end
% the image is extremely blur. While each flower can be distinguished, it
% is difficult to identify each petal of each flower.


%% 

%k=25
for N=25
 % store the singular values in a temporary variable
 C = S;
 % discard the diagonal values not required for compression
 C(N+1:end,:)=0;
 C(:,N+1:end)=0;
 % Construct an Image using the selected singular values
 Newim25=U*C*V';
 % display
 figure;
 imshow(Newim25);
end

% Compared to that using k=10, this image is slightly clearer. Lines for
% parts of the petals are sharper.
%% 

%k=50
for N=50
 % store the singular values in a temporary variable
 C = S;
 % discard the diagonal values not required for compression
 C(N+1:end,:)=0;
 C(:,N+1:end)=0;
 % Construct an Image using the selected singular values
 Newim50=U*C*V';
 % display
 figure;
 imshow(Newim50);
end

% Compared to the results k=10 and k=25, outlines for each petal are now
% much clearer. However, the stems are still difficult to identify
%% 

%k=100
for N=100
 % store the singular values in a temporary variable
 C = S;
 % discard the diagonal values not required for compression
 C(N+1:end,:)=0;
 C(:,N+1:end)=0;
 % Construct an Image using the selected singular values
 Newim100=U*C*V';
 % display
 figure;
 imshow(Newim100);
end

% Most clear image among all results. Both the outlines of the petals and
% stems, little leaves on the stems can be identified. Somewhat smooth
% transition between different shades of gray too.


%% 

% One way to identify the optimal parameter k could via the computation of
% error from the approximated matrix. As the decrease in error comes at the
% price of increasing k (and thus increasing cost of memory and computing
% power), we want to choose k right before it introduce a significant drop 
% in error. 

% initiate an empty array to contain errors
 error = zeros([1 100]);
for N=1:1:100  %check the error for k = 1: 100
 % store the singular values in a temporary variable
 C = S;
 % discard the diagonal values not required for compression
 C(N+1:end,:)=0;
 C(:,N+1:end)=0;
 % Construct an Image using the selected singular values
 ErrIm=U*C*V';
 % finding errors and add to the error array
 error(N) = sum(sum((ErrIm - A).^2));
 plterr=plot(error);
end

% from the error plot, it seems that the plot tends to have a linear
% decrease after k=40. The optimal k = 40.

