# Poznámky
* budu muset zkontrolovat platnost dat, zadaných v souboru. To znamená **zkontrolovat každý řádek**.
  Kontrolu provedu tak, **zda ma dost parametrů** (minimálně př. pro recept: jméno, autor, igredience, hmotnost)
  a jestli to je **sudé** (počet by měl být sudý) a jestli něco **není prázdné**, abych tam neměl NULLy.
  Až potom, co zkontroluji všechny řádky je budu moct začít vykonávat. Proto si výsledky jednotlivých
  zkontrolovaných řádků budu muset **ukládat do pole**. Možná bude nejlepší, když si pro každý řádek budu
  do pole ukládat již **celý sql** příkaz. Dále by se ještě mohlo stát, že by se například v receptu
  vyskytla **dvakrát stejná surovina**. A další problém je, když se někdo pokusí přidat př. recept s již
  **existujícím jménem a autorem**. Dále musím pohlídat to, že příslušný recept/jídlo již může existovat...
* http://stackoverflow.com/questions/16460397/sql-insert-into-table-only-if-record-doesnt-exist
* http://stackoverflow.com/questions/20971680/sql-server-insert-if-not-exist
