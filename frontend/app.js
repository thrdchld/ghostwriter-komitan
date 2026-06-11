// ========================
// GhostWriter Komitan
// app.js
// ========================

document.addEventListener("DOMContentLoaded", () => {

    initNavigation();

    showPage("dashboard");

});


// ========================
// Navigation
// ========================

function initNavigation() {

    const buttons =
        document.querySelectorAll("[data-page]");

    buttons.forEach(button => {

        button.addEventListener("click", () => {

            const page =
                button.dataset.page;

            showPage(page);

        });

    });

}

function showPage(pageId) {

    const sections =
        document.querySelectorAll("main section");

    sections.forEach(section => {

        section.hidden = true;

    });

    const target =
        document.getElementById(pageId);

    if (target) {

        target.hidden = false;

    }

}


// ========================
// Status API
// ========================

async function getStatus() {

    try {

        const response =
            await fetch("/api/status");

        const data =
            await response.json();

        const settings =
            document.getElementById(
                "settings-content"
            );

        if (settings) {

            settings.innerHTML = `
                <pre>
${JSON.stringify(data, null, 2)}
                </pre>
            `;

        }

    } catch (error) {

        console.error(error);

    }

}


// ========================
// Chat Dummy
// ========================

async function sendChat() {

    const input =
        document.getElementById(
            "chat-input"
        );

    if (!input) return;

    const message =
        input.value.trim();

    if (!message) return;

    const history =
        document.getElementById(
            "chat-history"
        );

    history.innerHTML += `
        <p><b>Kamu:</b> ${message}</p>
    `;

    try {

        const response =
            await fetch("/api/chat", {

                method: "POST",

                headers: {
                    "Content-Type":
                        "application/json"
                },

                body: JSON.stringify({
                    message: message
                })

            });

        const data =
            await response.json();

        history.innerHTML += `
            <p><b>Komitan:</b> ${data.reply}</p>
        `;

        history.scrollTop =
            history.scrollHeight;

    } catch (error) {

        history.innerHTML += `
            <p><b>Error:</b> ${error}</p>
        `;

    }

    input.value = "";

}


// ========================
// Event Binding
// ========================

document.addEventListener(
    "click",
    (event) => {

        if (
            event.target.id ===
            "send-chat"
        ) {
            sendChat();
        }

        if (
            event.target.id ===
            "refresh-models"
        ) {

            alert(
                "Model Manager belum aktif"
            );

        }

        if (
            event.target.id ===
            "push-brain"
        ) {

            alert(
                "Push Brain belum aktif"
            );

        }

        if (
            event.target.id ===
            "pull-brain"
        ) {

            alert(
                "Pull Brain belum aktif"
            );

        }

    }
);


// ========================
// Auto Load
// ========================

window.addEventListener(
    "load",
    () => {

        getStatus();

    }
);
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
