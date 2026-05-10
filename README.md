# 🐳 DockerMate

<div align="center">

```
 ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ ███╗   ███╗ █████╗ ████████╗███████╗
 ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██╔════╝
 ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝██╔████╔██║███████║   ██║   █████╗
 ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██╔══╝
 ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗
 ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
```

**A powerful, interactive Bash-based Docker management tool for the terminal.**

![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-blue?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-lightgrey?style=for-the-badge)

</div>

---

## 📖 Overview

**DockerMate** is a fully interactive, color-coded terminal UI for managing Docker — without memorizing commands. From spinning up containers to live stats monitoring, it puts the most common Docker workflows behind a clean, guided menu.

Designed for developers, DevOps engineers, and students who want speed, clarity, and a great terminal experience.

---

## ✨ Features

### 📦 Container Operations
| Option | Feature |
|--------|---------|
| `1` | List all containers (running & stopped) with stop prompt |
| `2` | Create & run a new container (with image pull, ports, volumes, env vars, restart policy) |
| `3` | Start a stopped container |
| `4` | Stop a running container |
| `5` | Restart any container |
| `6` | Remove a container (with force-remove support) |

### 📊 Monitoring & Inspection
| Option | Feature |
|--------|---------|
| `7` | Live CPU / Memory / Network stats (`docker stats`) |
| `8` | View container logs (tail mode + real-time follow) |
| `9` | Inspect a container — quick summary or full JSON |
| `10` | Open an interactive shell inside a container |

### 🖼️ Image Management
| Option | Feature |
|--------|---------|
| `11` | List all local Docker images |
| `12` | Pull any image from Docker Hub |
| `13` | Remove an image (with force-remove option) |

### 💾 Volumes & Networks
| Option | Feature |
|--------|---------|
| `14` | Create a Docker volume and attach it to a container |
| `15` | List all Docker networks |

### ⚙️ System Tools
| Option | Feature |
|--------|---------|
| `16` | Prune stopped containers, unused images, networks & volumes |
| `17` | Docker system info — disk usage, engine details |

---

## 🚀 Getting Started

### Prerequisites

- A Unix-like system: **Linux** or **macOS**
- **Docker** installed and the daemon running
- **Bash** 4.0 or higher

> No Docker? Run the script anyway — it auto-detects your OS and prints the right install command.

---

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/your-username/dockermate.git
cd dockermate
```

**2. Make the script executable**
```bash
chmod +x docker_manager.sh
```

**3. Run it**
```bash
./docker_manager.sh
```

That's it — no dependencies, no config files, no installs beyond Docker itself.

---

### Quick One-liner

```bash
git clone https://github.com/your-username/dockermate.git && cd dockermate && chmod +x docker_manager.sh && ./docker_manager.sh
```

---

## 🖥️ Usage Walkthrough

Once launched, you'll see the main menu with a live dashboard:

```
  Docker 27.x.x  │  3 running │ 5 total containers │ 12 images

  CONTAINER OPERATIONS
  [1]  📋  List Containers
  [2]  🚀  Create & Run New Container
  [3]  ▶️   Start a Stopped Container
  ...
  ➜ Choose an option:
```

Every action is guided with prompts — just answer and DockerMate handles the rest.

---

### Example: Creating a Container (Option 2)

```
  ➜ Container name (leave blank for auto): my-nginx
  ➜ Docker image (e.g. nginx:latest): nginx:latest
  ➜ Port mapping (e.g. 8080:80): 8080:80
  ➜ Volume mapping (leave blank to skip):
  ➜ Environment vars (leave blank to skip):
  ➜ Restart policy [1-4] (default: 1): 2
  ➜ Run in detached mode? (yes/no): yes

  ℹ Running: docker run --name my-nginx -p 8080:80 --restart always -d nginx:latest
  ✔ Container created successfully!
```

### Example: Exec into a Container (Option 10)

```
  ➜ Enter container name or ID: my-nginx
  ➜ Choose shell — [1] /bin/bash  [2] /bin/sh  [3] custom: 1

  ℹ Opening shell in 'my-nginx'... (type 'exit' to leave)
  root@a1b2c3d4:/# 
```

---

## 📁 Project Structure

```
dockermate/
├── docker_manager.sh   # Main script
├── README.md           # This file
└── LICENSE             # MIT License
```

---

## 🔧 Compatibility

| OS | Supported |
|----|-----------|
| Ubuntu / Debian | ✅ |
| Fedora / RHEL / CentOS | ✅ |
| Arch Linux | ✅ |
| macOS (with Docker Desktop) | ✅ |
| Windows (WSL2) | ✅ |
| Windows (native) | ❌ |

---

## 🛠️ Troubleshooting

**"Docker daemon is not running"**
```bash
sudo systemctl start docker
# On macOS: open Docker Desktop from Applications
```

**"Permission denied" when running the script**
```bash
chmod +x docker_manager.sh
```

**"Permission denied" when running Docker commands**
```bash
sudo usermod -aG docker $USER
# Then log out and log back in
```

**Script exits immediately / bad colors**
> Make sure you're using Bash 4+ and a terminal that supports ANSI colors (most modern terminals do).

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Commit** your changes: `git commit -m "Add: my new feature"`
4. **Push** to the branch: `git push origin feature/my-feature`
5. **Open a Pull Request**

### Ideas for contributions
- [ ] Docker Compose support
- [ ] Export container config to YAML
- [ ] Custom network creation
- [ ] Multi-container log viewer
- [ ] Health check monitoring

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙌 Acknowledgements

- [Docker Documentation](https://docs.docker.com/) — the official reference
- Inspired by the need to make Docker accessible without leaving the terminal

---

<div align="center">

Made with ❤️ and lots of `docker ps -a`

⭐ **Star this repo if you find it useful!** ⭐

</div>
