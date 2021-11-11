function product=inStoreOrder(type)
    dough=prepareDough();
    switch type
        case 'chunk'
            noodle=prepareChunkNoodle(dough);
            boildednoodle=boilNoodle(noodle,'longer');
        case 'regular'
            noodle=prepareRegularNoodle(dough);
            boilednoodle=boilNoodle(noodle,'regular');
    end
    soup=prepareSoup();
    product=mixSoupAndNoodle(boilednoodle,soup);
end