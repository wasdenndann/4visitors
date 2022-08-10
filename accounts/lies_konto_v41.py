import csv, mysql.connector, os
from datetime import date, datetime

"""         ursprüngliche Dateiliste
dateien = ["20161231_1017804889.csv",
        "20161231_1037896139.csv",
        "20180117_1017804889.csv",
        "20180117_1037896139.csv",
        "20211220_4748________0366.csv",
        "20211220_4998________0651.csv",
        "20211220_4998________0669.csv",
        "20190104_1017804889.csv",
        "20190104_1037896139.csv",
        "20200102_1017804889.csv",
        "20200102_1037896139.csv",
        "20211220_1017804889.csv",
        "20211220_1037896139.csv",
        "20220128_500673389.csv",
        "20190104_4748________0366.csv",
        "20190104_4998________0651.csv",
        "20190104_4998________0669.csv",
        "20200101_4748________0366.csv",
        "20200101_4998________0651.csv",
        "20200101_4998________0669.csv",
        "20180117_4748________0366.csv",
        "20180117_4998________0651.csv",
        "20180117_4998________0669.csv"]
"""
# dateien =["20220220_4748________0366.csv"]


global wert, satz, zeile, ids, kto
wert = 0        #
satz = ""       #
zeile = 0       #
ids = []        # index numbers of processed data sets
kto = 0         #




def showFiles(): # @work              # suchen der neuen csv.files
    dateien_tabelle = []
    dateien_ordner = []
    for file in os.listdir():       # Dateien einlesen
        #if file[-3:] == "csv":
        if file[8:] in["_1017804889.csv", "_1037896139.csv", "_4748________0366.csv", "_4998________0651.csv", "_4998________0669.csv", "_500673389.csv"]:
            dateien_ordner.append(file)
    cursor.execute("SELECT datei FROM clag")
    for datei in cursor:
        dateien_tabelle.append(datei[0])
    dateien_ordner = set(dateien_ordner).difference(set(dateien_tabelle))
    dateien_ordner = list(dateien_ordner)
    return dateien_ordner


def date2date(datum):                 # auf sql-Datumsformat bringen
    year = int(datum[-4:])
    month = int(datum[-7:-5])
    day = int(datum[0:2])
    sql_date = (date(year, month, day))
    return sql_date


def strg2dec(wert):                   # Komma zu Dezimalpunkt
    wert = wert.replace(".","")
    dez = wert.replace(",",".")
    return dez


def owner(name):                      # Zuordnung Konto
    name = name.split(".")
    name = name[0][-4:]
    query = ("SELECT ID_owner FROM owner WHERE ktonummer='" + name + "'")
    cursor.execute(query)
    kto, = cursor.fetchone()
    return kto


def kktoTable(row):                   # Kreditkarten csv in Tabellen schreiben
    global ids, wert, satz
    
    # id für fk_ID_currency wenn Fremdwährung im Spiel
    if row[5] != "":
        ursprung = row[5].split()
        betrag = float(strg2dec(ursprung[0]))
        einheit = ursprung[1]
        query = "SELECT ID_currency FROM currency WHERE kurz='" + einheit + "'"
        add_data = "INSERT INTO currency (kurz) VALUES('" + einheit + "')"
        einheit = subTables(query, add_data)
    else:
        betrag = None
        einheit = None

    # id für fk_ID_beschreibungkk
    query = "SELECT  ID_beschreibungkk FROM beschreibungkk WHERE beschreibung='" + row[3] + "'"
    add_data = "INSERT INTO beschreibungkk (beschreibung) VALUES('" + row[3] + "')"
    beschreibung  = subTables(query, add_data)
       
    # insert rest aus csv.zeile mit Prüfung ob schon vorhanden
    query = ("SELECT ID_kk FROM kk WHERE wertstellung=%s AND belegdatum=%s AND fk_ID_owner=%s AND fk_ID_beschreibungkk=%s AND betrag=%s AND ursprung_betrag=%s AND fk_ID_currency=%s")
    add_dates = ("INSERT INTO kk "
                "(wertstellung, belegdatum, fk_ID_owner, fk_ID_beschreibungkk, betrag, ursprung_betrag, fk_ID_currency) "
                "VALUES(%s, %s, %s, %s, %s, %s, %s)")
    rowdata =(date2date(row[1]), date2date(row[2]), kto, beschreibung, float(strg2dec(row[4])), betrag, einheit)
    # print(rowdata)
    try:
        cursor.execute(query, rowdata)
        wert, = cursor.fetchone()
        if len(ids) >= 5 and wert in ids[-5:]:
            raise TypeError
        satz = "...schon vorhanden"
        return wert, satz
    except TypeError:
        cursor.execute(add_dates, rowdata)
        wert =cursor.lastrowid
        ids.append(wert)
        satz = "                    ...geschrieben..."
    sql.commit()
    
    return wert, satz


def giroktoTable(row):                # Girokarten in Tabelle schreiben
    global ids, saldo, saldo_datum, wert, satz
    
    # id für fk_ID_buchungstext = fk1
    query = "SELECT ID_buchungstext FROM buchungstext WHERE text='" + row[2] + "'"
    add_data = "INSERT INTO buchungstext(text) VALUES('" + row[2] + "')"
    fk1 = subTables(query, add_data)
    
    # id für fk_ID_betroffener = fk2
    query = "SELECT ID_betroffener FROM betroffener WHERE betroffener='" + row[3] + "'"
    add_data = "INSERT INTO betroffener(betroffener) VALUES('" + row[3] + "')"
    fk2 = subTables(query, add_data)
    
    # id für fk_ID_zweck = fk4
    query = "SELECT ID_zweck FROM zweck WHERE verwendung='" + row[4] + "'"
    add_data = "INSERT INTO zweck(verwendung) VALUES('" + row[4] + "')"
    fk4 = subTables(query, add_data)
    
    # id für fk_ID_iban = fk5
    query = "SELECT ID_iban FROM iban WHERE iban='" + row[5] + "' AND blz='" + row[6] + "'"
    add_data = "INSERT INTO iban(iban, blz) VALUES('" + row[5] + "', '" + row[6] + "')"
    fk5 = subTables(query, add_data)
    
    # id für fk_ID_schuldner = fk6
    query = "SELECT ID_schuldner FROM schuldner WHERE glaubiger_id='" + row[8] + "'"
    add_data = "INSERT INTO schuldner(glaubiger_id) VALUES('" + row[8] + "')"
    fk6 = subTables(query, add_data)
    
    # id für fk_ID_mandat = fk7
    query = "SELECT ID_mandat FROM mandatsreferenz WHERE mandatsreferenz='" + row[9] + "'"
    add_data = "INSERT INTO mandatsreferenz(mandatsreferenz) VALUES('" + row[9] + "')"
    fk7 = subTables(query, add_data)
    
    # id für fk_ID_kundenref = fk8
    query = "SELECT ID_kundenref FROM kundenreferenz WHERE kundenreferenz='" + row[10] + "'"
    add_data = "INSERT INTO kundenreferenz(kundenreferenz) VALUES('" + row[10] + "')"
    fk8 = subTables(query, add_data)
    
    # insert into giro
    query = ("SELECT ID_giro FROM giro WHERE buchungstag=%s AND wertstellung=%s AND betrag=%s AND fk_ID_buchungstext=%s AND fk_ID_betroffener=%s AND fk_ID_owner=%s AND fk_ID_zweck=%s AND fk_ID_iban=%s AND fk_ID_schuldner=%s AND fk_ID_mandat=%s AND fk_ID_kundenref=%s")
    add_dates = ("INSERT INTO giro "
                "(buchungstag, wertstellung, betrag, fk_ID_buchungstext, fk_ID_betroffener, fk_ID_owner, fk_ID_zweck, fk_ID_iban, fk_ID_schuldner, fk_ID_mandat, fk_ID_kundenref) "
                "VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
    rowdata =(date2date(row[0]), date2date(row[1]), float(strg2dec(row[7])),fk1, fk2, kto, fk4, fk5, fk6, fk7, fk8)
    try:
        cursor.execute(query, rowdata)
        wert, = cursor.fetchone()
        
        if len(ids) >= 5 and wert in ids[-5:]:
            raise TypeError
        satz = "...schon vorhanden"
        return wert, satz
    except TypeError:
        
        cursor.execute(add_dates, rowdata)
        wert = cursor.lastrowid
        ids.append(cursor.lastrowid)
        satz = "                    ...geschrieben..."
    sql.commit()
    
    return wert, satz


def depot(row):                       # depot.csv in Tabellen
    """
    "Bestand";          0
    "";                 1
    "ISIN / WKN";       2
    "Bezeichnung";      3
    "Kurs";             4
    "Gewinn / Verlust"; 5
    "";                 6
    "Einstandswert";    7
    "";                 8
    "Dev. Kurs";        9
    "Kurswert in Euro"; 10
    "Verfügbarkeit";    11
    """
    global ids, saldo, saldo_datum, wert, satz
    
    
    query = "SELECT ID_stocks FROM stocks WHERE isin='" + row[2] + "' AND einstandswert='" + strg2dec(row[7]) + "'"
    add_data = "INSERT INTO stocks(isin, name, einstandswert) VALUES('" + row[2] + "', '" + row[3] + "', '" + strg2dec(row[7]) + "')"
    stocks = subTables(query, add_data)
    # stocks = beschreibung
   
    
    # insert into depot
    # insert rest aus csv.zeile mit Prüfung ob schon vorhanden
    query = ("SELECT ID_depot FROM depot WHERE fk_ID_owner=%s AND fk_ID_stocks=%s AND bestand=%s AND datum=%s AND kurs_aktuell=%s")
    add_dates = ("INSERT INTO depot "
                "(fk_ID_owner, fk_ID_stocks, bestand, datum, kurs_aktuell) "
                "VALUES(%s, %s, %s, %s, %s)")
    rowdata =(kto, stocks, float(strg2dec(row[0])), date2date(saldo_datum), float(strg2dec(row[4])))
    # print(rowdata)
    try:
        cursor.execute(query, rowdata)
        wert, = cursor.fetchone()
        #if wert in ids[-5:]:
        #    raise TypeError
        satz = "...schon vorhanden"
        return wert, satz
    except TypeError:
        cursor.execute(add_dates, rowdata)
        wert =cursor.lastrowid
        ids.append(wert)
        satz = "                    ...geschrieben..."
    sql.commit()


def subTables(query, insert):         # ID-Abfragefunktion für vorhanden?
    try:
        cursor.execute(query)
        wert, = cursor.fetchone()
        beschreibung = wert
    except TypeError:
        cursor.execute(insert)
        beschreibung  = cursor.lastrowid
    return beschreibung


def makelog():                        # log.Tabelle in sql
    global ids, saldo, saldo_datum
    if ids == []:
        return
    
    # erster Eintrag
    infirst = min(ids)
    
    # letzter Eintrag
    inlast = max(ids)

    saldo_datum = date2date(saldo_datum)
    # print(saldo_datum, saldo)
    
    add_dates = ("INSERT INTO clag(datei, start, ende, fk_ID_owner, saldo, saldo_datum) VALUES(%s, %s, %s, %s, %s, %s)")
    data =(konto, infirst, inlast, owner(konto), saldo, saldo_datum)
    print("-- done: ", data)
    cursor.execute(add_dates, data)


def calcact():                        # Kontostand nach jeder Buchung berechnen
    vorquery_1 = "SELECT ID_log, saldo_datum, saldo, fk_ID_owner, start, ende FROM clag WHERE calc=0"
    cursor.execute(vorquery_1)
    # print(cursor)
    for daten in cursor:
        if daten[2] == 0:       # sollte Saldo = 0 sein, gleich den nächsten
            cursor.execute("UPDATE clag SET calc=1 WHERE ID_log=" + str(daten[0]))
            sql.commit()
            continue
        if daten[3] == 6:       # fürs Depot keine Stände ermitteln
            cursor.execute("UPDATE clag SET calc=1 WHERE ID_log=" + str(daten[0]))
            sql.commit()
            continue
        print()
        #print("Durchlauf i: ",i)
        id_log = daten[0]
        saldo_datum = daten[1]
        saldo = daten[2]
        owner = daten[3]
        start = daten[4]
        ende = daten[5]
        for elem in daten:          # nur für Testzwecke
            print(elem)

        if owner in [1,2]:
            getbetrag = "SELECT wertstellung, betrag FROM giro WHERE ID_giro ="
            setbetrag = "UPDATE giro SET stand=%s WHERE ID_giro=%s"
        elif owner in [3,4,5]:
            getbetrag = "SELECT wertstellung, betrag FROM kk WHERE ID_kk ="
            setbetrag = "UPDATE kk SET stand=%s WHERE ID_kk=%s"
            
        stand = saldo
        for id in range(start, ende+1, 1):
            
            cursor.execute(getbetrag + str(id))
            tempus = cursor.fetchall()
            wertstellung = tempus[0][0]
            betrag = tempus[0][1]
            #print("id= ", id, "wertstellung= ", wertstellung, "betrag= ", betrag)
            if wertstellung > saldo_datum:
                stand = betrag + stand
                print("wertstellung grösser, stand =", stand)
                cursor.execute(setbetrag, (stand, id))
                sql.commit()
                stand = saldo
                continue
            cursor.execute(setbetrag, (stand, id))
            stand = stand - betrag
            sql.commit()
        cursor.execute("UPDATE clag SET calc=1 WHERE ID_log=" + str(id_log))
        sql.commit()

# table oder txt für manuelle changes

def main():                           # Main
    sql = mysql.connector.connect(user = "root",    # Verbindung zur Datenbank
                                  password = "",
                                  host = "127.0.0.1",
                                  database = "konto")
    cursor = sql.cursor(buffered=True)
    dateien = showFiles()
    for konto in dateien:                 # main
        zeile = 0
        ids = []
        wert = 0
        with open("import_log.txt", "a") as file:

            with open(konto, "r", encoding="iso-8859-15") as data:
                reader = csv.reader(data, delimiter=";")
                kto = owner(konto)
                timestamp = datetime.now().strftime("%d.%m.%Y %H:%M:%S")
                print(timestamp, "...processing:...", konto)
                
                if kto in [3,4,5]:          # Kreditkarten
                    for row in reader:
                        zeile = zeile + 1
                        if row != []:
                            if row[0] =="Saldo:":
                                saldo = float(row[1][:-4])
                            if row[0] == "Datum:":
                                saldo_datum = row[1]
                        if len(row) <= 6:
                            continue
                        if row[1].isalpha():
                            continue
                        kktoTable(row)
                        file.write(str(timestamp) + " - " + konto + " von Zeile " + str(zeile) + " nach IndexNr " + str(wert) +" in Visa " + satz)
                        file.write("\n")
                    
                elif kto in [1,2]:          # Girokonten
                    for row in reader:
                        zeile = zeile + 1
                        if row != []:
                            if row[0].startswith("Kontostand"):
                                saldo = float(strg2dec(row[1][:-4]))
                                saldo_datum = row[0][-11:-1]
                        if len(row) <= 6:
                            continue
                        if row[1].isalpha():
                            continue
                        giroktoTable(row)
                        file.write(str(timestamp) + " - " + konto + " von Zeile " + str(zeile) + " nach IndexNr " + str(wert) +" in Giro " + satz)
                        file.write("\n")
                
                elif kto == 6:              # Depot
                    for row in reader: 
                        zeile += 1
                        if row != []:
                            if row[0].startswith("Depotgesamtwert in"):
                                saldo = float(strg2dec(row[1]))
                            if row[0].startswith("Depotgesamtwert per"):
                                saldo_datum = row[1][:10]
                        if len(row) <=1:
                            continue
                        if row[1] != "Stück":
                            continue
                        if row[1] == "Stück":
                            depot(row)
                        depot(row)
                        file.write(str(timestamp) + " - " + konto + " von Zeile " + str(zeile) + " nach IndexNr " + str(wert) +" in Depot " + satz)
                        file.write("\n")
                        
                makelog()
                calcact()
                """
                sql.commit()
                cursor.close()
                sql.close()"""
    sql.commit()
    cursor.close()
    sql.close()


if __name__ == '__main__':
    main()