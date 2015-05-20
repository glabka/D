# Poznámky
* Platnost dat bych mohl zkusit kontrolovat **pomocí regulárních výrazů**, tj if [[ "$var" =~ regex ]].
  Budu muset zkontrolovat platnost dat, zadaných v souboru. To znamená **zkontrolovat každý řádek**.
  Kontrolu provedu tak, **zda ma dost parametrů** (minimálně př. pro recept: jméno, autor, igredience, hmotnost)
  a jestli to je **sudé** (počet by měl být sudý) a jestli něco **není prázdné**, abych tam neměl NULLy.
  Až potom, co zkontroluji všechny řádky je budu moct začít vykonávat. Proto si výsledky jednotlivých
  zkontrolovaných řádků budu muset **ukládat do pole**. Možná bude nejlepší, když si pro každý řádek budu
  do pole ukládat již **celý sql** příkaz. Dále by se ještě mohlo stát, že by se například v receptu
  vyskytla **dvakrát stejná surovina**. A další problém je, když se někdo pokusí přidat př. recept s již
  **existujícím jménem a autorem**. Dále musím pohlídat to, že příslušný recept/jídlo již může existovat...
* http://stackoverflow.com/questions/16460397/sql-insert-into-table-only-if-record-doesnt-exist
* http://stackoverflow.com/questions/20971680/sql-server-insert-if-not-exist
* možná ještě trochu upravit výpis funkce: query_recipes
* "./food_manager --query recipes" by mělo najít recepty bez autora, tj. s NULL, což zatím nedělá
* --debug => výpisy zapnuté tímto by měli jít asi na stderr
* možná přepiš první sql příkaz query, co jsi napsal, tj. sql recepies <author> z kratézského součinu na join
* debug u query by mohl vždy vypsat i ty tabulky, se kterými pracuji... (a třeba fridge a podobně by mohl seřadit podle abecedy podle jména suroviny...)

* určitě bych měl ještě pořešit návratové hodnoty a především to, jak zjistit návratovou hodnotu z $( run_my_sql ...), jelikož to je subshell či co...
* insert_test_data.sql bych měl přepsat do vstupních souborů recepty.txt a jidla.txt
*
