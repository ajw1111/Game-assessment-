# The Blue Vase

## The game

The page opens on a **玩法說明 · How to play** sheet: five illustrated cards
(St James's Palace, East India House, the Hall of Audience, the Qianlong
portrait, the Ch'eng-te scroll) explaining who you are, how the choices work,
the free-answer box, the voices, and the deadline. Press **開始遊戲 · Begin**
to start; the **玩法** button in the header reopens the sheet mid-game.

Each scene change is bridged by a **變場** transition: a dark curtain sweeps
across the stage carrying the new scene's name in English and Chinese, the
new illustration rises into place, and the text fades up underneath.

## Run the game

Double-click `start.command` (or run `python3 tts_server.py`) and open
<http://127.0.0.1:8123>.

### On an iPhone, iPad or Android phone

The server listens on every interface, so when it starts it prints the
address to use on the phone — something like:

```
The Blue Vase is available at http://0.0.0.0:8123
  on your wifi (iPhone, iPad): http://192.168.0.102:8123
```

Open that second line on the phone — Safari on iOS, Chrome on Android — with
the phone on the same wifi. The game is entirely self-contained — every plate is embedded in the
page — so the only thing the phone needs from the computer is the voice
server, and it finds it by itself because the page and the server share an
address.

The how-to-play sheet also shows the address by itself, once it has reached
the voice server: **在電話上開啟 · Open on your phone**. Tap it to copy.

If you keep a copy of `index.html` on the phone instead (AirDrop, Files, a
mail attachment), open it and put the computer's address into the
**語音伺服器 · Voice server** box on the how-to-play sheet; it is remembered
for next time. Without a voice server the phone falls back to its own
built-in voices, which is why the Cantonese lines go quiet there.

Two mobile rules are handled in the page: one audio element is reused for the
whole game and unlocked by the first tap (neither iOS nor Android will play a
fresh media element that no finger has touched), and the how-to-play sheet is
top-aligned with a sticky **開始遊戲 · Begin** button, so its beginning can
be scrolled to and the game can be started on a small screen.

Android uses the same Chromium engine as desktop Chrome, so no other change
is needed; the only difference is that Android phones have no Cantonese
voice installed by default, which is another reason to point them at the
voice server.

The server does two things:

- serves the game page, and
- renders every spoken line with the macOS system voices (`say`).

The system voices are the point: Chrome on macOS does not expose Chinese or
Cantonese voices to the Web Speech API, so the Cantonese lines (the Viceroy,
Punqua) were silent in the browser, and the English voices it does offer are
mostly women — Harlow and George III sounded like women.

With the server running, each character has a fixed system voice. No speaking
rate is imposed anywhere — every line keeps the voice's own natural pace:

| Character | Voice | Pitch |
| --- | --- | --- |
| Harlow | Daniel (en_GB) | 40 |
| George III | Grandpa (English (UK)) | 36 |
| Dundas | Fred | 40 |
| Poirot | Albert | 42 |
| Qianlong | Grandpa (Chinese (Taiwan)) | 36 |
| Imperial Commissioner | Reed (Chinese (Taiwan)) | 38 |
| Viceroy (廣東話) | Sinji (zh_HK) | 30 |
| Punqua (廣東話) | Sinji (zh_HK) | 28 |
| Comprador / Punqua (pidgin) | Grandpa (English (US)) | 40 |
| Boatswain | Fred | 42 |

Pitch is the `say` pitch base: lower is deeper. 50 is the system default
(around 165 Hz, which reads as a woman), 40 is about 100 Hz, which reads as a
middle-aged man — that is what keeps Harlow and George III from sounding
female. Loudness is set on the audio element in the page, because the
`[[vol]]` control makes the system engine fall back to a much slower
synthesis path.

A line written in Chinese is always spoken by a Chinese voice, whatever the
character, so nothing is read out letter by letter.

If the server cannot be reached the game falls back to the browser's own
speech engine, which is why the Cantonese lines are silent in that case.

The server port can be changed with `PORT=9000 python3 tts_server.py`; the
game also looks for `http://127.0.0.1:8124` and `http://127.0.0.1:3001`.

## AI dialogue

Requires an OpenAI API key. Set it in your shell, then start the server:

```sh
export OPENAI_API_KEY="your-api-key"
export OPENAI_MODEL="gpt-4o-mini" # optional
python3 tts_server.py
```

The API key stays on the server and is never sent to the browser. Do not
commit `.env`. Free-answer chat requires the server; opening `index.html`
directly with `file://` will not connect to the AI endpoint.

`server.js` is the older Node.js version of the same server, kept for
reference; it serves the game and the AI endpoint but not the voices.

## Imperial tent: the banquet scroll in relief

The tent scene carries the Qianlong portrait beside the 萬樹園賜宴圖
(*Banquet in the Garden of Ten Thousand Trees*, Castiglione and the court
painters, 1755). The **萬樹園賜宴圖 · 3D** button raises the scroll into
relief: the picture is cut into nine bands, each pushed back or forward in Z,
and the whole scroll tilts as the mouse moves across it. The button returns it
to the flat scroll. There is no external 3D model — it is all CSS.

## Voices

Every character has its own system voice (see the table above). macOS ships
only **one** Cantonese voice (Sinji), so the Viceroy and Punqua are separated
by a **voice shift** done in the server: the WAV's sample rate is rewritten, so
the Viceroy sounds lower and more deliberate (×0.84, ≈95 Hz) and Punqua
brighter and quicker (×1.17, ≈133 Hz). Two men, one voice.

Punqua speaks with one voice in both languages: his Cantonese (Sinji, pitch 34,
shift 1.17) measures **126.5 Hz**, and his pidgin English (Grandpa (English
(US)), pitch 48) measures **128.2 Hz** — the same man, 1.4 % apart. The
Viceroy sits well below him at 96.5 Hz, so the two Cantonese speakers are
never confused.

If you install a second Cantonese voice in macOS (System Settings →
Accessibility → Spoken Content → Chinese (Cantonese)), change `mv` for
`punYue` in `SIMVOICE` and drop its `shift`.

## A typed answer lands in the scene

The chat box does not just produce a reply; it produces a **plot beat**:

- The character in the room answers **in his own language and in his own
  manner**: the King in English with Dundas behind him, the Viceroy in
  Cantonese with Punqua interpreting, the Emperor in literary Mandarin with
  Father Poirot rendering it.
- The answer scene is followed by a **vignette that could happen where you
  are standing**. The twenty-three existing vignettes are tagged
  (`china`), and a new pool of London and sea vignettes has been written for
  the London scenes and the voyage: Lloyd's coffee-house and the broker who
  will not insure a man with no manifest; the copyist at the Horse Guards
  who knows which word never passes the Board; the timber-yard at Deptford
  where the embassy is fitted out; the surgeon's chest against scurvy; the
  tide at the Bogue. A London scene no longer produces a begging bowl.
- The vignette has consequences (silver, favour, face, health) and then hands
  you back to the main line.

So a sentence now goes: *your words → the court's answer → something that
happens because of it → back to the road.*

## Pictures

The pictures are still: the drifting clouds, gliding birds, flickering flames,
smoke, marching figures and flapping pennants have all been switched off, and
the plates no longer tilt under the mouse.

## A character never speaks in the wrong language

Every profile now says whether that character is a Chinese speaker
(`zhVoice`) and which Chinese voice is his own (`zhMv`):

| Character | English voice | Chinese voice |
| --- | --- | --- |
| Harlow | Daniel | — (he reads every line in English, `readsAny`) |
| The King, Dundas, Macartney, the boatswain, the comprador | their own | — |
| Father Poirot | Rocko (English UK) | Reed (Chinese Taiwan) |
| Poirot's aside (the gloss) | Rocko (English UK) | Reed (Chinese Taiwan), a little lower |
| The Emperor | — | Grandpa (Chinese Taiwan) |
| The Viceroy, Punqua | — | Sinji (zh_HK) |

So a Chinese line spoken by the King is not voiced by him at all — he does not
read Chinese, and the interpreter beside him carries it. And when **you type
Chinese for Harlow**, Harlow's voice stays English (Daniel) — it is the
priest or Punqua who repeats your words in their own language.

A single failed line no longer switches the server voices off for the rest
of the game: it falls back for that line only.

The pictures are still: the drifting clouds, gliding birds, flickering flames,
smoke, marching figures and flapping pennants have all been switched off, and
the plates no longer tilt under the mouse. The scene-change transition (the
curtain, the rise of the plate) is interface, not picture animation, and stays.

## The kowtow debate (scene IX)

The old one-line scene about the 禮部 has become an argument between three
voices, and it is argued from the record:

- the **Imperial Commissioner** states the rite as the Board of Rites holds it
  — 三跪九叩, three kneelings and nine prostrations, the court's rite for two
  hundred years;
- **Lord Macartney** refuses for his whole embassy: a British subject does not
  strike his head before a man who is not his sovereign;
- **Father Poirot** gives the inside view: the Jesuits have performed that
  rite before the throne since the Yongzheng emperor's audience of 1724, and
  the Jesuits have been asked to do it for the English;
- the player then answers, with **four** replies instead of three: the full
  kowtow, the one-knee bow of the Macartney precedent, the kneeling without
  prostration, and outright refusal to strike the head.

The scene carries its own source note, and the *References* list has a new
entry, **The Kowtow 叩頭**, citing: George Staunton, *An Authentic Account of
an Embassy from the King of Great Britain to the Emperor of China* (London,
1797), especially the account of the audience of 14 September 1793; the
instructions to Macartney (1792); the Jesuits' own reports (Archives of the
Society of Jesus, Rome); the Board of Rites' regulations and the Grand
Council's memorials (軍機處檔案); and James Laughton, 'The Ceremony of the
Kou-tou', *BSOAS* 54/2 (1991).

## The counting-house (scene II bis)

After the King, the story no longer jumps to Leadenhall Street. There is now a
bridge scene of a winter's waiting: the King's letter lies in a drawer at the
Horse Guards until the Board of Trade passes it in March, the Company owns
every ship that will lie off Canton and has no orders to carry you, and
Macartney tells you on the pavement that his instructions allow exactly one
kind of passenger — the King's business, and no man's private business. Three
ways of getting passage out of that, all of which lead to East India House.

## Imperial audience

The audience (*The Audience · First Words*) now offers **five** replies: the
thanks in English, the bare name, the impatience for the King's letter to be
read, the telescope offered to the Emperor of the sky, and silence — waiting
for the Emperor to speak first.

## The chat box is part of the game

The box under the choices is not a side feature — it is another way to act.

- It is now offered in **every scene that has replies**, not only the ones
  marked for free answers.
- Type a sentence and the game looks for the reply it is closest to
  (English keywords, Chinese two-character matches). If it finds one, **that
  branch is taken** — the same silver cost, the same change in favour and
  face, the same next scene — and your own line is said aloud in Harlow's
  voice first.
- In the scripted exchanges (the King, the Viceroy, the tent) your words
  become Harlow's line in the dialogue, so the interpreter translates what
  you actually said.
- If your sentence matches none of the replies, the court answers you in
  character instead: the AI endpoint is used when it can be reached, and
  otherwise the game reads the answer itself (the manner is judged from the
  words) and replies in character.

So a click and a sentence end in the same place — the sentence is simply the
version of the click you would have made in your own words.

## Macartney

Scene 8 (*Loading at the Anchorage*) brings **Lord Macartney** onto the quay:
he speaks to Harlow in the anchorage, his squadron lies alongside, and the
player may bow to him and ask him to carry the petition. That opens a scene of
its own — *XIV bis. The Ambassador's Word* — where Macartney signs the
petition, his secretary tells you to speak little, and you choose how far to
lean on the ambassador's name. If you did, his name is read out at the
audience and the verdict counts it (+6).

## Plates

The prologue is now a London street market rather than the Canton factories:
*Cries of London — a pedlar at the stall*, R. Ackermann, 1796 (hand-coloured
aquatint after Thomas Rowlandson), Yale Center for British Art /
Wikimedia Commons, public domain. The scene itself is set in January 1792.
