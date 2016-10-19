function d = normaliza( c )
c = double(c);
c = c/max(c(:))*255;
c=uint8(c);
d=c;
end

