# ============================================================
# Concordia/Discordia -- Johann van Staal
# Witch House | D minor | 78 BPM | 128 Takte
#
# 0-15 VIGILIA | 16-31 NON NOBIS SOLUM | 32-47 CONCORDIA
# 48-63 DISCORDIA | 64-79 PANEM ET CIRCENSES | 80-95 SOMNUS
# 96-111 VIGILANDO / AGENDO | 112-127 NON NOBIS SOLUM / DECISIO
#
# Die Abwehr. Nicht der Zusammenbruch steht im Mittelpunkt,
# sondern was der Einzelne gegen ihn tun kann.
#
# Die musikalische Idee folgt Sallust: CONCORDIA laesst aus
# einer einzelnen Stimme mehrere werden, DISCORDIA zerlegt
# dieselben Stimmen wieder. PANEM ET CIRCENSES ist die
# Versuchung, die angenehm und hypnotisch klingt.
# PRINCIPIIS OBSTATE laeuft als Warnung durch den ganzen
# Track. Die Antwort ist kein Heldentum, sondern Handlung: 
# VIGILANDO. AGENDO. BENE CONSULENDO.
#
# Run:  run_file ".../R07_Concordia_Discordia/concordia.rb"
# (Stop vor Run!)
# ============================================================

set_volume! 1
set :takt, 0
set_sched_ahead_time! 1
use_bpm 78
use_random_seed 29

define :pfad do |name|
  "... insert local path name here ..." + name + ".wav"
end

puts "PFAD-TEST: " + pfad("vocal_non_nobis_solum").inspect

optionale = ["effect_ominous_drone", "effect_gathering_storm",
             "effect_mumbling", "effect_craw",
             "vocal_obstate", "vocal_principiis_obstate",
             "vocal_falso_queritur",
             "vocal_non_nobis_solum", "vocal_concordia",
             "vocal_discordia", "vocal_panem_et_circenses",
             "vocal_vigilando", "vocal_agendo",
             "vocal_bene_consulendo"]

optionale.each do |n|
  if File.exist?(pfad(n))
    load_sample pfad(n)
    puts "GELADEN: " + n + ".wav"
  else
    puts "NOCH NICHT DA: " + n + ".wav (wird uebersprungen)"
  end
end

define :vox do |name, opts = {}|
  if File.exist?(pfad(name))
    puts "VOX SPIELT: " + name + " (Takt #{takt})"
    sample pfad(name), opts
  else
    puts "VOX FEHLT: " + name
  end
end

# ============================================================
# CLOCK -- set VOR cue, damit alle Loops denselben Takt sehen
# ============================================================

live_loop :puls, auto_cue: false do
  t = tick(:takt_counter)
  set :takt, t
  cue :puls
  puts "TAKT: #{t}"
  stop if t >= 128
  sleep 4
end

define :takt do
  get(:takt) || 0
end

# ============================================================
# HARMONIE -- Dm | Bb | F | C, jeder Akkord zwei Takte.
# Die Harmonie bleibt stabil: Die politische Ordnung wird
# nicht durch Akkordwechsel dargestellt, sondern dadurch,
# was die Stimmen innerhalb dieser Ordnung tun.
# ============================================================

live_loop :drone, sync: :puls do
  t = takt
  stop if t >= 128

  roots = [:d2, :bb1, :f2, :c2]
  modes = [:minor, :major, :major, :major]
  pos = (t / 2) % 4

  amp_level =
    if t < 16
      0.28
    elsif t < 48
      0.36
    elsif t < 64
      0.32
    elsif t < 96
      0.40
    elsif t < 112
      0.38
    else
      0.28
    end

  use_synth :dark_ambience

  with_fx :reverb, room: 1, mix: 0.78 do
    with_fx :lpf, cutoff: (t < 64 ? 62 : 56) do
      play chord(roots[pos], modes[pos]),
        attack: 2,
        sustain: 5,
        release: 5,
        amp: amp_level
    end
  end

  sleep 4
end

# ============================================================
# SUB -- keine Bassline, sondern Fundament. In PANEM waermer
# und angenehmer, in VIGILANDO trockener und bestimmter.
# ============================================================

live_loop :sub, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 12 || t >= 124
    sleep 4
  else
    roots = [:d1, :bb0, :f1, :c1]
    root = roots[(t / 2) % 4]

    amp_level =
      if t < 32
        0.58
      elsif t < 64
        0.70
      elsif t < 96
        0.82
      elsif t < 112
        0.88
      else
        0.52
      end

    use_synth :subpulse

    with_fx :lpf, cutoff: (t < 96 ? 58 : 64) do
      play root,
        attack: 0.08,
        sustain: 3.3,
        release: 1.4,
        amp: amp_level
    end

    sleep 4
  end
end

# ============================================================
# HALF-TIME DRUMS -- Witch-House-Grundpuls.
# VIGILIA fast beatlos | NON NOBIS: Puls entsteht |
# CONCORDIA voller Beat | DISCORDIA Luecken |
# PANEM/SOMNUS hypnotisch gleichmaessig | VIGILANDO: erst
# einzelne Kicks, dann entschlossene Rueckkehr | ab 116 Stille
# ============================================================

live_loop :drums, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 16 || t >= 116
    sleep 4

  elsif t >= 48 && t < 64
    # DISCORDIA -- der gemeinsame Puls zerfaellt
    if t.even?
      with_fx :distortion, distort: 0.12, mix: 0.16 do
        sample :bd_haus,
          rate: 0.74,
          amp: 1.18
      end

      sleep 3

      with_fx :reverb, room: 0.92, mix: 0.52 do
        sample :sn_dolf,
          rate: 0.64,
          amp: 0.54
      end

      sleep 1
    else
      sleep 1.5

      sample :bd_haus,
        rate: 0.70,
        amp: 0.88

      sleep 2.5
    end

  elsif t >= 96 && t < 100
    # VIGILANDO -- der Schlaf wird unterbrochen, noch kein Beat
    if t == 96
      sample :bd_haus,
        rate: 0.72,
        amp: 1.38
    elsif t == 98
      sample :bd_haus,
        rate: 0.74,
        amp: 1.48
    end

    sleep 4

  else
    kick_amp =
      if t < 32
        1.04
      elsif t < 48
        1.28
      elsif t < 80
        1.32
      elsif t < 96
        1.42
      elsif t < 112
        1.50
      else
        1.12
      end

    snare_amp =
      if t < 32
        0.54
      elsif t < 48
        0.72
      elsif t < 96
        0.80
      elsif t < 112
        0.88
      else
        0.56
      end

    with_fx :distortion,
      distort: (t >= 96 ? 0.16 : 0.10),
      mix: 0.18 do

      sample :bd_haus,
        rate: 0.76,
        amp: kick_amp
    end

    sleep 2

    with_fx :reverb,
      room: 0.88,
      mix: 0.44 do

      with_fx :distortion,
        distort: 0.18,
        mix: 0.22 do

        sample :sn_dolf,
          rate: 0.70,
          amp: snare_amp
      end
    end

    sleep 2
  end
end

# ============================================================
# HATS -- nie zum treibenden Techno-Element werden lassen.
# Die Bewegung soll schwer bleiben.
# ============================================================

live_loop :hats, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 24 || t >= 112
    sleep 4

  elsif t < 48
    4.times do |i|
      sleep 0.5

      sample :drum_cymbal_closed,
        rate: (i.even? ? 0.60 : 0.68),
        amp: 0.12,
        release: 0.04

      sleep 0.5
    end

  elsif t < 64
    # DISCORDIA -- asymmetrische Reste
    8.times do |i|
      if [0, 3, 5].include?(i)
        sample :drum_cymbal_closed,
          rate: 0.56,
          amp: 0.14,
          release: 0.03
      end

      sleep 0.5
    end

  elsif t < 96
    # PANEM / SOMNUS -- fast zu angenehm regelmaessig
    8.times do |i|
      sample :drum_cymbal_closed,
        rate: (i.even? ? 0.64 : 0.72),
        amp: (i % 4 == 3 ? 0.18 : 0.11),
        release: 0.03

      sleep 0.5
    end

  else
    # VIGILANDO -- etwas klarer, aber weiterhin Half-Time
    8.times do |i|
      if i.even? || i == 7
        sample :drum_cymbal_closed,
          rate: 0.70,
          amp: (i == 7 ? 0.20 : 0.13),
          release: 0.03
      end

      sleep 0.5
    end
  end
end

# ============================================================
# CONCORDIA-THEMA -- dunkel, europaeisch, nicht pentatonisch.
#
# Phrase A:  D -> A -> F -> E | F -> D -> C# -> D
#   Der Sprung D-A gibt dem Motiv Gewicht; C# ist der
#   Leitton von d-Moll und zieht bewusst nach D.
# Phrase B:  A -> Bb -> A -> F | E -> F -> E -> D
#   Die Halbtonbewegungen A-Bb und E-F geben Spannung.
# Beide Phrasen: exakt 8 Beats = 2 Takte.
# ============================================================

define :concordia_a do |amp_level = 0.40, pan_pos = 0|
  play :d4, release: 2.2, amp: amp_level, pan: pan_pos
  sleep 1.5

  play :a4, release: 1.4, amp: amp_level * 0.96, pan: pan_pos
  sleep 0.5

  play :f4, release: 2.0, amp: amp_level * 0.92, pan: pan_pos
  sleep 1

  play :e4, release: 2.4, amp: amp_level * 0.86, pan: pan_pos
  sleep 1

  play :f4, release: 1.8, amp: amp_level * 0.92, pan: pan_pos
  sleep 1

  play :d4, release: 1.8, amp: amp_level, pan: pan_pos
  sleep 1

  play :cs4, release: 1.5, amp: amp_level * 0.82, pan: pan_pos
  sleep 0.5

  play :d4, release: 3.5, amp: amp_level, pan: pan_pos
  sleep 1.5
end

define :concordia_b do |amp_level = 0.40, pan_pos = 0|
  play :a4, release: 2.0, amp: amp_level, pan: pan_pos
  sleep 1.5

  play :bb4, release: 1.3, amp: amp_level * 0.92, pan: pan_pos
  sleep 0.5

  play :a4, release: 2.2, amp: amp_level, pan: pan_pos
  sleep 1

  play :f4, release: 2.4, amp: amp_level * 0.90, pan: pan_pos
  sleep 1

  play :e4, release: 1.5, amp: amp_level * 0.84, pan: pan_pos
  sleep 1

  play :f4, release: 1.5, amp: amp_level * 0.90, pan: pan_pos
  sleep 0.5

  play :e4, release: 1.5, amp: amp_level * 0.84, pan: pan_pos
  sleep 0.5

  play :d4, release: 4.0, amp: amp_level, pan: pan_pos
  sleep 2
end

# ============================================================
# HAUPTSTIMME -- aus einzelnen Fragmenten entsteht die
# Melodie, sie zerfaellt, verschwindet und kehrt zurueck.
# ============================================================

live_loop :concordia_melody, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 8
    sleep 8

  elsif t < 16
    # VIGILIA -- man erkennt das Thema noch nicht
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.84 do
      with_fx :lpf, cutoff: 68 do
        play :d4,
          attack: 0.8,
          release: 4,
          amp: 0.24

        sleep 4

        play :f4,
          attack: 0.8,
          release: 4,
          amp: 0.22

        sleep 4
      end
    end

  elsif t < 32
    # NON NOBIS SOLUM -- eine einzelne Stimme
    use_synth :blade

    with_fx :reverb, room: 1, mix: 0.76 do
      with_fx :echo, phase: 1.5, decay: 7, mix: 0.32 do
        with_fx :lpf, cutoff: 76 do
          concordia_a 0.36, 0
          concordia_b 0.38, 0
        end
      end
    end

  elsif t < 48
    # CONCORDIA -- das Thema wird deutlicher und sicherer
    use_synth :blade

    with_fx :reverb, room: 1, mix: 0.70 do
      with_fx :echo, phase: 1.5, decay: 6, mix: 0.26 do
        with_fx :lpf, cutoff: 82 do
          concordia_a 0.44, -0.08
          concordia_b 0.46, -0.08
        end
      end
    end

  elsif t < 64
    # DISCORDIA -- nur Bruchstuecke der gemeinsamen Phrase
    use_synth :blade

    with_fx :distortion, distort: 0.16, mix: 0.20 do
      with_fx :reverb, room: 1, mix: 0.82 do
        with_fx :lpf, cutoff: 70 do
          play :d4, release: 3, amp: 0.30
          sleep 3

          play :g4, release: 2, amp: 0.26
          sleep 1

          sleep 4

          play :a4, release: 3, amp: 0.30
          sleep 2

          play :e4, release: 5, amp: 0.34
          sleep 6
        end
      end
    end

  elsif t < 88
    # PANEM ET CIRCENSES -- das eigentliche Thema schweigt
    sleep 16

  elsif t < 96
    # SOMNUS -- ein kaum hoerbarer Rest versucht die Rueckkehr
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.90 do
      with_fx :lpf, cutoff: 58 do
        play :d4,
          attack: 1,
          release: 5,
          amp: 0.14

        sleep 4

        play :f4,
          attack: 1,
          release: 5,
          amp: 0.12

        sleep 4
      end
    end

  elsif t < 112
    # VIGILANDO / AGENDO -- das Thema kehrt vollstaendig zurueck
    use_synth :blade

    with_fx :reverb, room: 0.94, mix: 0.60 do
      with_fx :lpf, cutoff: 88 do
        concordia_a 0.50, -0.10
        concordia_b 0.52, -0.10
      end
    end

  elsif t < 120
    # NON NOBIS SOLUM -- wieder eine einzelne klare Stimme
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.72 do
      with_fx :lpf, cutoff: 76 do
        concordia_a 0.38, 0
      end
    end

  else
    sleep 8
  end
end

# ============================================================
# ALTERA VOX -- die zweite Stimme: erst Antwort, in DISCORDIA
# Fremdtoene, am Ende gemeinsames Handeln. Sie ist der
# musikalische Kern von CONCORDIA.
# ============================================================

live_loop :altera_vox, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 32
    sleep 4

  elsif t < 48
    # CONCORDIA -- die zweite Stimme antwortet versetzt
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.82 do
      with_fx :lpf, cutoff: 70 do
        sleep 2

        play :d4, release: 2, amp: 0.22, pan: 0.34
        sleep 1
        play :f4, release: 2, amp: 0.22, pan: 0.34
        sleep 1
      end
    end

  elsif t < 64
    # DISCORDIA -- die Antwort passt nicht mehr zur Hauptstimme
    use_synth :hollow

    with_fx :distortion, distort: 0.18, mix: 0.20 do
      with_fx :reverb, room: 1, mix: 0.86 do
        wrong_notes = [:eb4, :gb4, :c4, :ab4]
        note = wrong_notes[t % 4]

        play note,
          attack: 0.6,
          release: 4,
          amp: 0.20,
          pan: 0.40
      end
    end

    sleep 4

  elsif t < 96
    sleep 4

  elsif t < 112
    # VIGILANDO -- keine Erscheinung mehr: Sie handelt
    # gleichzeitig mit der ersten Stimme.
    use_synth :hollow

    with_fx :reverb, room: 0.96, mix: 0.66 do
      with_fx :lpf, cutoff: 76 do
        notes = [:f3, :a3, :bb3, :c4]
        note = notes[t % 4]

        play note,
          attack: 0.4,
          sustain: 2.0,
          release: 3.0,
          amp: 0.26,
          pan: 0.26
      end
    end

    sleep 4

  else
    sleep 4
  end
end

# ============================================================
# PANEM ET CIRCENSES -- das Gegenmotiv: A C A G | A C D C.
# Absichtlich eingaengig, weich und repetitiv. Die Gefahr
# klingt nicht wie Gefahr. Sie klingt angenehm.
# ============================================================

define :panem_motif do |amp_level = 0.30|
  play :a4, release: 1.2, amp: amp_level
  sleep 1
  play :c5, release: 1.2, amp: amp_level
  sleep 1
  play :a4, release: 1.2, amp: amp_level
  sleep 1
  play :g4, release: 1.5, amp: amp_level
  sleep 1

  play :a4, release: 1.2, amp: amp_level
  sleep 1
  play :c5, release: 1.2, amp: amp_level
  sleep 1
  play :d5, release: 1.4, amp: amp_level
  sleep 1
  play :c5, release: 1.8, amp: amp_level
  sleep 1
end

live_loop :panem, sync: :puls do
  t = takt
  stop if t >= 128

  if t < 64
    sleep 8

  elsif t < 80
    use_synth :blade

    with_fx :reverb, room: 0.92, mix: 0.56 do
      with_fx :echo, phase: 1, decay: 5, mix: 0.22 do
        with_fx :lpf, cutoff: 88 do
          panem_motif 0.30
        end
      end
    end

  elsif t < 96
    # SOMNUS -- dieselbe Phrase wird immer wieder angeboten
    use_synth :blade

    with_fx :reverb, room: 0.94, mix: 0.62 do
      with_fx :echo, phase: 1, decay: 6, mix: 0.32 do
        with_fx :lpf, cutoff: 82 do
          panem_motif 0.36
        end
      end
    end

  else
    sleep 8
  end
end

# ============================================================
# RITUALSTIMMEN -- Gegenbewegung zu Fragor Noctis: zuerst
# geisterhaft und entfernt, am Ende immer menschlicher.
# 10 non nobis | 34 concordia | 50 discordia | 66/82 panem |
# 96 vigilando | 100 agendo | 104 bene consulendo |
# 114 non nobis (menschlich) | 119 falso queritur (Epilog)
# ============================================================

live_loop :stimmen, sync: :puls do
  t = takt
  stop if t >= 128

  case t

  when 10
    # NON NOBIS SOLUM -- noch fast eine Erinnerung
    with_fx :reverb, room: 0.8, mix: 0.4 do
      with_fx :lpf, cutoff: 72 do
        vox "vocal_non_nobis_solum",
          rate: 0.85,
          amp: 0.74,
          pan: 0
      end
    end

    in_thread do
      sleep 0.38

      with_fx :reverb, room: 0.7, mix: 0.3 do
        vox "vocal_non_nobis_solum",
          rate: -0.42,
          amp: 0.24,
          pan: -0.30
      end
    end

  when 34
    # CONCORDIA -- aus einer Stimme werden mehrere
    with_fx :reverb, room: 0.7, mix: 0.38 do
      vox "vocal_concordia",
        rate: 0.78,
        amp: 0.64,
        pan: 0
    end

    in_thread do
      sleep 0.28

      with_fx :reverb, room: 0.7, mix: 0.34 do
        vox "vocal_concordia",
          rate: 0.58,
          amp: 0.24,
          pan: -0.46
      end
    end

    in_thread do
      sleep 0.46

      with_fx :reverb, room: 1, mix: 0.86 do
        vox "vocal_concordia",
          rate: 0.62,
          amp: 0.20,
          pan: 0.46
      end
    end

  when 50
    # DISCORDIA -- dieselbe Vielstimmigkeit zerfaellt
    with_fx :distortion, distort: 0.20, mix: 0.24 do
      vox "vocal_discordia",
        rate: 0.60,
        amp: 0.62,
        pan: 0
    end

    in_thread do
      sleep 0.17

      with_fx :reverb, room: 1, mix: 0.90 do
        vox "vocal_discordia",
          rate: -0.46,
          amp: 0.22,
          pan: -0.52
      end
    end

    in_thread do
      sleep 0.53

      with_fx :bitcrusher,
        bits: 8,
        sample_rate: 10500,
        mix: 0.24 do

        vox "vocal_discordia",
          rate: 0.51,
          amp: 0.20,
          pan: 0.52
      end
    end

  when 66
    # PANEM ET CIRCENSES -- verlockend, weich, fast intim
    with_fx :reverb, room: 0.94, mix: 0.58 do
      with_fx :echo, phase: 1.5, decay: 7, mix: 0.30 do
        vox "vocal_panem_et_circenses",
          rate: 0.66,
          amp: 0.58,
          pan: 0
      end
    end

  when 82
    # Wiederholung -- die Formel wird zum Schlaflied
    with_fx :reverb, room: 1, mix: 0.72 do
      with_fx :lpf, cutoff: 68 do
        vox "vocal_panem_et_circenses",
          rate: 0.56,
          amp: 0.46,
          pan: -0.18
      end
    end

    in_thread do
      sleep 0.55

      with_fx :reverb, room: 1, mix: 0.88 do
        vox "vocal_panem_et_circenses",
          rate: 0.48,
          amp: 0.18,
          pan: 0.32
      end
    end

  when 96
    # VIGILANDO -- die erste klare Unterbrechung des Schlafs
    with_fx :reverb, room: 0.72, mix: 0.28 do
      vox "vocal_vigilando",
        rate: 0.82,
        amp: 0.86,
        pan: 0
    end

  when 100
    # AGENDO -- weniger Effekt, mehr Mensch
    with_fx :reverb, room: 0.62, mix: 0.22 do
      vox "vocal_agendo",
        rate: 0.88,
        amp: 0.90,
        pan: 0
    end

  when 104
    # BENE CONSULENDO -- die am wenigsten verfremdete Stimme
    with_fx :reverb, room: 0.58, mix: 0.18 do
      vox "vocal_bene_consulendo",
        rate: 0.92,
        amp: 0.92,
        pan: 0
    end

  when 114
    # NON NOBIS SOLUM -- kein Geist, kein Chor:
    # eine einzelne menschliche Stimme
    with_fx :reverb, room: 0.76, mix: 0.34 do
      vox "vocal_non_nobis_solum",
        rate: 0.82,
        amp: 0.72,
        pan: 0
    end

  when 119
    # FALSO QUERITUR -- Sallust, Iugurtha 1, vollstaendig.
    # 19.133 s bei rate 0.95 = 20.14 s = 6.55 Takte -> endet
    # ~125.5. "Sed dux atque imperator..." landet ~Takt 123.4,
    # unmittelbar nach dem finalen D: Die Entscheidung faellt,
    # und der Satz erklaert sie. Der Rueckwaerts-Zwilling endet
    # auf dem umgekehrten "Falso" -- die Klage loest sich
    # rueckwaerts auf, vorwaerts bleibt "animus est" stehen.
    with_fx :reverb, room: 0.9, mix: 0.70 do
      with_fx :lpf, cutoff: 78 do
        vox "vocal_falso_queritur",
          rate: 0.95,
          amp: 0.70,
          pan: 0
      end

      with_fx :lpf, cutoff: 66 do
        vox "vocal_falso_queritur",
          rate: -0.95,
          amp: 0.40,
          pan: 0
      end
    end
  end

  sleep 4
end

# ============================================================
# REVERSE GHOSTS -- die alten Formeln bleiben im Raum.
# Sparsam: Witch House, nicht Geisterbahn.
# 46 concordia | 62 discordia | 94 panem (vor VIGILANDO)
# ============================================================

live_loop :reverse_ghosts, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 46
    with_fx :reverb, room: 1, mix: 0.88 do
      vox "vocal_concordia",
        rate: -0.46,
        amp: 0.24,
        pan: -0.24
    end

  elsif t == 62
    with_fx :reverb, room: 1, mix: 0.90 do
      vox "vocal_discordia",
        rate: -0.40,
        amp: 0.30,
        pan: 0.22
    end

  elsif t == 94
    # Das Schlaflied zerfaellt unmittelbar vor VIGILANDO
    with_fx :reverb, room: 1, mix: 0.92 do
      with_fx :lpf, cutoff: 62 do
        vox "vocal_panem_et_circenses",
          rate: -0.38,
          amp: 0.28,
          pan: 0
      end
    end
  end

  sleep 4
end

# ============================================================
# OMINOUS DRONE -- kein permanentes Bett; er markiert nur die
# Momente, in denen die Gefahr sichtbar wird (4, 52).
# ============================================================

live_loop :ominous, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 4
    with_fx :lpf, cutoff: 66 do
      with_fx :reverb, room: 0.7, mix: 0.30 do
        vox "effect_ominous_drone",
          rate: 0.78,
          amp: 0.64
      end
    end

  elsif t == 52
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 0.7, mix: 0.30 do
        vox "effect_ominous_drone",
          start: 0.24,
          rate: 0.64,
          amp: 0.28
      end
    end
  end

  sleep 4
end

# ============================================================
# STORM -- DISCORDIA bekommt einen entfernten Horizont.
# Kein Sturm im ganzen Track; nur eine Wetterfront (44).
# ============================================================

live_loop :storm, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 44
    with_fx :lpf, cutoff: 62 do
      with_fx :reverb, room: 1, mix: 0.62 do
        vox "effect_gathering_storm",
          rate: 0.68,
          amp: 0.24
      end
    end
  end

  sleep 4
end

# ============================================================
# FINALE -- die entscheidende Abweichung von Fragor Noctis.
# 120: A -> G -> F -> E | 121-122: keine Antwort | 123: D.
# Nicht Triumph, nicht Fanfare -- nur die Entscheidung,
# nicht im E stehenzubleiben.
# ============================================================

live_loop :finale, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 120
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.82 do
      with_fx :lpf, cutoff: 72 do
        play :a4,
          attack: 0.5,
          release: 3,
          amp: 0.38

        sleep 1

        play :g4,
          attack: 0.5,
          release: 3,
          amp: 0.34

        sleep 1

        play :f4,
          attack: 0.5,
          release: 3,
          amp: 0.32

        sleep 1

        play :e4,
          attack: 0.8,
          release: 8,
          amp: 0.40

        sleep 1
      end
    end

  elsif t == 121
    # Der Nachhall von E darf bleiben.
    sleep 4

  elsif t == 122
    # Noch immer keine Antwort.
    sleep 4

  elsif t == 123
    # Die Entscheidung fuer D.
    use_synth :hollow

    with_fx :reverb, room: 1, mix: 0.88 do
      with_fx :lpf, cutoff: 60 do
        play :d4,
          attack: 1.2,
          sustain: 3,
          release: 14,
          amp: 0.46

        play :d3,
          attack: 1.5,
          sustain: 3,
          release: 16,
          amp: 0.22
      end
    end

    sleep 4

  else
    sleep 4
  end
end

# ============================================================
# GHOSTS MUMBLING -- das Gemurmel als Langzeit-Motiv.
#
# Einzelne Erscheinungen (Fragmente):
#   12 fern links | 28 andere Seite | 44 vorwaerts+rueckwaerts
#   56 zwei Stimmen (DISCORDIA) | 72 ploetzlich sehr nah
# SOMNUS -- die Gemeinde entsteht, Stimme fuer Stimme:
#   80 | 84 | 88 (rueckwaerts) | 92 (rueckwaerts)
#   Jede neue Stimme etwas leiser: Dichte statt Lautstaerke.
#   Der volle Geisterchor existiert nur hier.
# 96 VIGILANDO: das Gemurmel endet -- aus dem Stimmengewirr
#   tritt ein einzelnes verstaendliches Wort hervor.
# ============================================================

live_loop :mumble, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 12
    # Erste Erscheinung -- kaum als menschliche Stimme erkennbar
    with_fx :lpf, cutoff: 52 do
      with_fx :reverb, room: 1.0, mix: 0.68 do
        vox "effect_mumbling",
          start: 0.42,
          rate: 0.72,
          amp: 0.46,
          pan: -0.55
      end
    end
  end

  if t == 28
    # Zweite Erscheinung -- von der anderen Seite
    with_fx :lpf, cutoff: 62 do
      with_fx :reverb, room: 0.9, mix: 0.52 do
        vox "effect_mumbling",
          start: 0.18,
          rate: 0.78,
          amp: 0.50,
          pan: 0.48
      end
    end
  end

  if t == 44
    # Erster Schwarm -- eine Stimme und ihr Rueckwaerts-Schatten
    in_thread do
      with_fx :lpf, cutoff: 64 do
        with_fx :reverb, room: 0.9, mix: 0.48 do
          vox "effect_mumbling",
            start: 0.30,
            rate: 0.76,
            amp: 0.54,
            pan: -0.28
        end
      end
    end

    in_thread do
      sleep 0.30

      with_fx :lpf, cutoff: 56 do
        with_fx :reverb, room: 1.0, mix: 0.68 do
          vox "effect_mumbling",
            rate: -0.68,
            amp: 0.53,
            pan: 0.42
        end
      end
    end
  end

  if t == 56
    # DISCORDIA -- erstmals zwei klar unterscheidbare Stimmen
    in_thread do
      with_fx :lpf, cutoff: 68 do
        with_fx :reverb, room: 0.85, mix: 0.44 do
          vox "effect_mumbling",
            start: 0.10,
            rate: 0.76,
            amp: 0.68,
            pan: -0.42
        end
      end
    end

    in_thread do
      sleep 0.55

      with_fx :lpf, cutoff: 72 do
        with_fx :reverb, room: 0.9, mix: 0.48 do
          vox "effect_mumbling",
            start: 0.36,
            rate: 0.82,
            amp: 0.64,
            pan: 0.38
        end
      end
    end
  end

  if t == 72
    # Weniger Filter, weniger Hall -- jemand steht ploetzlich nah
    with_fx :lpf, cutoff: 92 do
      with_fx :reverb, room: 0.65, mix: 0.24 do
        vox "effect_mumbling",
          start: 0.12,
          rate: 0.82,
          amp: 0.56,
          pan: 0.18
      end
    end
  end

  if t == 80
    # SOMNUS, Stimme 1 -- dunkel, links, vorwaerts
    in_thread do
      with_fx :lpf, cutoff: 66 do
        with_fx :reverb, room: 0.8, mix: 0.40 do
          vox "effect_mumbling",
            rate: 0.78,
            amp: 0.64,
            pan: -0.25
        end
      end
    end
  end

  if t == 84
    # Stimme 2 -- heller und naeher, keine Kopie von Stimme 1
    in_thread do
      with_fx :lpf, cutoff: 86 do
        with_fx :reverb, room: 0.6, mix: 0.20 do
          vox "effect_mumbling",
            start: 0.18,
            rate: 0.78,
            amp: 0.52,
            pan: 0.28
        end
      end
    end
  end

  if t == 88
    # Stimme 3 -- die erste rueckwaerts laufende
    in_thread do
      with_fx :lpf, cutoff: 66 do
        with_fx :reverb, room: 0.8, mix: 0.40 do
          vox "effect_mumbling",
            rate: -0.78,
            amp: 0.46,
            pan: -0.42
        end
      end
    end
  end

  if t == 92
    # Stimme 4 -- der vollstaendige Geisterchor ist erreicht
    in_thread do
      with_fx :lpf, cutoff: 86 do
        with_fx :reverb, room: 1.0, mix: 0.40 do
          vox "effect_mumbling",
            start: 0.26,
            rate: -0.78,
            amp: 0.40,
            pan: 0.42
        end
      end
    end
  end

  sleep 4
end

# ============================================================
# THE ABYSS -- tiefer dissonanter Untergrund.
#
# D = tonales Zentrum | Eb = kleine Sekunde (Reibung) |
# Ab = Tritonus (Bedrohung). Kein Motiv -- etwas, das unter
# dem Track lebt. Sein Verlauf spiegelt das Narrativ:
# 8-31 fast unhoerbar | 32-43 verschwindet beinahe |
# 44-47 Eb kehrt zurueck | 48-63 D/Eb/Ab offen |
# 64-79 tiefer versteckt | 80-95 ganz geoeffnet |
# 96-111 nur noch D -- so wichtig wie das Wort VIGILANDO.
# ============================================================

live_loop :abyss, sync: :puls do
  t = takt
  stop if t >= 128

  if t >= 8 && t < 32 && t % 4 == 0
    # VIGILIA / NON NOBIS -- fast unhoerbar: D + entferntes Eb
    with_fx :lpf, cutoff: 48 do
      with_fx :reverb, room: 1, mix: 0.65 do
        use_synth :dark_ambience

        play :d2,
          attack: 2,
          sustain: 10,
          release: 6,
          amp: 0.16

        play :eb2,
          attack: 4,
          sustain: 8,
          release: 8,
          amp: 0.055
      end
    end
  end

  if t >= 32 && t < 44 && t % 4 == 0
    # CONCORDIA -- die Bedrohung verschwindet beinahe
    with_fx :lpf, cutoff: 44 do
      with_fx :reverb, room: 1, mix: 0.72 do
        use_synth :dark_ambience

        play :d2,
          attack: 3,
          sustain: 8,
          release: 7,
          amp: 0.10
      end
    end
  end

  if t >= 44 && t < 48
    # 44-47 -- etwas stimmt nicht: Eb kehrt zurueck
    with_fx :lpf, cutoff: 52 do
      with_fx :reverb, room: 1, mix: 0.70 do
        use_synth :dark_ambience

        play :d2,
          attack: 1.5,
          sustain: 5,
          release: 5,
          amp: 0.18

        play :eb2,
          attack: 2,
          sustain: 5,
          release: 6,
          amp: 0.10
      end
    end
  end

  if t >= 48 && t < 64 && t % 2 == 0
    # DISCORDIA -- D/Eb/Ab bilden den eigentlichen Abgrund
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 1, mix: 0.72 do
        with_fx :distortion, distort: 0.12, mix: 0.16 do
          use_synth :dark_ambience

          play :d2,
            attack: 2,
            sustain: 7,
            release: 6,
            amp: 0.22

          play :eb2,
            attack: 3,
            sustain: 6,
            release: 7,
            amp: 0.13

          play :ab1,
            attack: 4,
            sustain: 6,
            release: 8,
            amp: 0.12
        end
      end
    end
  end

  if t >= 64 && t < 80 && t % 4 == 0
    # PANEM ET CIRCENSES -- die Bedrohung tiefer versteckt
    with_fx :lpf, cutoff: 46 do
      with_fx :reverb, room: 1, mix: 0.78 do
        use_synth :dark_ambience

        play :d2,
          attack: 4,
          sustain: 10,
          release: 8,
          amp: 0.15

        play :ab1,
          attack: 5,
          sustain: 9,
          release: 9,
          amp: 0.085
      end
    end
  end

  if t >= 80 && t < 96 && t % 2 == 0
    # SOMNUS -- der Abgrund oeffnet sich vollstaendig
    with_fx :lpf, cutoff: 62 do
      with_fx :reverb, room: 1, mix: 0.72 do
        with_fx :distortion, distort: 0.16, mix: 0.18 do
          use_synth :dark_ambience

          play :d2,
            attack: 2,
            sustain: 7,
            release: 7,
            amp: 0.26

          play :eb2,
            attack: 3,
            sustain: 6,
            release: 8,
            amp: 0.16

          play :ab1,
            attack: 4,
            sustain: 6,
            release: 9,
            amp: 0.15
        end
      end
    end
  end

  if t >= 96 && t < 112 && t % 4 == 0
    # VIGILANDO -- Eb und Ab verschwinden, nur D bleibt
    with_fx :lpf, cutoff: 50 do
      with_fx :reverb, room: 0.85, mix: 0.48 do
        use_synth :dark_ambience

        play :d2,
          attack: 2,
          sustain: 8,
          release: 6,
          amp: 0.13
      end
    end
  end

  sleep 4
end

# ============================================================
# PRINCIPIIS OBSTATE -- "Wehret den Anfaengen" (Ovid,
# Remedia Amoris 91; Plural als Anrede an die Vielen).
#
# Das Motiv entwickelt sich durch den ganzen Track:
#   2 vorwaerts / 3 rueckwaerts -> Prophezeiung vor jedem
#                                  Kontext
#  20 OBSTATE            -> entfernte Warnung
#  30 PRINCIPIIS OBSTATE -> erstmals erkennbar
#  42 OBSTATE            -> klare Warnung vor DISCORDIA
#  58 PRINCIPIIS OBSTATE -> durch DISCORDIA beschaedigt
#  76 OBSTATE            -> unter PANEM fast begraben
#  90 PRINCIPIIS OBSTATE -> in SOMNUS beinahe verschluckt
# 108 PRINCIPIIS OBSTATE -> die Konsequenz nach VIGILANDO/
#                           AGENDO/BENE CONSULENDO: klar,
#                           menschlich, entschlossen
# 118 OBSTATE            -> leise letzte Erinnerung; danach
#                           spricht nur noch die Quelle
#                           selbst (Falso queritur, 119)
# ============================================================

live_loop :obstate, sync: :puls do
  t = takt
  stop if t >= 128

  case t

  when 2
    # Prophezeiung -- die Warnung kommt vor ihrem Kontext
    with_fx :lpf, cutoff: 66 do
      with_fx :reverb, room: 0.8, mix: 0.26 do
        vox "vocal_principiis_obstate",
          rate: 0.60,
          amp: 0.75,
          pan: -0.38
      end
    end

  when 3
    # ... und laeuft sofort rueckwaerts wieder fort
    with_fx :lpf, cutoff: 66 do
      with_fx :reverb, room: 0.8, mix: 0.26 do
        vox "vocal_principiis_obstate",
          rate: -0.60,
          amp: 0.60,
          pan: 0.38
      end
    end

  when 20
    # Erste Warnung -- fern, dunkel, mit Rueckwaerts-Schatten
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 1.0, mix: 0.76 do
        vox "vocal_obstate",
          rate: 0.66,
          amp: 0.32,
          pan: -0.38
      end
    end

    in_thread do
      sleep 0.34

      with_fx :lpf, cutoff: 50 do
        with_fx :reverb, room: 1.0, mix: 0.88 do
          vox "vocal_obstate",
            rate: -0.46,
            amp: 0.16,
            pan: 0.44
        end
      end
    end

  when 30
    # Die Formel wird verstaendlich -- noch geisterhaft
    with_fx :lpf, cutoff: 72 do
      with_fx :reverb, room: 0.92, mix: 0.52 do
        vox "vocal_principiis_obstate",
          rate: 0.74,
          amp: 0.52,
          pan: 0.22
      end
    end

    in_thread do
      sleep 0.42

      with_fx :reverb, room: 1.0, mix: 0.82 do
        vox "vocal_principiis_obstate",
          rate: -0.38,
          amp: 0.11,
          pan: -0.46
      end
    end

  when 42
    # Klare Warnung kurz vor DISCORDIA -- direkt und nah
    with_fx :reverb, room: 0.68, mix: 0.28 do
      with_fx :lpf, cutoff: 88 do
        vox "vocal_obstate",
          rate: 0.84,
          amp: 0.68,
          pan: -0.08
      end
    end

  when 58
    # DISCORDIA -- die Warnung ist selbst zerbrochen
    in_thread do
      with_fx :distortion, distort: 0.22, mix: 0.26 do
        with_fx :lpf, cutoff: 66 do
          with_fx :reverb, room: 0.9, mix: 0.48 do
            vox "vocal_principiis_obstate",
              rate: 0.58,
              amp: 0.46,
              pan: -0.22
          end
        end
      end
    end

    in_thread do
      sleep 0.48

      with_fx :bitcrusher,
        bits: 7,
        sample_rate: 9000,
        mix: 0.32 do

        with_fx :reverb, room: 1.0, mix: 0.76 do
          vox "vocal_obstate",
            rate: -0.44,
            amp: 0.22,
            pan: 0.46
        end
      end
    end

  when 76
    # PANEM -- die angenehme Oberflaeche deckt die Warnung zu
    with_fx :lpf, cutoff: 54 do
      with_fx :reverb, room: 1.0, mix: 0.82 do
        with_fx :echo, phase: 1.5, decay: 6, mix: 0.20 do
          vox "vocal_obstate",
            rate: 0.60,
            amp: 0.26,
            pan: 0.34
        end
      end
    end

  when 90
    # SOMNUS -- die Warnung wird vom Schlaf verschluckt
    in_thread do
      with_fx :lpf, cutoff: 56 do
        with_fx :distortion, distort: 0.28, mix: 0.30 do
          with_fx :reverb, room: 1.0, mix: 0.78 do
            vox "vocal_principiis_obstate",
              rate: 0.50,
              amp: 0.38,
              pan: -0.26
          end
        end
      end
    end

    in_thread do
      sleep 0.62

      with_fx :lpf, cutoff: 48 do
        with_fx :reverb, room: 1.0, mix: 0.90 do
          vox "vocal_principiis_obstate",
            rate: -0.34,
            amp: 0.16,
            pan: 0.38
        end
      end
    end

  when 108
    # Die Konsequenz -- kein Geist, keine Verzerrung
    with_fx :reverb, room: 0.56, mix: 0.18 do
      vox "vocal_principiis_obstate",
        rate: 0.85,
        amp: 0.94,
        pan: 0
    end

  when 118
    # Letzte Erinnerung -- leise und menschlich
    with_fx :reverb, room: 0.74, mix: 0.30 do
      with_fx :lpf, cutoff: 82 do
        vox "vocal_obstate",
          rate: 0.86,
          amp: 0.54,
          pan: 0
      end
    end
  end

  sleep 4
end

# ============================================================
# KRAEHE -- das Omen ueber der angenehmen Oberflaeche (78).
# Ein einzelner Ruf in PANEM ET CIRCENSES: Die Gefahr ist
# nicht verschwunden, sie ist nur zugedeckt.
# ============================================================

live_loop :kraehe, sync: :puls do
  t = takt
  stop if t >= 128

  if t == 78
    with_fx :reverb, room: 0.9, mix: 0.55 do
      with_fx :lpf, cutoff: 90 do
        vox "effect_craw",
          rate: 0.82,
          amp: 0.55,
          pan: 0.35
      end
    end
  end

  sleep 4
end
