function noodlesoup=Order()
dough=prepareDough();
noodle=prepareNoodle();
boildedNoodle=boilNoodle(noodle);
soup=prepareSoup();
noodlesoup=mix(boildedNoodle,soup);
end