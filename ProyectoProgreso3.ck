// Duración de las notas
0.25::second => dur negra;     // Negra
0.125::second => dur corchea;  // Corchea
0.5::second => dur blanca;     // Blanca

// Osciladores y envolventes
SinOsc s => ADSR env => dac;   // Oscilador Sine con envolvente
TriOsc t => ADSR env2 => dac;  // Oscilador Triangular con envolvente

// Configuración de envolventes
1::second => env.attackTime;
0.5::second => env.releaseTime;
1::second => env2.attackTime;
0.5::second => env2.releaseTime;

// Escalas de frecuencias (Do Mayor, Re Mayor, Sol Mayor, Do Mayor una octava más alta)
[261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25] @=> float scaleDo[];
[293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25, 554.37] @=> float scaleRe[];
[392.00, 440.00, 493.88, 523.25, 554.37, 587.33, 622.25, 659.26] @=> float scaleSol[];
[523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99] @=> float scaleDoOctaveUp[]; // Escala de Do una octava más alta

// Función para tocar una nota con variación dinámica
fun void playNote(ADSR envelope, float freq, dur duration, float gain) {
    freq => envelope.gain => s.freq;  // Asigna frecuencia al oscilador Sine
    envelope.keyOn();                 // Enciende la envolvente
    gain => envelope.gain;            // Ajusta la ganancia
    duration => now;                  // Espera la duración de la nota
    envelope.keyOff();                // Apaga la envolvente
}

// Secuencia de la melodía con patrones rítmicos alternados
fun void melody() {
    while (true) {
        // Escala de Do Mayor
        for (0 => int i; i < scaleDo.cap(); i++) {
            if (i % 2 == 0) {
                scaleDo[i] => s.freq;
                playNote(env, scaleDo[i], negra, 0.5);  // Oscilador Sine con ganancia mayor
            } else {
                scaleDo[i] => t.freq;
                playNote(env2, scaleDo[i], corchea, 0.3); // Oscilador Triangular con ganancia menor
            }
            0.1::second => now; // Pausa entre notas
        }
        
        // Escala de Re Mayor
        for (0 => int i; i < scaleRe.cap(); i++) {
            if (i % 2 == 0) {
                scaleRe[i] => s.freq;
                playNote(env, scaleRe[i], negra, 0.6);  // Oscilador Sine con ganancia mayor
            } else {
                scaleRe[i] => t.freq;
                playNote(env2, scaleRe[i], corchea, 0.4); // Oscilador Triangular con ganancia media
            }
            0.1::second => now; // Pausa entre notas
        }

        // Escala de Sol Mayor
        for (0 => int i; i < scaleSol.cap(); i++) {
            if (i % 2 == 0) {
                scaleSol[i] => s.freq;
                playNote(env, scaleSol[i], negra, 0.7);  // Oscilador Sine con ganancia más alta
            } else {
                scaleSol[i] => t.freq;
                playNote(env2, scaleSol[i], corchea, 0.5); // Oscilador Triangular con ganancia media
            }
            0.1::second => now; // Pausa entre notas
        }

        // Escala de Do Mayor una octava más alta
        for (0 => int i; i < scaleDoOctaveUp.cap(); i++) {
            if (i % 2 == 0) {
                scaleDoOctaveUp[i] => s.freq;
                playNote(env, scaleDoOctaveUp[i], negra, 0.5);  // Oscilador Sine con ganancia mayor
            } else {
                scaleDoOctaveUp[i] => t.freq;
                playNote(env2, scaleDoOctaveUp[i], corchea, 0.4); // Oscilador Triangular con ganancia media
            }
            0.1::second => now; // Pausa entre notas
        }
    }
}

// Patrones rítmicos alternados (puedes incluir más patrones según lo desees)
spork ~ melody();

// Duración total
4::minute => now;