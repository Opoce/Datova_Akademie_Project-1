# Datova_Akademie_Project-1
Zpracovala Daniela Černá, cernada@centrum.cz, discord: daniela_dlce

datové podklady, ve kterých je možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období v České republice

postup zpracování: nejprve jsem vytvořila skripty pro jednotlivé dotazy ze zadání (1-5), kde jsem využila původní datové sady. Tak jsem si zmapovala, jaká data bude potřeba vložit do nových tabulek. Poté jsem vytvořila tabulky t_daniela_cerna_sql_project_primary_final a t_daniela_cerna_sql_project_secondary_final. S jejich využitím jsem pak aktualizovala původní dotazy a vytvořila jejich finální verzi (vždy označené jako *_fin). Vznikly tak dvě sady odpovědí s využitím různých zdrojů. Do tohoto úložiště jsem původně nahrála všechny scripty, nakonec zde ale nechávám jen ty finální, aby to bylo přehlednější. 

RQ1_fin - srovnání mezd v jednotlivých sektorech po letech, označení růstu / poklesu mezd ve srovnání s předchozím obdobím --> v průběhu let v některých obdobích průměrná mzda klesala.

RQ2_fin - srovnání průměrných mezd a průměrných cen mléka a chleba po čtvrtletích. Výpočet, kolik chleba (1kg) či mléka (1l) si za danou mzdu můžeme koupit --> v prvním čtvrtletí roku 2006 bylo možno koupit za průměrnou mzdu 1357,81 kg chleba a 1406,47 l mléka. V posledním čtvrtletí roku 2018 bylo možno koupit 1471,23 kg chleba a 1802,03 l mléka.

RQ3_fin - výpočet průměrných cen produktů v jednotlivých kategoriích po rocích, srovnání procentuální změny cen mezi prvním a posledním rokem datasetu po produktech --> nejmenší nárůst (resp. nejvyšší pokles ceny) zaznamenáváme u položky Cukr krystalový

RQ4_fin - srovnání růstu mezd a cen (v %) a označení těch potravin, u kterých byl násrůst ceny o více než 10 % vyšší než růst mzdy v daném roce --> kromě let 2009 a 2014 v každém roce se to týká alespoň jedné potraviny

RQ5_fin - srovnání růstu mezd, cen, HDP --> vytvořeny dva dotazy, jeden včetně cen kategorií potravin, jeden obsahuje průměr cen. Na položenou otázku neexistuje jednoznačná odpověď, určitý vliv růstu/poklesu HDP na mzdy a ceny potravin tu je, ale není určitě 1:1 a ani se neprojeví v obou oblastech stejně silně.

