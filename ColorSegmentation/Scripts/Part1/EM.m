clear
clc
x2 = -5+randn(1000,1);
x1 = randn(1000,1);
x3 = 5+randn(1000,1);
msize = numel(x1);
gaus1 = x1(randperm(msize, 100));
gaus2 = x2(randperm(msize, 100));
gaus3 = x3(randperm(msize, 100));
r = rand(100,1);
z1 = (r<(1/3));
z2 = (r<(2/3) & r>=(1/3));
z3 = (r>=(2/3));
gaus = gaus1.^z1.*gaus2.^z2.*gaus3.^z3;
[val,binlocations]=hist(gaus);
GMModel = fitgmdist(gaus,3);
muGaus1 = GMModel.mu(3);
muGaus2 = GMModel.mu(2);
muGaus3 = GMModel.mu(1);
sigmaGaus1 = GMModel.Sigma(3);
sigmaGaus2 = GMModel.Sigma(2);
sigmaGaus3 = GMModel.Sigma(1);
% hist(gaus);hold on;
histogram(gaus1);hold on;
histogram(gaus2);hold on;
histogram(gaus3);hold on;
histogram(gaus);hold on;
p = plot([-10:0.1:10]',100*pdf(GMModel,[-10:0.1:10]'),'r')
p.LineWidth = 2;
xlim([-10 10]);

