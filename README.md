# Johann van Staal

Music composed and performed as code, using [Sonic Pi](https://sonic-pi.net).
These tracks explore what happens when the old world's dead languages meet
the dancefloor — **Crypt House**: Latin voices, bells, crows, rain and
sirens over trance, house and witch-house grooves.

Each track is a single, self-contained `.rb` file. It plays the entire
arrangement from the first spoken word to the final note and stops by
itself.

This repository contains **"Concordia/Discordia"**: after
three releases about how republics die, this one asks what a single
person can do against it. It is Song 1 of a planned pair — *die Abwehr*,
the defence. Its answer is deliberately small: watch, act, judge well,
resist the beginnings.

## Tracks

- **`concordia.rb` — "Concordia/Discordia"** — Witch House, 78 BPM,
  D minor, ~6:45. A slow, heavy piece built on a deliberately stable
  harmonic order (Dm–Bb–F–C, two bars each): the political order is not
  narrated through chord changes but through what the voices *inside*
  that order do. Short Latin formulas act almost as characters —
  *Concordia*, *Discordia*, *Panem et circenses*, and the recurring
  warning *Principiis obstate* (resist the beginnings), which appears
  before anything has happened (bars 2–3, forward and reversed — a
  prophecy before its context) and then runs the whole arc: distant,
  intelligible, damaged by Discordia, buried under comfort, almost
  swallowed by sleep, and finally — after the awakening — clear, human
  and unprocessed. The Concordia theme enacts its own name: single
  notes become one voice, one voice is answered by a second, the two
  are torn apart in DISCORDIA (the answering voice starts hitting notes
  that belong to no shared world), and the theme vanishes entirely under
  PANEM ET CIRCENSES — a counter-motif that is deliberately *pleasant*:
  the danger does not sound like danger, it sounds like comfort. Under
  everything lives a second harmonic world, the Abyss — D with a minor
  second (Eb) and a tritone (Ab) — which opens fully as the comfort
  turns to sleep, while a murmuring ghost-congregation assembles voice
  by voice. Bar 96 is the rupture: the mumbling stops, the dissonances
  vanish, and out of the emptiness step three dry, human words —
  *Vigilando. Agendo. Bene consulendo.* (by watching, by acting, by
  judging well — Cato's formula in Sallust) — followed by their
  consequence, *Principiis obstate*, and the full theme in real
  two-voice cooperation. The ending inverts Fragor Noctis: the same
  descent A–G–F–E, two full bars in which the resolution is withheld —
  and then, at bar 123, the piece chooses D. Not victory: decision.
  Over the fading tonic, Sallust himself speaks the only complete
  quotation of the track — *Falso queritur de natura sua genus
  humanum… Sed dux atque imperator vitae mortalium animus est* — "the
  human race complains wrongly about its nature… but the leader and
  commander of life is the mind" — forward, and simultaneously as a
  reversed twin that ends on a backwards *Falso*: the complaint
  dissolves in reverse while *animus est* remains the last word.

## Requirements

- **Sonic Pi v4 or later** — free, available for macOS, Windows and Linux
  at [sonic-pi.net](https://sonic-pi.net). No other software is needed.
- The **sample files** (`*.wav`) from this repository, stored on your
  local machine in one folder.

## Setup

1. **Clone or download this repository** to your computer.

2. **Keep the track's `.wav` files together in one local folder.**
   The track loads them from disk at startup. Loading is tolerant: a
   missing file is logged as `NOCH NICHT DA` and its slot is simply
   skipped when the bar comes (`VOX FEHLT`), so the piece plays even
   with an incomplete sample set.

   > ⚠️ If you store the folder in a cloud-synced location (iCloud
   > Drive, OneDrive, Dropbox), make sure the files are *actually
   > downloaded* and not just cloud placeholders. On macOS: right-click
   > the folder → *"Keep Downloaded"*. A track that hangs silently at
   > startup is almost always a sample file that the cloud has offloaded.

3. **Set your local path.** Near the top of the file you will find:

   ```ruby
   define :pfad do |name|
     "... insert local path name here ..." + name + ".wav"
   end
   ```

   Replace the placeholder with the absolute path to your sample folder,
   **written as a single line** and **ending with a trailing `/`**. On
   startup the log prints a `PFAD-TEST:` line with the full path the
   track has built — if every file is reported missing, compare that
   line character by character with the real location of your folder.

4. **Run the track as a file — do not paste it into a buffer.**
   Sonic Pi's editor is limited to roughly 10,000 characters per buffer;
   this track is far beyond that size. Put a single line into an empty
   buffer and press *Run*:

   ```ruby
   run_file "/path/to/your/folder/concordia.rb"
   ```

   Press *Stop* to end playback at any time — and always press *Stop*
   before re-running, otherwise loops from the previous run keep going
   and you hear doubled material.

## Samples

```
vocal_non_nobis_solum.wav       vocal_concordia.wav
vocal_discordia.wav             vocal_panem_et_circenses.wav
vocal_vigilando.wav             vocal_agendo.wav
vocal_bene_consulendo.wav       vocal_obstate.wav
vocal_principiis_obstate.wav    vocal_falso_queritur.wav
effect_mumbling.wav             effect_ominous_drone.wav
effect_gathering_storm.wav      effect_craw.wav
```

Voice recordings by Johann van Staal — including `effect_mumbling.wav`,
the murmuring ghost-congregation, which is the artist's own recording.
The remaining ambience samples (drone, storm, crow) come from free
sample libraries; see their respective sources for license details.

For the first time on this label, everything is spoken in **classical
pronunciation** throughout (c = k, v = w, ae = ai): *kirkenses*,
*wigilando*, *kweritur*.

## The Latin texts

All spoken samples are transcribed in **`concordia_texte.txt`**, with
translations, sources and their position in the track. The voices are
short formulas — characters rather than sentences:

- **Ovid, *Remedia Amoris* 91** — *Principiis obsta; sero medicina
  paratur.* The track's recurring warning, pluralised by Johann van
  Staal to address the many: *Principiis obstate* — resist the
  beginnings.
- **Cicero, *De officiis* I,22** — *Non nobis solum nati sumus*: we are
  not born for ourselves alone. The formula that frames the piece
  (bars 10 and 114).
- **Sallust, *Bellum Iugurthinum* 10,6** — *Concordia parvae res
  crescunt, discordia maximae dilabuntur*: through concord small things
  grow, through discord the greatest fall apart. The sentence's two
  halves appear as the track's two opposing characters.
- **Juvenal, *Satires* 10** — *panem et circenses*: bread and circuses,
  presented deliberately as comfort rather than menace (bars 66–94).
- **Sallust, *Catilina* 52 (Cato's speech)** — *vigilando, agendo, bene
  consulendo prospera omnia cedunt*: by watching, by acting, by judging
  well, everything succeeds. The three gerunds of the awakening
  (bars 96/100/104).
- **Sallust, *Bellum Iugurthinum* 1** — *Falso queritur de natura sua
  genus humanum… Sed dux atque imperator vitae mortalium animus est.*
  The only complete quotation, spoken over the ending (bar 119).

## How the track works

The architecture is the one shared by all releases: a master clock
(`live_loop :puls`) counts bars into a shared counter, and every other
loop reads that counter to decide what to play.

Three long-range devices are specific to this track. First, the
**ghost-to-human arc**: every vocal formula is introduced as an
apparition — filtered, reverberant, shadowed by reversed copies — and
returns after bar 96 progressively drier, closer and more intelligible;
the awakening is audible as a change in *how* the words sound before it
is a change in *what* they say. Second, the **Abyss**: beneath the
stable Dm–Bb–F–C order lies a second, almost subliminal harmonic world
of D, Eb and Ab (minor second and tritone against the tonic), whose
opening and closing tracks the narrative — its sudden reduction to a
bare D at bar 96 matters as much as the word *Vigilando* itself. Third,
the **mumbling congregation**: scattered single apparitions of an
indistinct murmuring voice accumulate during SOMNUS into a four-voice
forward-and-reversed crowd — the only fully developed ghost choir of
the track — which falls silent at the exact moment one single word
becomes intelligible.

Across the releases, one answer: the machine of *Fragor Noctis (Ferrum
et Ordo Mix)* barked **Obedite** — obey. The citizens of this track
answer **Obstate** — resist. Two imperatives, almost the same word,
pointing in opposite directions. And where Fragor Noctis ended on an
unresolved E, refusing its tonic forever, Concordia ends on D: not
because the threat is gone, but because after two bars in which the
resolution is withheld, someone chooses it.

## Troubleshooting

- **Every file is reported `NOCH NICHT DA`** — the path definition does
  not point at your sample folder. Compare the `PFAD-TEST:` log line
  with the real path.
- **A voice is loaded but never plays** — check the log: the track
  prints a `VOX SPIELT:` line for every vocal event. If the line
  appears but you hear nothing, Sonic Pi is serving an old cached
  version of the sample: run `sample_free_all` once in an empty buffer
  (or restart Sonic Pi), then start the track again.
- **Samples or melodies sound doubled** — loops from a previous run are
  still alive. Press *Stop*, then *Run*.
- **The editor refuses to accept new lines** — you have hit the ~10,000
  character buffer limit. Edit the `.rb` file in an external editor and
  use `run_file` as described above.
