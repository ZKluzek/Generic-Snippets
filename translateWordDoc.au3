#include <Excel.au3>
#include <Word.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>



; file names
Global $eFileName = "\translateKey.xlsx"

; Excel, open and read translation key

Global $oExcel = _Excel_Open()
Global $eFilePath = @ScriptDir & $eFileName
Global $eWorkbook = _Excel_BookOpen ( $oExcel, $efilePath)


Global $translationKeys = _Excel_RangeRead ($eWorkbook)
_Excel_Close ($oExcel)


; Word, open, read and replace sentences
Global $oWord = _Word_Create()
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Error", "Could not open word." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

Global $wFilePath = FileOpenDialog("select word doc", @ScriptDir, "docx files (*.docx*)")
Global $wFileName = StringSplit($wFilePath, "\")[Ubound(StringSplit($wFilePath, "\")) - 1]
Global $oWordDoc = _Word_DocOpen($oWord, $wFilePath)
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Error", "Could not open document." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

Global $engArray[Ubound($translationKeys, 1)]
Global $spArray[Ubound($translationKeys, 1)]

; Get translations of each language
for $i = 0 To 1 ;Column
    for $j = 0 To Ubound($translationKeys, 1) - 1 ;Row
        if $i == 0 Then
            if $j Not = 0 Then ;Ignore first entry, as it should be set to 'English'
                $engArray[$j] = $translationKeys[$j][$i]
            EndIf
        Else
            If $j Not = 0 Then
                $spArray[$j] = $translationKeys[$j][$i]
            EndIf
        EndIf
    Next
Next
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Error", "Could not save file." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

; Find and replace english text with spanish
for $i = 0 To Ubound($engArray) -1
    local $sFindText = $engArray[$i]
    local $sReplacementText = $spArray[$i]
    local $replaced = _Word_DocFindReplace($oWordDoc, $sFindText, $sReplacementText, $wdReplaceOne)
Next 


$oWord.ActiveDocument.SaveAs(@ScriptDir & "\" & StringSplit($wFileName, ".")[1] & " (Spanish).docx")
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Error", "Could not save file." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

;~ MsgBox($MB_OK, "asdf", @ScriptDir & StringSplit($wFileName, ".")[1] & "New.docx")


;_Word_DocClose($oWordDoc)
;_Word_Quit($oWord)



