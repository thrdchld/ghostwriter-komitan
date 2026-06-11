#!/usr/bin/env bash

set -e

echo "========================================="
echo "GhostWriter Komitan - Model Manager"
echo "========================================="

echo "[1/3] Patch app.py"

grep -q '/api/models' app.py || cat >> app.py <<'EOF'

import json

@app.get("/api/models")
def get_models():

```
try:

    with open(
        "models.json",
        "r",
        encoding="utf-8"
    ) as f:

        models = json.load(f)

    return {
        "success": True,
        "models": models
    }

except Exception as e:

    return {
        "success": False,
        "error": str(e)
    }
```

EOF

echo "[2/3] Patch frontend/app.js"

grep -q 'loadModels()' frontend/app.js || cat >> frontend/app.js <<'EOF'

async function loadModels() {

```
try {

    const response =
        await fetch("/api/models");

    const data =
        await response.json();

    const container =
        document.getElementById(
            "installed-models"
        );

    if (!container) return;

    if (!data.success) {

        container.innerHTML =
            data.error;

        return;

    }

    let html = "";

    data.models.forEach(model => {

        html += `
        <div style="
            border:1px solid #444;
            padding:12px;
            margin-bottom:10px;
            border-radius:10px;
        ">

            <h3>${model.name}</h3>

            <p>${model.repo}</p>

            <button>
                Load
            </button>

        </div>
        `;

    });

    container.innerHTML = html;

} catch(error) {

    console.error(error);

}
```

}

window.addEventListener(
"load",
() => {

```
    loadModels();

}
```

);
EOF

echo "[3/3] Pastikan models.json ada"

if [ ! -f models.json ]; then

cat > models.json <<'EOF'
[
{
"name":"Qwen3 4B",
"repo":"unsloth/Qwen3-4B-GGUF",
"file":"Qwen3-4B-Q4_K_M.gguf"
},
{
"name":"Qwen3 8B",
"repo":"unsloth/Qwen3-8B-GGUF",
"file":"Qwen3-8B-Q4_K_M.gguf"
}
]
EOF

fi

echo ""
echo "========================================="
echo "SELESAI"
echo "========================================="
echo ""
echo "Lanjutkan:"
echo ""
echo "git add ."
echo "git commit -m 'Add model manager'"
echo "git push"
echo ""
