# powerbi-carousel.ps1
# Uso: powershell -ExecutionPolicy Bypass -File .\powerbi-carousel.ps1
# Gera index.html com carrossel que pré-carrega o próximo slide antes da transição e abre navegador em tela-cheia.

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$linksFile = Join-Path $scriptDir 'links.txt'
$indexFile = Join-Path $scriptDir 'index.html'

if (-not (Test-Path $linksFile)) {
    @'
# Cole aqui os links públicos do Power BI (um por linha).
# Exemplo: https://app.powerbi.com/view?r=...
# Remova linhas em branco e linhas começando com # quando adicionar seus links.
'@ | Set-Content -Path $linksFile -Encoding UTF8
    Write-Host "Arquivo links.txt criado em $linksFile. Edite-o com seus links e execute novamente."
    exit 0
}

$rawLinks = Get-Content $linksFile | ForEach-Object { $_.Trim() } | Where-Object { ($_ -ne '') -and ($_ -notmatch '^\s*#') }
if ($rawLinks.Count -lt 1) {
    Write-Error "Nenhum link válido encontrado em $linksFile"
    exit 1
}

$linksJson = $rawLinks | ConvertTo-Json -Compress

$htmlTemplate = @'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>PowerBI Carousel</title>
<style>
  html,body{height:100%;margin:0;background:#000}
  .carousel{position:relative;width:100%;height:100%;overflow:hidden}
  .slide{position:absolute;inset:0;transition:transform 1s ease,opacity 1s ease;opacity:0;transform:translateX(100%);will-change:transform,opacity}
  .slide.active{opacity:1;transform:translateX(0)}
  .slide.prev{transform:translateX(-100%);opacity:0}
  iframe{width:100%;height:100%;border:0;background:#fff}
  .overlay{position:absolute;right:10px;bottom:10px;color:#fff;background:rgba(0,0,0,0.4);padding:6px 10px;border-radius:4px;font-family: sans-serif}
  body.hide-cursor, body.hide-cursor *{cursor:none !important}
</style>
</head>
<body>
<div class="carousel" id="carousel"></div>
<div class="overlay" id="overlay">1 / N</div>
<script>
/*
  Comportamento:
  - DURATION: tempo total de exibição por slide (ms)
  - PRELOAD_MS: quantos ms antes da troca devemos iniciar o carregamento do próximo iframe
  - fluxo: startCycle() agenda preload e show em sequência usando timeouts para evitar flashes
*/
const LINKS = __LINKS__;
const DURATION = 20000; // 40 s por slide
const PRELOAD_MS = 5000; // pré-carrega 5s antes da transição (ajuste aqui conforme necessário)
const TRANSITION = 1000; // ms de transição (deve refletir CSS)
const carousel = document.getElementById('carousel');
const overlay = document.getElementById('overlay');
let slides = [];
let idx = 0;
let preloadTimeout = null;
let showTimeout = null;

function addCacheBuster(url){
  return url + (url.indexOf('?') === -1 ? '?' : '&') + '_cb=' + Date.now();
}

function createSlides(){
  LINKS.forEach((url, i) => {
    const s = document.createElement('div');
    s.className = 'slide';
    if(i===0) s.classList.add('active');
    const ifr = document.createElement('iframe');
    // apenas o primeiro carrega na inicialização; os demais aguardam preload
    if(i===0){
      ifr.src = addCacheBuster(url);
      ifr.dataset.loaded = '1';
    } else {
      ifr.src = '';
      ifr.dataset.src = url;
      ifr.dataset.loaded = '';
    }
    ifr.allow = "fullscreen; autoplay";
    s.appendChild(ifr);
    carousel.appendChild(s);
    slides.push(s);
  });
  overlay.textContent = (idx+1) + ' / ' + slides.length;
}

// Precarrega o iframe do próximo slide (se ainda não carregado)
function preloadNext(){
  const next = (idx + 1) % slides.length;
  const inn = slides[next];
  const innIframe = inn.querySelector('iframe');
  if (!innIframe) return;
  if (innIframe.dataset.loaded === '1') return; // já carregado
  const original = innIframe.dataset.src || LINKS[next] || innIframe.src;
  innIframe.src = addCacheBuster(original);
  innIframe.dataset.loaded = '1';
}

// Exibe o próximo slide (faz transição)
function show(next){
  if(next === idx) return;
  const prev = idx;
  const out = slides[prev];
  const inn = slides[next];

  // garante que o iframe que entra tenha src (se preload falhou por algum motivo)
  const innIframe = inn.querySelector('iframe');
  if (innIframe && innIframe.dataset.loaded !== '1') {
    const original = innIframe.dataset.src || LINKS[next] || innIframe.src;
    innIframe.src = addCacheBuster(original);
    innIframe.dataset.loaded = '1';
  }

  // faz a transição visual
  out.classList.remove('active');
  out.classList.add('prev');
  inn.classList.add('active');

  // após transição, limpa o iframe que saiu para liberar memória e marcar como não carregado
  setTimeout(()=>{
    out.classList.remove('prev');
    try {
      const outIf = out.querySelector('iframe');
      // limpa src para forçar reload na próxima vez (se desejar manter em cache, comente estas 2 linhas)
      outIf.src = '';
      outIf.dataset.loaded = '';
    } catch(e){ /* não acessamos contentWindow (cross-origin), apenas src/dataset */ }
  }, TRANSITION + 50);

  idx = next;
  overlay.textContent = (idx+1) + ' / ' + slides.length;
}

function nextSlide(){
  show((idx+1) % slides.length);
}

function clearTimers(){
  if (preloadTimeout) { clearTimeout(preloadTimeout); preloadTimeout = null; }
  if (showTimeout) { clearTimeout(showTimeout); showTimeout = null; }
}

// Agenda ciclo: pré-carrega PRELOAD_MS antes e mostra no fim do período DURATION
function startCycle(){
  clearTimers();
  // se PRELOAD_MS >= DURATION, pré-carrega imediatamente
  const preloadDelay = Math.max(0, DURATION - PRELOAD_MS);
  preloadTimeout = setTimeout(()=> {
    preloadNext();
  }, preloadDelay);

  showTimeout = setTimeout(()=> {
    nextSlide();
    // reinicia o ciclo (preload para o novo próximo)
    startCycle();
  }, DURATION);
}

// Inicialização
createSlides();
startCycle();

// Controles de teclado (manual)
window.addEventListener('keydown', (e)=>{
  if(e.key === 'ArrowRight'){
    clearTimers();
    nextSlide();
    startCycle();
  }
  if(e.key === 'ArrowLeft'){
    clearTimers();
    show((idx-1+slides.length)%slides.length);
    startCycle();
  }
  if(e.key === 'Escape'){
    window.close();
  }
});

// Hide cursor quando inativo
let idleTimer;
function resetCursorTimer(){
  document.body.classList.remove('hide-cursor');
  clearTimeout(idleTimer);
  idleTimer = setTimeout(()=>document.body.classList.add('hide-cursor'), 3000);
}
window.addEventListener('mousemove', resetCursorTimer);
window.addEventListener('touchstart', resetCursorTimer);
resetCursorTimer();
</script>
</body>
</html>
'@

$html = $htmlTemplate.Replace('__LINKS__', $linksJson)
Set-Content -Path $indexFile -Value $html -Encoding UTF8
Write-Host "Gerado $indexFile com $($rawLinks.Count) slides."

# Detecta navegadores conhecidos (Edge/Chrome/Brave/Firefox)
$browserCandidates = @(
    @{name='msedge'; paths=@("$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe","$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe")},
    @{name='chrome'; paths=@("$env:ProgramFiles\Google\Chrome\Application\chrome.exe","$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe")},
    @{name='brave'; paths=@("$env:ProgramFiles\BraveSoftware\Brave-Browser\Application\brave.exe","$env:ProgramFiles(x86)\BraveSoftware\Brave-Browser\Application\brave.exe")},
    @{name='firefox'; paths=@("$env:ProgramFiles\Mozilla Firefox\firefox.exe","$env:ProgramFiles(x86)\Mozilla Firefox\firefox.exe")}
)
$browserPath = $null
$browserName = $null
foreach ($b in $browserCandidates) {
    foreach ($p in $b.paths) {
        if (Test-Path $p) { $browserPath = $p; $browserName = $b.name; break }
    }
    if ($browserPath) { break }
}

if (-not $browserPath) {
    Write-Error "Nenhum navegador compatível encontrado (Edge/Chrome/Brave/Firefox). Instale um e execute novamente."
    exit 1
}

$fullPath = (Get-Item $indexFile).FullName
$fileUrl = 'file:///' + ($fullPath -replace '\\','/')

$safeDataDir = Join-Path $env:TEMP "powerbi_carousel_profile"
Switch ($browserName) {
    'msedge' { $args = @("--kiosk", "--kiosk-idle-timeout=0", "--no-first-run", "--disable-infobars", "--autoplay-policy=no-user-gesture-required", "--user-data-dir=$safeDataDir", $fileUrl) }
    'chrome'  { $args = @("--kiosk", "--no-first-run", "--disable-infobars", "--autoplay-policy=no-user-gesture-required", "--user-data-dir=$safeDataDir", $fileUrl) }
    'brave'   { $args = @("--kiosk", "--no-first-run", "--disable-infobars", "--autoplay-policy=no-user-gesture-required", "--user-data-dir=$safeDataDir", $fileUrl) }
    'firefox' { $args = @("--kiosk", $fileUrl) }
    default   { $args = @("--start-fullscreen", $fileUrl) }
}

Write-Host "Abrindo em modo tela-cheia com $browserName ($browserPath) ..."
Start-Process -FilePath $browserPath -ArgumentList $args

Write-Host "Dicas:"
Write-Host "- Para ajustar o tempo de pré-carregamento edite PRELOAD_MS no HTML gerado (em ms)."
Write-Host "- Para iniciar na inicialização crie um atalho para start-carousel.bat na pasta %APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
Write-Host "- Desative protetor de tela e suspensão (Configurações > Sistema > Energia e suspensão)"