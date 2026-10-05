#!/bin/bash
# Se ejecuta automáticamente al crear el Codespace (versión Copilot, 2 tenants).

set -e
echo "=== Configurando el entorno del lab (Copilot) ==="

# --- 1. Instalar dtctl ---
echo "[1/4] Instalando dtctl..."
curl -fsSL https://raw.githubusercontent.com/dynatrace-oss/dtctl/main/install.sh | bash || echo "   (revisa dtctl manualmente si fallo)"
export PATH="$PATH:$HOME/.local/bin"

# --- 2. Instalar el skill de dtctl para Copilot ---
echo "[2/4] Instalando el skill de dtctl para Copilot..."
dtctl skills install --for copilot 2>/dev/null || echo "   (instala con: dtctl skills install --for copilot)"

# --- 3. Configurar dtctl (dos contextos: lab y playground) ---
echo "[3/4] Configurando dtctl..."
echo "export DTCTL_TOKEN_STORAGE=file" >> ~/.bashrc
export DTCTL_TOKEN_STORAGE=file

if [ -n "$DT_PLATFORM_TOKEN" ]; then
  dtctl config set-credentials lab-token --token "$DT_PLATFORM_TOKEN" 2>/dev/null
  dtctl config set-context astroshop \
    --environment "https://ulk04354.sprint.apps.dynatracelabs.com" \
    --token-ref lab-token 2>/dev/null
  echo "   contexto 'astroshop' (tenant del lab) configurado."
else
  echo "   AVISO: no se encontro DT_PLATFORM_TOKEN."
fi

if [ -n "$DT_PLAYGROUND_TOKEN" ]; then
  dtctl config set-credentials playground-token --token "$DT_PLAYGROUND_TOKEN" 2>/dev/null
  dtctl config set-context playground \
    --environment "https://wkf10640.apps.dynatrace.com" \
    --token-ref playground-token 2>/dev/null
  echo "   contexto 'playground' configurado."
else
  echo "   AVISO: no se encontro DT_PLAYGROUND_TOKEN."
fi

# Contexto activo por defecto: el del lab (Labs 2 y 3)
dtctl config use-context astroshop 2>/dev/null
echo "   contexto activo por defecto: astroshop."

# --- 4. Crear .vscode/mcp.json con los dos tokens de Dynatrace inyectados ---
echo "[4/4] Configurando los MCP de Dynatrace..."
mkdir -p .vscode
if [ -f "mcp-template.json" ]; then
  cp mcp-template.json .vscode/mcp.json
  if [ -n "$DT_PLAYGROUND_TOKEN" ]; then
    sed -i "s|TU_TOKEN_PLAYGROUND|${DT_PLAYGROUND_TOKEN}|g" .vscode/mcp.json
    echo "   Token de playground inyectado."
  fi
  if [ -n "$DT_PLATFORM_TOKEN" ]; then
    sed -i "s|TU_TOKEN_DYNATRACE|${DT_PLATFORM_TOKEN}|g" .vscode/mcp.json
    echo "   Token del lab inyectado."
  fi
else
  echo "   AVISO: no se encontro mcp-template.json."
fi

echo ""
echo "=========================================="
echo "  Entorno listo (Copilot)"
echo "=========================================="
echo "Faltan estos pasos:"
echo "  1. Copia tu instruction file:   cp INSTRUCCIONES-0X.md .github/copilot-instructions.md"
echo "  2. Pon tu token de GitHub en .vscode/mcp.json (reemplaza TU_TOKEN_GITHUB)"
echo "  3. Arranca el MCP que necesites: Ctrl+Shift+P > MCP: List Servers > Start"
echo "     - Lab 1: dynatrace-playground"
echo "     - Labs 2 y 3: dynatrace-lab"
echo "  4. Abre Copilot Chat en Agent mode"
echo ""
