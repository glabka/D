# Zadání semestrální práce D
## obecné:
* do sql skriptu nepište jméno databáze! tabulky se musí umět vytvořit v libovolné databázi ve které se skript spustí.
* [x] Dostatečně objemná data, alespoň 10 záznamů na největší tabulku
    * [ ] + všechny speciální případy.
* 3. normální forma
    * [x] 1. n.f. == všechna data jsou atomická
    * [x] 2. n.f. == Rozklad tak, aby klíče byly jednoduché atributy
    * [ ] 3. n.f. == ?
* každý bod dotazování == jeden sql-dotaz
* Vstupní soubory:
    * hodnoty oddělené čárkou (před a za čárkou může být libovolný počet mezer)
    * předpoklad, že žádný řetězec neobsahuje znak čárky.
* plnění databází přes standardní vstup (tj. půjde to i ručně)
* nekonzistence ve vstupních souborech nepředpokládáme (resp. řešíme dle vlastního uvážení)
* datum ve vstup. souboru má formát: YYYY-MM-DD
* Název databáze, uživatelské jméno a heslo načítejte z proměnných prostředí OSD_DB, OSD_USERNAME a OSD_PASSWORD.
* [ ] V každém skriptu vyplňte hlavičku obsahující účel skriptu, jména a e-maily autorů a aktuální semestr.
* společné parametry:
    * [x] --insert
        * [ ] kontrola vstupu
    * [ ] --query
        * [ ] kontrola vstupu
    * [x] --variant == vypíše variantu zadání na stdout
    * [ ] --debug == vypisuje více ladících výpisů
* návratové hodnoty:
    * [ ] 0 - vše v pořádku
    * [ ] 1 - špatné parametry
    * [ ] 2 - prázdná odpověď z SQL serveru (popř. jiné neočekávané chování)
    * [ ] 3 - chyba připojení k databázi / k serveru
    * [ ] 10 a více - další vámi definované chybové stavy

* **některé požadavky z úlohy pro BASH:**
    * [ ] -h = vypíše nápovědu (help) a vrátí 0.
    * komentáře v aj, nebo bez diakritiky.
    * [x] vhodné jméno napovídající použití
    * POZOR = linuxovské ukončování řádku (jinak může skript dělat problémy)
    * Vše v jednom souboru.

## Varianta 2 ("kuchařka"):
* poznámka: jméno pokrmu, surovin i prodejen mohou obsahovat mezery.
* Jedna surovina může být prodávána ve více prodejnách a prodejna může prodávat více surovin.
* Jméno autora se skládá ze jména a příjmení.
    * [ ] Toto možná znamená, že aby byla splněna podmínka atomicity, tak by měl být zvlášť sloupec
    na jméno a přijímení.
