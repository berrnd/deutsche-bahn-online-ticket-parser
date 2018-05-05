<#

This script reads Deutsche Bahn Online-Ticket PDFs from a folder (see below),
extracts various information and writes to them to the specified CSV file

Author: Bernd Bestel (https://berrnd.de ; bernd@berrnd.de)
Last updated: 2018-05-05
Licence: MIT

#>

$FOLDER = "B:\Dokumente\Quittungen"
$FILTER = "2017*Bahn Fahrkarte*.pdf"
$OUTPUTFILE = "Fahrten.csv"


Add-Type -Path itextsharp.dll

ForEach ($file in Get-ChildItem -Path $FOLDER -Recurse -Filter $FILTER | Sort-Object Name)
{
	$auftrag = $null
	$preis = $null
	$hinfahrt = $null
	$rueckfahrt = $null
	$datum = $null
	$ticketType = $null
	$reisende = $null

	$pdfReader = New-Object iTextSharp.Text.Pdf.PdfReader -ArgumentList $file.FullName
	$pageLines = [iTextSharp.Text.Pdf.Parser.PdfTextExtractor]::GetTextFromPage($pdfReader, 1).Split([Environment]::NewLine)
	$lineIndex = -1
	foreach ($line in $pageLines)
	{
		$lineIndex++

		if ($auftrag -eq $null -and $line.StartsWith("Auftragsnummer"))
		{
			$auftrag = $line.Split(" ")[1]
		}
		if ($preis -eq $null -and $line.StartsWith("Summe"))
		{
			$preis = $line.Split(" ")[1]
			$preis = $preis.Remove($preis.Length - 1) #Remove Euro symbol at the end
		}
		if ($hinfahrt -eq $null -and $line.StartsWith("Hinfahrt"))
		{
			$lineParts = $line.Split(" ")
			$hinfahrt = $lineParts[1] + " -> " + $lineParts[3]
		}
		if ($rueckfahrt -eq $null -and $line.Split(" ")[0].Contains("ckfahrt")) #Comparison to "Rückfahrt" does not work however
		{
			$lineParts = $line.Split(" ")
			$rueckfahrt = $lineParts[1] + " -> " + $lineParts[3]
		}
		if ($datum -eq $null -and $line.Split(":")[0].Contains("ltig ab")) #Comparison to "Gültig ab" does not work however
		{
			$datum = $line.Split(" ")[2]
		}
		if ($ticketType -eq $null -and $line.Split(":")[0].Contains("ltigkeit")) #Comparison to "Gültigkeit" does not work however
		{
			$ticketType = $pageLines[$lineIndex + 1]
		}
		if ($reisende -eq $null -and $line.StartsWith("Erw:"))
		{
			$reisende = $line.Replace("Erw: ", "")
		}
	}
	$pdfReader.Close()

	Write-Host "Auftrag: $auftrag"
	Write-Host "Preis: $preis"
	Write-Host "Hinfahrt: $hinfahrt"
	if ($rueckfahrt -ne $null)
 	{
		Write-Host "Rueckfahrt: $rueckfahrt"
	}
	Write-Host "Datum: $datum"
	Write-Host "Ticket-Typ: $ticketType"
	Write-Host "Reisende: $reisende"
	Write-Host
	Write-Host

	$strecke = $hinfahrt
	if ($rueckfahrt -ne $null)
 	{
		$strecke += " und $rueckfahrt"
	}
	$bezeichnung = "Bahn Fahrkarte (Typ: $ticketType, Reisende: $reisende, Strecke: $strecke, Auftragsnummer: $auftrag)"
	$csvLine = "$datum	$bezeichnung	$preis"
	$csvLine | Out-File -Append $OUTPUTFILE
}

Write-Host "Press any key to exit..."
Read-Host
