clear;
 
%Считываем изображения для дальнейгей обработки
Image_color=imread('C:\Users\Виктор\Desktop\курсуои\lena.bmp');%источник цвета 
Image_vosstanov_color=imread('C:\Users\Виктор\Desktop\курсуои\lena.bmp');%изображение с восстановленным цветом
[H W s]=size(Image_vosstanov_color);% запись размерности изображения
%перевод в YCBCR пространство 
Image_ycbcr=rgb2ycbcr(Image_color);%черно-белое изображение для восстановления цвета
Image_vosstanov_color_YCbCr=rgb2ycbcr(Image_vosstanov_color);%изображение с восстановленым цветом в YCbCr
 
%для упрощения вычисления мат.ож и дисперсии области вокруг случайного пикселя расширим наше изображения дополнив его нулями по краям
Zero=15*2;%количество заполняемых нулей по краям, так как делим на 15 блоков ,то заполним по краям в два раза увеличив это значение
Image_Y = padarray(Image_ycbcr(:,:,1),[Zero Zero]);%заполняем нуями по крам
Image_CB=padarray(Image_ycbcr(:,:,2),[Zero Zero]);
Image_Cr=padarray(Image_ycbcr(:,:,3),[Zero Zero]);
 
%расчитаем размеры подблоков 
block_size_y=ceil(H/15);%подблоки 
block_size_x=ceil(W/15);
 
r=12;%радуис вокрус пикселя
 
count=1;%счетчик
 
%массивы для палитры
Cb=zeros(1,225);
Cr=zeros(1,225);
MATH=zeros(1,225);%математическое ожидание
Disp=zeros(1,225);%дисперсия
 
%-----------------------------------------Создание палитры-------------------------
 
%обход расширеного изображения по блокам,
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
    % rand_pix_ii, rand_pix_jj - координаты случайного пикселя в блоке, привязанные к координатами блока в изображении
         rand_pix_ii = i + unidrnd(block_size_y) - 1;
         rand_pix_jj = j + unidrnd(block_size_y) - 1;
       end
    %записываем значения Cb и Cr нашего случайного пикселя для палитры
         Cb(1,count)=Image_CB(rand_pix_ii,rand_pix_jj);
         Cr(1,count)=Image_Cr(rand_pix_ii,rand_pix_jj);
    
    % область area радиуса r вокруг пикселя с координатами rand_pix_ii,rand_pix_jj из расширенной картинки
         area = double(Image_Y(rand_pix_ii-r:rand_pix_ii+r, rand_pix_jj-r:rand_pix_jj+r));
         
    %считаем математическое ожидание и диспрерсию в области случ.пикселя
         MATH(1,count)= mean(mean(area));%мат ожидание
         Disp(1,count)=var(area(:));%дисперсия
 
        count=count+1;
 
     end
end
 
 
%--------------------------------Раскрашивание изображаения---------------------------
count1=1;%счетчик
%массивы для мат.ожиданий и дисперсий для каждого пикселя с радиусом r
MATH1=zeros(1,512*512);
Disp1=zeros(1,512*512);
%размерность восстанвливаемого изображения
 
granica_H=0;%конец изображения по высоте,счетчик для определения конца изначального изображения в расширеном изображении
for i = 30+1 : 1 : 30+H
   if granica_H<H
      granica_W=0;%конец изображения по высоте
         for j = 30+1 : 1 : 30+W
             if granica_W<W
 
    % Вырезаем область area радиуса r вокруг пикселя 
                area = double(Image_Y(i-r:i+r, j-r:j+r));
                
    %подсчет мат.ож и дисп вокруг этого пикселя
                MATH1(1,count1)= mean(mean(area));%мат ожидание
                Disp1(1,count1)=var(area(:));%дисперсия
    
    %Находим значения для записи Cb и Cr, для оценки схожести используем евклидово расстояние между исходным и палитрой
                c1=100000000000000000000000000000;%некая переменная большой размерности
                  for ii=1:1:225
                      c= sqrt(((MATH1(1,count1)-MATH(1,ii))^2)+((Disp1(1,count1)-Disp(1,ii))^2)); 
                       if c<c1
                          c1=c;
                          tt=ii;
                       end
                  end
                  
  %запись новых значений Cb и Cr в изображение, которое хотим раскрасить
    Image_vosstanov_color_YCbCr(i-30,j-30,2)=Cb(1,tt);
    Image_vosstanov_color_YCbCr(i-30,j-30,3)=Cr(1,tt);
    
    %увелчиние счетчика
    granica_W=granica_W+1;
    count1=count1+1;
             end
         end
  granica_H=granica_H+1;
   end
end
 
 
%Вывод результатов 
 
figure(1);
L_Y=Image_ycbcr(:,:,1);
imshow(L_Y);
title('черно белое изображение');
figure(2);
imshow(Image_color);
title('источник цвета');
figure(3);
 L_pad1=ycbcr2rgb(Image_vosstanov_color_YCbCr);
imshow(L_pad1);
title('получившееся изображение');
 
 

