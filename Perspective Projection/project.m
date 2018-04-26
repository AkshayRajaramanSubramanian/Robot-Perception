function coordinates = project(Xk,R,T,k)
    H =[R T;zeros([1 size(R,1)]) 1];
    Xc = [Xk;ones([1 size(Xk,2)])];
    x = H*Xc;
    k = [k ones([size(k,1) 1])];
    xbar = k*x;
    coordinates(1,:) = xbar(1,:)./xbar(3,:);
    coordinates(2,:) = xbar(2,:)./xbar(3,:);
end