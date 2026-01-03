function [lamda,w,xw] = GenDTRS_DataSet(dataset,label)

lamda = [0,100,10;500,0,20];

w=[];
xw=[];

[r,c]=size(label);
for i=1:r
    lab = label(i,1);
    [rr,cc] = size(w);
    bFlag = 0;
    for j=1:rr
        if w(j,1) == lab
            w(j,2) = w(j,2) + 1;
            bFlag = 1;
            break;
        end
    end
    if bFlag == 0
        w(rr+1,1) = lab;
        w(rr+1,2) = 1;
    end
end


[r,c] = size(dataset);
for i=1:r
    samp = dataset(i,:);
    lab = label(i);
    p=1;
    for j=1:c
        val = samp(j);
        x = size(find(dataset(:,j)==val & label==lab),1);
        ww = w(find(w==lab),2);
        p = p* (x / ww);
    end
    %xw(i,1)=i;
    xw(i,1)=p;
end

w(:,3) = w(:,2)/r;