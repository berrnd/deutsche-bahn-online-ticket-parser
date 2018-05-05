# deutsche-bahn-online-ticket-parser
A little PowerShell script to parse Deutsche Bahn Online-Ticket PDFs

## Why?
I needed this, because I had a whole lot of tickets in PDF form and I wanted to have
a list with the information for my Einkommensteuererklärung - unfortunately, Deutsche Bahn
does not provide any API or something for this - we call this Digitalisierung.

This script reads Deutsche Bahn Online-Ticket PDFs from a folder,
extracts various information and writes to them to the specified CSV file
(see the script for paths and so on).

## Example output
```
Auftrag: SXXXXQ
Summe: 8,80
Hinfahrt: Bobingen -> Egling
Rueckfahrt: Egling -> Bobingen
Datum: 11.10.2017
Ticket-Typ: Flexpreis (Hin- und Rückfahrt)
Reisende: 1, mit 1 BC50


Auftrag: NXXXXD
Summe: 4,40
Hinfahrt: Bobingen -> Egling
Datum: 12.10.2017
Ticket-Typ: Flexpreis (Einfache Fahrt)
Reisende: 1, mit 1 BC50
```

## Example CSV file
```
11.10.2017	Bahn Fahrkarte (Typ: Flexpreis Hin- und Rückfahrt, Reisende: 1 mit 1 BC50, Strecke: Bobingen -> Egling und Egling -> Bobingen, Auftragsnummer: SXXXXQ)	8,80
12.10.2017	Bahn Fahrkarte (Typ: Flexpreis Einfache Fahrt, Reisende: 1 mit 1 BC50, Strecke: Bobingen -> Egling, Auftragsnummer: NXXXXD)	4,40
```

## Credits
- PDF parsing: iTextSharp (https://github.com/itext/itextsharp)

## License
The MIT License (MIT)
