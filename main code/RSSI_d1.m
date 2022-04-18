%load('data');
clc;clear;close all;
%% 数据说明
%fingerprint:   指纹数据库,7m*4m, 6AP
%RSS:    6组测试数据的RSS
%p:   6组测试数据的真实位置
load('finger1');load('finger2');
%% KNN算法
n = 3;%使用AP的数目，这里使用全部3个（<=n_AP）
k = 1;%求均值的样本量
p_KNN = 0;%存定位结果
fingerprint_d=2.*power(10,(-fingerprint-17)/25);
RSS_d=2.*power(10,(-RSS-17)/25);
for i=1:6   %按顺序分别给每一个数据定位
    [size_x, size_y, n_AP] = size(fingerprint);
    %计算欧氏距离
    distance = 0;
    for j=1:n
        distance = distance + (fingerprint_d(:,:,j)-RSS_d(i,j)).^2;%这里同时计算所有参考点，结果是一个二维矩阵
    end
    distance = sqrt(distance);
    %将欧氏距离排序，选择k个最小的，得到位置
    d = reshape(distance,1,size_x*size_y);
    [~, index_d]=sort(d);
    knn_y = (mod(index_d(1:k),size_x));
    knn_x = (floor(index_d(1:k)./size_x)+1);
    if knn_y==0
        knn_y=size_x;
        knn_x=knn_x-1;
    end
    p_KNN(i,1:2) = [mean(knn_x), mean(knn_y)];%k个位置求平均
end

%画一下图：蓝色的线b-o是真实路径，红星是定位算出的位置
plot(p(:,1),p(:,2),'bo');  %绘制测试集真实位置
axis([0 7 0 4])
grid on;hold on;
plot(p_KNN(:,1),p_KNN(:,2),'r*');  %绘制测试集的计算位置
xlabel('横坐标（米）');ylabel('纵坐标（米）');
for i=1:size(p_KNN)
    hold on;plot([p_KNN(i,1),p(i,1)],[p_KNN(i,2),p(i,2)],'g--');  %绘制偏差，便于观察
end
legend('真实位置','计算位置','偏差')
error_KNN=sqrt((p(:,1)-p_KNN(:,1)).^2+(p(:,2)-p_KNN(:,2)).^2);
disp('KNN平均误差：')
disp(mean(error_KNN));

%%
%KNN算法是最简单实用的方法
%参数k可以自己稍微调一调
%另外所谓的WKNN（求k个位置平均的时候使用加权平均），改善效果忽略不计
%除了欧氏距离，我们也可以用其他的距离（曼哈顿距离啊什么的）
%这种算法本身没有一个严格的证明来反映定位精度，所有各种参数随便调，各种细节也能随便改，相要深入研究指纹法的话去看概率方法吧。

%自己实现kNN的话，可以根据实际情况对里面的细节做一些改进，比如AP的选择...，如果只是做一个knn分类器，matlab有自带的工具包
