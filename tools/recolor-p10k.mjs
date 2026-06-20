// Recolore o ~/.p10k.zsh (config classic do Powerlevel10k) pro tema
// "Cinza + Verde Neon" legível em fundo escuro, preservando o LAYOUT
// (segmentos, ícones, ordem) — só troca as cores 256 de FOREGROUND/BACKGROUND.
//
// Filosofia (mesma do neon-theme.zsh):
//   verde neon (46)  → acentos / verdes / estados OK
//   cinza claro (250)→ texto/info (cyans, blues, teals)
//   cinza médio (245)→ secundário/dim (cyans dessaturados, roxos)
//   âmbar (214)      → avisos (amarelos/laranjas)
//   vermelho (196)   → erros/perigo (vermelhos)
//   branco (255)     → mantido; fundo de segmento (238) mantido
//
// Uso:  node tools/recolor-p10k.mjs [caminho]   (default: ~/.p10k.zsh; senão ./.p10k.zsh)

import { readFileSync, writeFileSync, existsSync } from 'node:fs'
import { homedir } from 'node:os'
import { join } from 'node:path'

const argPath = process.argv[2]
const candidates = [
  argPath,
  join(homedir(), '.p10k.zsh'),
  join(process.cwd(), '.p10k.zsh'),
].filter(Boolean)
const file = candidates.find((p) => p && existsSync(p))
if (!file) {
  console.error('[recolor] .p10k.zsh não encontrado. Passe o caminho como argumento.')
  process.exit(1)
}

// Mapa old(256) → new(256). Famílias de matiz → paleta do tema.
const MAP = {
  // verdes → neon 46
  28: 46, 34: 46, 35: 46, 70: 46, 76: 46, 106: 46,
  // cyans / blues / teals (info/texto) → cinza claro 250
  31: 250, 32: 250, 37: 250, 38: 250, 39: 250, 72: 250, 74: 250,
  81: 250, 110: 250, 117: 250,
  // cyans dessaturados / azul-acinzentado / roxos (secundário) → cinza médio 245
  66: 245, 67: 245, 68: 245, 96: 245, 99: 245, 103: 245,
  125: 245, 129: 245, 134: 245,
  // amarelos / laranjas (avisos) → âmbar 214
  94: 214, 166: 214, 172: 214, 178: 214, 180: 214, 208: 214, 220: 214,
  // vermelhos / rosa-vermelho (erros) → 196
  160: 196, 161: 196, 168: 196,
  // grays → garante legibilidade no escuro
  242: 244, 248: 250,
  // identidade (mantidos): 196, 255
}

let txt = readFileSync(file, 'utf8')
let changed = 0
txt = txt.replace(/(FOREGROUND|BACKGROUND)=(\d+)\b/g, (m, kind, num) => {
  const n = Number(num)
  if (Object.prototype.hasOwnProperty.call(MAP, n)) {
    changed++
    return `${kind}=${MAP[n]}`
  }
  return m
})

writeFileSync(file, txt, 'utf8')
console.log(`[recolor] ${changed} cores remapeadas em ${file}`)
