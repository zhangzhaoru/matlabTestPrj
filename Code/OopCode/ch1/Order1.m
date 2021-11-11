function product=Order1(type)
    dough=prepareDough()
    switch type
        case 'chunk'
            nnoodle=prepareChunkNoodle(dough);
            boilednoodle=boilNoodle(noodle,'longer');
            soup=prepareSoup();
            product=mixSoupAndNoodle(boilednoodle,soup);
        case 'regular'
            noodle=prepareRegularNoodle(dough);
            boilednoodle=boilNoodle(noodle,'regular');
            soup=prepareSoup();
            product=mixSoupAndNoodle(boilednoodle,soup);
        case 'fry'
            noodle=prepareFryNoodle(dough);
            boildnoodle=boilNoodle(noodle,'short');
            product=fryNoodle(boilednoodle);
    end
end