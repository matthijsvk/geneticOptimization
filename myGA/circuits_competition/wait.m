function flag=wait(t)

flag=false;
pause(0.25);
cnt=0;
while t.BytesAvailable == 0
    pause(0.1);
    cnt=cnt+1;
    if cnt==10
        flag=true;
        break;
    end
end

end