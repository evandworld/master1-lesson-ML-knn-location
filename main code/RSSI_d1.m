%load('data');
clc;clear;close all;
%% ����˵��
%fingerprint:   ָ�����ݿ�,7m*4m, 6AP
%RSS:    6��������ݵ�RSS
%p:   6��������ݵ���ʵλ��
load('finger1');load('finger2');
%% KNN�㷨
n = 3;%ʹ��AP����Ŀ������ʹ��ȫ��3����<=n_AP��
k = 1;%���ֵ��������
p_KNN = 0;%�涨λ���
fingerprint_d=2.*power(10,(-fingerprint-17)/25);
RSS_d=2.*power(10,(-RSS-17)/25);
for i=1:6   %��˳��ֱ��ÿһ�����ݶ�λ
    [size_x, size_y, n_AP] = size(fingerprint);
    %����ŷ�Ͼ���
    distance = 0;
    for j=1:n
        distance = distance + (fingerprint_d(:,:,j)-RSS_d(i,j)).^2;%����ͬʱ�������вο��㣬�����һ����ά����
    end
    distance = sqrt(distance);
    %��ŷ�Ͼ�������ѡ��k����С�ģ��õ�λ��
    d = reshape(distance,1,size_x*size_y);
    [~, index_d]=sort(d);
    knn_y = (mod(index_d(1:k),size_x));
    knn_x = (floor(index_d(1:k)./size_x)+1);
    if knn_y==0
        knn_y=size_x;
        knn_x=knn_x-1;
    end
    p_KNN(i,1:2) = [mean(knn_x), mean(knn_y)];%k��λ����ƽ��
end

%��һ��ͼ����ɫ����b-o����ʵ·���������Ƕ�λ�����λ��
plot(p(:,1),p(:,2),'bo');  %���Ʋ��Լ���ʵλ��
axis([0 7 0 4])
grid on;hold on;
plot(p_KNN(:,1),p_KNN(:,2),'r*');  %���Ʋ��Լ��ļ���λ��
xlabel('�����꣨�ף�');ylabel('�����꣨�ף�');
for i=1:size(p_KNN)
    hold on;plot([p_KNN(i,1),p(i,1)],[p_KNN(i,2),p(i,2)],'g--');  %����ƫ����ڹ۲�
end
legend('��ʵλ��','����λ��','ƫ��')
error_KNN=sqrt((p(:,1)-p_KNN(:,1)).^2+(p(:,2)-p_KNN(:,2)).^2);
disp('KNNƽ����')
disp(mean(error_KNN));

%%
%KNN�㷨�����ʵ�õķ���
%����k�����Լ���΢��һ��
%������ν��WKNN����k��λ��ƽ����ʱ��ʹ�ü�Ȩƽ����������Ч�����Բ���
%����ŷ�Ͼ��룬����Ҳ�����������ľ��루�����پ��밡ʲô�ģ�
%�����㷨����û��һ���ϸ��֤������ӳ��λ���ȣ����и��ֲ�������������ϸ��Ҳ�����ģ���Ҫ�����о�ָ�Ʒ��Ļ�ȥ�����ʷ����ɡ�

%�Լ�ʵ��kNN�Ļ������Ը���ʵ������������ϸ����һЩ�Ľ�������AP��ѡ��...�����ֻ����һ��knn��������matlab���Դ��Ĺ��߰�
