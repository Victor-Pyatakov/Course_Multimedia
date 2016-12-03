clear;
 
%��������� ����������� ��� ���������� ���������
Image_color=imread('C:\Users\������\Desktop\�������\lena.bmp');%�������� ����� 
Image_vosstanov_color=imread('C:\Users\������\Desktop\�������\lena.bmp');%����������� � ��������������� ������
[H W s]=size(Image_vosstanov_color);% ������ ����������� �����������
%������� � YCBCR ������������ 
Image_ycbcr=rgb2ycbcr(Image_color);%�����-����� ����������� ��� �������������� �����
Image_vosstanov_color_YCbCr=rgb2ycbcr(Image_vosstanov_color);%����������� � �������������� ������ � YCbCr
 
%��� ��������� ���������� ���.�� � ��������� ������� ������ ���������� ������� �������� ���� ����������� �������� ��� ������ �� �����
Zero=15*2;%���������� ����������� ����� �� �����, ��� ��� ����� �� 15 ������ ,�� �������� �� ����� � ��� ���� �������� ��� ��������
Image_Y = padarray(Image_ycbcr(:,:,1),[Zero Zero]);%��������� ����� �� ����
Image_CB=padarray(Image_ycbcr(:,:,2),[Zero Zero]);
Image_Cr=padarray(Image_ycbcr(:,:,3),[Zero Zero]);
 
%��������� ������� ��������� 
block_size_y=ceil(H/15);%�������� 
block_size_x=ceil(W/15);
 
r=12;%������ ������ �������
 
count=1;%�������
 
%������� ��� �������
Cb=zeros(1,225);
Cr=zeros(1,225);
MATH=zeros(1,225);%�������������� ��������
Disp=zeros(1,225);%���������
 
%-----------------------------------------�������� �������-------------------------
 
%����� ����������� ����������� �� ������,
for i = Zero+1 : block_size_y : Zero+H
     for j = Zero+1 : block_size_x : Zero+W
       if j ==521
           rand_pix_ii = i + unidrnd(block_size_y) - 1;
         rand_pix_jj = j + unidrnd(block_size_y) - 15;
       elseif  i==521
           rand_pix_ii = i + unidrnd(block_size_y) - 15;
         rand_pix_jj = j + unidrnd(block_size_y) - 1;
           elseif j==521 && i==521
           rand_pix_ii = i + unidrnd(block_size_y) - 15;
         rand_pix_jj = j + unidrnd(block_size_y) - 15;  
       else
    % rand_pix_ii, rand_pix_jj - ���������� ���������� ������� � �����, ����������� � ������������ ����� � �����������
         rand_pix_ii = i + unidrnd(block_size_y) - 1;
         rand_pix_jj = j + unidrnd(block_size_y) - 1;
       end
    %���������� �������� Cb � Cr ������ ���������� ������� ��� �������
         Cb(1,count)=Image_CB(rand_pix_ii,rand_pix_jj);
         Cr(1,count)=Image_Cr(rand_pix_ii,rand_pix_jj);
    
    % ������� area ������� r ������ ������� � ������������ rand_pix_ii,rand_pix_jj �� ����������� ��������
         area = double(Image_Y(rand_pix_ii-r:rand_pix_ii+r, rand_pix_jj-r:rand_pix_jj+r));
         
    %������� �������������� �������� � ���������� � ������� ����.�������
         MATH(1,count)= mean(mean(area));%��� ��������
         Disp(1,count)=var(area(:));%���������
 
        count=count+1;
 
     end
end
 
 
%--------------------------------������������� ������������---------------------------
count1=1;%�������
%������� ��� ���.�������� � ��������� ��� ������� ������� � �������� r
MATH1=zeros(1,512*512);
Disp1=zeros(1,512*512);
%����������� ����������������� �����������
 
granica_H=0;%����� ����������� �� ������,������� ��� ����������� ����� ������������ ����������� � ���������� �����������
for i = 30+1 : 1 : 30+H
   if granica_H<H
      granica_W=0;%����� ����������� �� ������
         for j = 30+1 : 1 : 30+W
             if granica_W<W
 
    % �������� ������� area ������� r ������ ������� 
                area = double(Image_Y(i-r:i+r, j-r:j+r));
                
    %������� ���.�� � ���� ������ ����� �������
                MATH1(1,count1)= mean(mean(area));%��� ��������
                Disp1(1,count1)=var(area(:));%���������
    
    %������� �������� ��� ������ Cb � Cr, ��� ������ �������� ���������� ��������� ���������� ����� �������� � ��������
                c1=100000000000000000000000000000;%����� ���������� ������� �����������
                  for ii=1:1:225
                      c= sqrt(((MATH1(1,count1)-MATH(1,ii))^2)+((Disp1(1,count1)-Disp(1,ii))^2)); 
                       if c<c1
                          c1=c;
                          tt=ii;
                       end
                  end
                  
  %������ ����� �������� Cb � Cr � �����������, ������� ����� ����������
    Image_vosstanov_color_YCbCr(i-30,j-30,2)=Cb(1,tt);
    Image_vosstanov_color_YCbCr(i-30,j-30,3)=Cr(1,tt);
    
    %��������� ��������
    granica_W=granica_W+1;
    count1=count1+1;
             end
         end
  granica_H=granica_H+1;
   end
end
 
 
%����� ����������� 
 
figure(1);
L_Y=Image_ycbcr(:,:,1);
imshow(L_Y);
title('����� ����� �����������');
figure(2);
imshow(Image_color);
title('�������� �����');
figure(3);
 L_pad1=ycbcr2rgb(Image_vosstanov_color_YCbCr);
imshow(L_pad1);
title('������������ �����������');
 
 

