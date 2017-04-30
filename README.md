# markdown-parser

Dieser Markdown-Parser verwendet Regular Expressions um Markdown-Blöcke mit vordefinierter Syntax  zu parsen und zu kompilieren.

Der finale Code (in assets/js/markdown-parser.js) ist nur 970 Bytes groß und besteht aus lediglich 30 LOC.


# Live Demo...
... gibt es [hier auf GitHub.com](https://shigawire.github.io/markdown-parser/app/index.html)

## Programmierung
Der Quellcode wurde in Coffescript geschrieben, die Coffe-Dateien liegen in /app/scripts/**.coffee.

Durch den gulp-Task ```gulp coffee``` können diese Coffeescript-Dateien in das finale Javascript-Format transpiliert werden.
In diesem Prozess werden Kommentare entfernt - kommentiert sind also nur die Coffescript-Dateien.
Im Zuge des transpiling werden die letztlichen Javascript-Dateien nach /assets/js/**.js kopiert.

Die App selber kann einfach im Browser gestartet werden:
Einfach die app/index.html aufrufen.

## Markdown Parser

Zunächst soll erläutert werden weshalb der implentierte Ansatz zum
Parsen, bzw. Kompilieren von Markdown-Code der in der Challenge erläuterten Markdown-Regeln gewählt wird.

### Parsens von eigenen Sprachen/Grammatiken
Um die vorliegende Challenge zu lösen bieten sich verschiedene Möglichkeiten an.
Zunächst jedoch grundlegendes zu Markdown und der Untermenge an tatsächlich zu parsenden Funktionalitäten.

Markdown ist recht einfach gestaltet und ähnelt dem Zielformat (HTML) lexikografisch in weiten Teilen, 
so ist die Markdown-Notation eines in **fett** geschriebenen Textes 
```
**Text**
```
ähnlich der Syntax der korrespondierenden HTML-Notation: 
```
<strong>Text</strong>
```

In Markdown definieren zwei Sternchen den Beginn des Fett-Textes, zwei weitere Sternchen schließen diesen ab.
HTML als XML-basierte sprache erfordert zu jedem geöffneten Tag auch einen korrespondierenden schließenden Tag, also lassen sich die ersten beiden Sternchen ```**```durch ein ```<strong>```, und die schließenden Sternchen durch ein ```</strong>``` ersetzen, um problemfrei valides HTML-Markup aus gegebenem Markdown-Input zu erhalten.

### Methode 1: Markdown-Code zeilenweise "durchlaufen"
Eine recht primitive Möglichkeit ein Markdown-Dokument zu parsen/kompilieren wäre den MD-Code zeilenweise 
zu durchlaufen und nach Spezifikationen der Markdown-Sprache zu suchen und nachfolgende Textstellen in passende HTML-Tags einzufügen.

Alleine aus dem Grund, dass in Markdown mehrzeilige Elemente wie bspw. Zitate verwendent werden können schließen Methode 1 größtenteils aus, ohne heuristisch die nachfolgenden Zeilen nach möglichen Fortsetzungen des aktuellen Markdown-Objekts durchsuchen zu müssen.

### Methode 2: Markdown-Code charakterweise "durchlaufen"
Möglichkeit 2 zum Parsen/Kompilieren des Markdown-Codes besteht darin, jedes Zeichen des vermeintlichen Markdown-Input zu durchlaufen. Sobald ein Markdown-Keyword (bspw. ```#``` für Überschriften) gefunden wurde, ist der nachfolgende Text vermeintlich in ein HTML-Äquivalent zu schreiben.

Als nachteilig erweist sich hier, dass bis zu unbestimmten zukünftigen Stellen im Markdown-Quellcode nach einem Abschluss des aktuellen Markdown-Objekts gesucht werden muss ("lookahead"). So ist es einfach bspw. die Funktionalität für Fettschrift (```**```) zu erkennen, es müssen jedoch im Zweifel viele Folgezeichen nach der selben, schließenden Zeichenkette (ebenfalls  ```**```) durchsucht werden.
Außerdem ist es mit dieser Methode nicht ohne weiteres möglich, abgeschlossene Markdown-Objekte zu identifizieren, die keine eindeutige Schlusssequenz haben, so die mehrzeilige Kommentarfunktion, deren einzige Schlusssequenz ein doppelter Zeilenumbruch ist:
```
> Kommentar
Zeile 2

Abschluss.
```
wird zu
> Kommentar
Zeile 2

Abschluss.

übersetzt.
Es sind also je nach vorliegender Markdown-Syntax unterschiedliche Schlussequenzen zu definieren. Erschwerend kommt hinzu, dass doppelte Zeilenumbrüche nicht nur Schlussequenzen für einzelne Markdown-Objekte, sondern auch als Zeilenumbruch im zu kompilierenden Text interpretiert werden müssen.


#### Möglichkeit 3: Gleichzeitiges Parsen und Kompilieren mittels Regular Expressions

Eine elegante und dem Arbeitsaufwand nach überschaubare Möglichkeit zum Parsen und Kompilieren der vorbezeichneten Markdown-Syntax ist die Verwendung von Regular Expressions.

Um den Umgang mit Regular Expressions zu lernen, habe ich mich für die Implementierung des Markdown-Parsers mit RegEx entschieden.

Durch diesen Ansatz ist die Codebasis des Markdown-Parser äußerst klein, der größte Teil der Arbeit befindet sich in ```markdown-parser.coffee```.

Nachfolgend sollen alle Regular Expressions erläutert werden, die zum Parsen des Markdown-Codes verwendet werden.



#### Fett-Text (\*\*Text\*\*)

Angewandter Regex: 
```
(\*\*)([\s\S]+?)\1
```
[Regex-Test https://regex101.com/r/ALFQxg/1](https://regex101.com/r/ALFQxg/1)

Durch ```\*\*``` wird der String ```**``` gematcht. Dieser Block befindet sich in einer eigenen Gruppe, der mit Hilfe des ```\1```-Identifiers am Ende der in Frage kommenden Zeichenkette erneut gematcht werden kann.
Letztendlich werden also drei Gruppen erstellt:
1. ```**```
2. Text
3. Referenz auf Gruppe 1, also erneut ```**```

Die zweite Gruppe ```([\s\S]+?)``` matcht Zeichenketten inkl. Whitespaces und Zeilenumbrüche (`\s` = 'any whitespace character', `\S` = 'any non-whitespace character') von beliebiger Länge, jedoch durch den so genannten **lazy quantifier** `+?` auf so kurzer Länge wie möglich - bei dem zweiten Vorkommnis von `**` schließt der RegExp ab.

Dadurch lässt sich dieser Regex gut benutzen um Fett-Text zu extrahieren der zwischen zwei Sternchen angegeben ist.

Da hier im Grunde **auch** der RegEx-Matcher für kursive Texte matchen *könnte*, muss der Regex-Matcher für Fett-Text zuerst auf den Markdown-Code angewendet werden. Bei umgekehrter Reihenfolge vermutet der RegExp für kursiven Text, das zusätzliche Sternchen gehöre zum Text.

##### Kursiv-Text (\*Text\*)

Angewandter Regex: 
```
(\*)([\s\S]+?)\1
```
[Regex-Test https://regex101.com/r/3J3M7t/1](https://regex101.com/r/3J3M7t/1)

Analog zu Regex für Fett-Texte.


#### H1 Überschriften
Angewandter Regex: 
```
^#(.*)
```

[Regex-Test https://regex101.com/r/8EdfWz/1](https://regex101.com/r/8EdfWz/1)

Mit Hilfe des Zuirkumflex-Characters ^ wird sichergestellt, dass der Regex lediglich zu Beginn einer Zeile matcht.
Dies schließt aus, dass eine Raute mitten in einer Zeile in Überschriften matcht.
Durch die Raute wird der Anfang einer Überschrift in Markdown definiert. Mit Hilfe des des greedy-Quantifiers ```.*``` werden so viele Charaktere wie möglich gematcht, in diesem Fall bis zum Zeilenende.

#### H2 Überschriften
Angewandter Regex: 
```
^##(.*)
```

Analog zum Regex für H1-Überschriften.

#### Zitate (> Text)

Zitate sind in Markdown komplexer zu handhaben, da es kein Terminal-Character gibt das die Definition eines Zitats in Markdown eindeutig beendet. Ein Zeilenende bedeutet zudem in Markdown nicht immer das Ende eines Zitats.

Durch die gesteigerte Komplexität zum richtigen Erkennen von Zitaten werden mehrere Regular Expression-Regeln verwendet:

```
^>([\s\S]*?\n|.*?)$
```
[Regex-Test https://regex101.com/r/xypqHe/2](https://regex101.com/r/xypqHe/2)

Das Zirkumflex stellt erneut sicher, dass der zu matchende Text unmittelbar mit der Zeile beginnt.
Durch den >-Charakter wird der Beginn eines Zitats definiert.
Die Regex-Gruppe (definiert durch runde Klammern) wird den zu matchenden Text definieren: Mit \s und \S können sowohl whitespace, als auch non-whitespace Character gematcht werden (also *alles*).
Der Lazy Quantifier ```*?``` sorgt erneut dafür, dass aufeinanderfolgende Zitate als einzelne erkannt werden.

mit dem restlichen Teil des Regex ```\n|.*``` wird dem Regex-Parser die Möglichkeit gegeben entweder ein Zeilenende oder einen beliebigen Charakter als Zitat-Ende zu definieren. Dies ermöglicht sowohl einzeilige, als auch mehrzeilige Zitate zu matchen. Durch das Terminalsymbol ```$``` wird sichergestellt, dass die letzte Regex-Regel auf das jeweilige Zeilenende angewandt wird.

#### Listenelemente (* Text)

Das matchen von Listenelementen ist hier zweistufig implementiert.
Zunächst wird jedes Vorkommnis aus Sternchen, Leerzeichen und Text (also ```* Text```) von einem HTML ```<li>```-Tag umschlossen: ```<li>Text</li>```.
Dazu wird der folgenden Regex verwendet:

```^\*\s(.*)```

[Regex-Test https://regex101.com/r/ALFQxg/2](https://regex101.com/r/ALFQxg/2)

Erneut findet hier das Zirkumflex Anwendung, um zu verhindern dass valide Textelemente die ein Sternchen enthalten fälschlicherweise als Listenelement erkannt werden. Ein Listenelement muss demnach mit der Zeile starten.

Die Teile ```\* \s``` matchen ein Sternchen in Kombination mit whitespace, der eigentliche Text wird mit der ```(.*)```-Kombination erkannt.

Mit Hilfe dieses Regex sind sodann alle Listelemente durch ```<li>```-Tags ersetzt, was den folgenden invaliden HTML Code ergibt:
```
<li>Element 1</li>
<li>Element 2</li>
<li>Element 3</li>
```
Um diese Tags nun mit einem validen HTML ```<ul>``` Tag zu umschließen, wird dieser Regex genutzt:

```(<li>.*<\/li>\n)+```

[Regex-Test https://regex101.com/r/ALFQxg/3](https://regex101.com/r/ALFQxg/3)

Die vollständige, zu matchende Gruppe besteht aus einem beginnenden ```<li>```-Tag, ist im zweifel mehrzeilig und endet irgendwo mit einem schließenden ```</li>```-Tag.

### Möglichkeit 4: Voll ausgestatteter Parser mit Lexer, Parser und Compiler

Programmiersprachen werden üblicherweise von Parsern/Kompilern, bestehend aus Lexer, Parser und Compiler in maschinenlesbaren Code übersetzt.

Nachteilig ist hier, dass quasi jede beliebige Zeichenkette in Markdown eine **valide Syntax** ergibt.
Während sämtliche Programmier- und Skriptsrachen wie Java und JavaScript, oder sogar HTML eine stark strukturierte Syntax besitzen, von der absolut nicht abgewichen werden darf (sonst gibt es Übersetzungsfehler. Bei HTML versucht der Browser noch heuristisch, kaputte Syntax zu "reparieren").
In Markdown ist aber fast alles erlaubt, so kann gelten die Terminator-Symbole, die eigentlich die Markdown-Syntax definieren zu dem gültigen Eingabealphabet für Texte:
```
*Ein kursiver Text in dem nonchalant ein Sternchen * verwendet wird.*
```
*Ein kursiver Text in dem nonchalant ein Sternchen * verwendet wird.*

Markdown ist demnach völlig unstrukturiert, der klassische Ansatz mit abstrakten Syntaxbäumen ist außerdem sehr viel Arbeit.
