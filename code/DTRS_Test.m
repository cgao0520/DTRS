%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DTRS_Test(data_set,label,lamda,w,xw,tst_set,tst_lab)


[r,c] = size(tst_set);

c_c = 0;

for i=1:r % iterate all test set
    samp = tst_set(i,:);
    lab = tst_lab(i);
    rr = size(w,1);
    Rp=0;
    Rn=0;
    Rb=0;
    for j=1:rr
        lab = w(j,1);
        p = Pwjx(data_set,label,samp,lab,w,j);
        
        Rp = Rp + lamda(j,1)*p;
        Rn = Rn + lamda(j,2)*p;
        Rb = Rb + lamda(j,3)*p;
    end
    if Rp <= Rn && Rp <= Rb
        b=-1;
        str = sprintf('No.%d: +(%c)',i,GetSymbol(tst_lab(i)));
    elseif Rn <= Rp && Rn <= Rb
        b=1;
        str = sprintf('No.%d: -(%c)',i,GetSymbol(tst_lab(i)));
    elseif Rb <= Rp && Rb <= Rn
        b=-99;
        str = sprintf('No.%d: ?(%c)',i,GetSymbol(tst_lab(i)));
    else
        b=-99;
        str = sprintf('No.%d: Can not classify(%c)',i,GetSymbol(tst_lab(i)));
    end
    disp(str); 
    if b == tst_lab(i)
        c_c = c_c + 1;
    end
end
str = sprintf('Total accurate rate: %0.4f',c_c/r);
disp(str);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = GetSymbol(lab)
if lab == -1
    c = '+';
else
    c = '-';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = Pwjx(data_set,label,x,l,w,j)

p = PxwiPwi(data_set,label,x,l,w,j);

[r,c] = size(w);
sum = 0;
for i=1:r
    sum = sum + PxwiPwi(data_set,label,x,l,w,i);
end
Pwjx = p/(max(sum,0.000001));
val = Pwjx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = PxwiPwi(data_set,label,x,l,w,j)


if j<0
   j = GetIndexOfw(w,l);
end

r = size(x,2);

Pxwi = 1;
for i=1:r
    val = x(i);
    xi = size(find(data_set(:,i)==val & label==l),1);
    Pxwi = Pxwi*(xi/w(j,2));
end
pxwi_pwi = Pxwi*w(j,3);
val = pxwi_pwi;

    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ind = GetIndexOfw(w,lab)
ind = -1;
[r,c] = size(w);
for i=1:r
    if w(r,1) == lab
        ind = i;
        break;
    end
end
    