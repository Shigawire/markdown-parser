# markdown-parser

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

#### Methode 1: Markdown-Code zeilenweise "durchlaufen"
Eine recht primitive Möglichkeit ein Markdown-Dokument zu parsen/kompilieren wäre den MD-Code zeilenweise 
zu durchlaufen und nach Spezifikationen der Markdown-Sprache zu suchen und nachfolgende Textstellen in passende HTML-Tags einzufügen.

Alleine aus dem Grund, dass in Markdown mehrzeilige Elemente wie bspw. Zitate verwendent werden können schließen Methode 1 größtenteils aus, ohne heuristisch die nachfolgenden Zeilen nach möglichen Fortsetzungen des aktuellen Markdown-Objekts durchsuchen zu müssen.

#### Methode 2: Markdown-Code charakterweise "durchlaufen"
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

https://medium.com/@daffl/beyond-regex-writing-a-parser-in-javascript-8c9ed10576a6

#### Möglichkeit 4: Voll ausgestatteter Parser mit Lexer, Parser und Compiler

Programmiersprachen werden üblicherweise von Parsern/Kompilern, bestehend aus Lexer, Parser und Compiler in maschinenlesbaren Code übersetzt.

Nachteilig ist hier, dass quasi jede beliebige Zeichenkette in Markdown eine **valide Syntax** ergibt.
Während sämtliche Programmier- und Skriptsrachen wie Java und JavaScript, oder sogar HTML eine stark strukturierte Syntax besitzen, von der absolut nicht abgewichen werden darf (sonst gibt es Übersetzungsfehler. Bei HTML versucht der Browser noch heuristisch, kaputte Syntax zu "reparieren").
In Markdown ist aber fast alles erlaubt, so kann gelten die Terminator-Symbole, die eigentlich die Markdown-Syntax definieren zu dem gültigen Eingabealphabet für Texte:
```
*Ein kursiver Text in dem nonchalant ein Sternchen * verwendet wird.*
```
*Ein kursiver Text in dem nonchalant ein Sternchen * verwendet wird.*

Markdown ist demnach völlig unstrukturiert, der klassische Ansatz mit abstrakten Syntaxbäumen ist außerdem scheiß viel Aufwand.

Informationen:
http://lisperator.net/pltut/parser/


http://stackoverflow.com/questions/9452584/building-a-parser-part-i





# Test-Markdown
# Überschrift H1

## Überschrift H2

**Fettschrift einzeilig**

**Fettschrift
mehr-
zeilig**

*Kursiv einzeilig*

*Kursiv
mehr-
zeilig*

* Listenelement 1
* Listenelement 2
* Listenelement 3

* Listenelement a

> Zitat einzeilig

> Zitat
mehr-
zeilig

# Markdown Test
## Unterüberschrift

**Fetter Text**

**Fetter Text über mehrere Zeilen**

*Kursiver Text*

*Kursiver Text über mehrere Zeilen*

**Fetter und *kursiver* Text**

*Kursiver und **fetter** Text*

> einzeiliger Kommentar

> Mehrzeiliger
Kommentar

> Kommentar mit *kursivem* Text

> Kommentar mit **fettem** Text

* Listenelement 1
* Listenelement 2
* Listenelement 3

Space

* Listenelement 1
