#!/bin/csh

set c = 0

foreach d ($*)
    if (-d $d) then
        set files = $d/*
    else
        set files = $d
    endif
    foreach f ($files)
        set size = `stat -c %s $f`
        @ size = $size - 11
        dd if=$f bs=1 skip=10 | dd bs=1 count=$size > d/.$c
        @ c = $c + 1
    end
end

set c = 0
while (-e d/.$c)
    mv d/.$c d/$c
    @ c = $c + 1
end
