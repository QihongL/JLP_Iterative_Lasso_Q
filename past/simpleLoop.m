function x = simpleLoop(n)
    x = 0;
    
    for i = 1:n
        increment()
    end
    
    function increment()
        x = x + 1;
    end
end
        