# Metavision SDK Apptainer


## Layout

* `metavision-sdk.def` — The build recipe. Read the comment header for full detail.
* `mv-sandbox/` — The built container (writable directory, not a `.sif`).
* `mv-shell.sh` — Interactive shell into the sandbox, X11-ready.
* `~/prophesee/py3venv`, `~/dev/venvs/...` — Python venvs (live on host, see below).

## Building 

You'll need a Prophesee/JFrog email + identity token at build time.

```bash
cat > jfrog.args <<EOF
JFROG_USER=you@example.com
JFROG_TOKEN=your_jfrog_identity_token
EOF
chmod 600 jfrog.args

sudo apptainer build --sandbox --build-arg-file jfrog.args mv-sandbox/ metavision-sdk.def

rm jfrog.args   
```

To add more system packages later without touching the JFrog repo again:
```bash
sudo apptainer shell --writable mv-sandbox/
# apt install whatever, then exit
```

To freeze the sandbox into a shareable, read-only image:
```bash
sudo apptainer build metavision-sdk.sif mv-sandbox/
```

## Running

**Interactive shell** (day-to-day dev — activate your venv, edit/run scripts,
browse host files):
```bash
./mv-shell.sh          # plain
./mv-shell.sh --nv     # with NVIDIA GPU passthrough
```
Your `$HOME`, current directory, `/dev` (camera), and `/tmp`/`DISPLAY` (X11)
are bound in automatically. Once inside, just run commands directly — no
`apptainer` prefix needed.

**One-off commands from the host, without an interactive shell:**
```bash
apptainer exec mv-sandbox/ metavision_platform_info
```

**Metavision Studio** :
```bash
apptainer run --bind /run/user/$(id -u) mv-sandbox/ metavision_studio
# or, from inside ./mv-shell.sh:
metavision_studio
```

## Python

The SDK's Python bindings only exist inside the container, so the venv must
be created from inside it, but it lives on host disk (under `$HOME`, which
is bind-mounted), so it persists independently of the sandbox.

```bash
apptainer exec mv-sandbox/ python3 -m venv ~/prophesee/py3venv --system-site-packages
```

```bash
./mv-shell.sh
source ~/prophesee/py3venv/bin/activate
export PYTHONNOUSERSITE=true
pip install -r /usr/share/metavision/python_requirements/requirements_openeb.txt
python -c "import metavision_core; print('ok')"
```


## Camera setup 

The apt packages do not install udev rules for the camera. Without them
the device node is root-owned and nothing (container or bare host) can open
it as a regular user.

```bash
sudo cp ~/metavision_driver/udev/rules.d/*.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Plug in the camera and confirm:
```bash
lsusb                     # look for Cypress FX3 (04b4), ST EVK2 (03fd), or CenturyArks (31f7)
ls -la /dev/bus/usb/*/*   # the camera's node should read crw-rw-rw-
```


