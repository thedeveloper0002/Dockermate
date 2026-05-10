#!/bin/bash

# ============================================================
#   🐳 DockerMate - Docker Container Management Tool
#   Author  : [Your Name]
#   GitHub  : https://github.com/[your-username]/dockermate
#   Version : 2.0.0
#   License : MIT
# ============================================================

# ─── Colors & Styles ────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Symbols ────────────────────────────────────────────────
CHECK="${GREEN}✔${RESET}"
CROSS="${RED}✘${RESET}"
ARROW="${CYAN}➜${RESET}"
WARN="${YELLOW}⚠${RESET}"
INFO="${BLUE}ℹ${RESET}"
DOCKER="${CYAN}🐳${RESET}"

# ─── Utility Functions ──────────────────────────────────────

print_banner() {
    clear
    echo -e "${CYAN}"
    echo " ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ ███╗   ███╗ █████╗ ████████╗███████╗"
    echo " ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██╔════╝"
    echo " ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝██╔████╔██║███████║   ██║   █████╗  "
    echo " ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██╔══╝  "
    echo " ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ███████╗"
    echo " ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝"
    echo -e "${RESET}"
    echo -e "${DIM}         🐳  Docker Container Management Tool  |  v2.0.0${RESET}"
    echo -e "${DIM}  ──────────────────────────────────────────────────────────────────────────────${RESET}"
    echo ""
}

divider() {
    echo -e "${DIM}  ──────────────────────────────────────────────────────────────────────────────${RESET}"
}

section() {
    echo ""
    echo -e "${BOLD}${BLUE}  ● $1${RESET}"
    divider
}

success() { echo -e "  ${CHECK} ${GREEN}$1${RESET}"; }
error()   { echo -e "  ${CROSS} ${RED}$1${RESET}"; }
warn()    { echo -e "  ${WARN} ${YELLOW}$1${RESET}"; }
info()    { echo -e "  ${INFO} ${CYAN}$1${RESET}"; }
prompt()  { echo -ne "  ${ARROW} ${WHITE}$1${RESET} "; }

pause() {
    echo ""
    echo -ne "  ${DIM}Press [Enter] to return to the menu...${RESET}"
    read -r
}

confirm() {
    prompt "$1 (yes/no):"
    read -r ans
    [[ "$ans" == "yes" ]]
}

# ─── Docker Check ───────────────────────────────────────────

check_docker() {
    if ! command -v docker &>/dev/null; then
        error "Docker is not installed on this system."
        echo ""
        detect_os_and_suggest_install
        exit 1
    fi

    if ! docker info &>/dev/null; then
        error "Docker daemon is not running. Please start Docker first."
        echo ""
        info "Try: sudo systemctl start docker"
        exit 1
    fi
}

detect_os_and_suggest_install() {
    info "Detecting operating system..."
    OS=$(uname -s)
    case "$OS" in
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                echo -e "  ${ARROW} Detected: ${BOLD}$NAME${RESET}"
                case "$ID" in
                    ubuntu|debian)
                        echo -e "\n  ${YELLOW}Install Docker on $NAME:${RESET}"
                        echo -e "  ${DIM}sudo apt update && sudo apt install -y docker.io${RESET}"
                        ;;
                    centos|rhel|fedora)
                        echo -e "\n  ${YELLOW}Install Docker on $NAME:${RESET}"
                        echo -e "  ${DIM}sudo dnf install -y docker && sudo systemctl start docker${RESET}"
                        ;;
                    arch)
                        echo -e "\n  ${YELLOW}Install Docker on $NAME:${RESET}"
                        echo -e "  ${DIM}sudo pacman -S docker${RESET}"
                        ;;
                    *)
                        warn "Unknown distro. Visit: https://docs.docker.com/engine/install/"
                        ;;
                esac
            fi
            ;;
        Darwin)
            echo -e "  ${ARROW} Detected: ${BOLD}macOS${RESET}"
            echo -e "\n  ${YELLOW}Install Docker on macOS:${RESET}"
            echo -e "  ${DIM}brew install --cask docker${RESET}"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo -e "  ${ARROW} Detected: ${BOLD}Windows${RESET}"
            echo -e "\n  ${YELLOW}Download Docker Desktop:${RESET}"
            echo -e "  ${DIM}https://www.docker.com/products/docker-desktop${RESET}"
            ;;
        *)
            warn "Unsupported OS. Visit: https://docs.docker.com/engine/install/"
            ;;
    esac
}

# ─── Main Menu ──────────────────────────────────────────────

show_menu() {
    print_banner

    DOCKER_VER=$(docker --version 2>/dev/null | awk '{print $3}' | tr -d ',')
    RUNNING=$(docker ps -q | wc -l | tr -d ' ')
    TOTAL=$(docker ps -aq | wc -l | tr -d ' ')
    IMAGES=$(docker images -q | wc -l | tr -d ' ')

    echo -e "  ${DIM}Docker $DOCKER_VER  │  ${GREEN}$RUNNING running${RESET} ${DIM}│ $TOTAL total containers │ $IMAGES images${RESET}"
    echo ""
    echo -e "  ${BOLD}${WHITE}CONTAINER OPERATIONS${RESET}"
    echo -e "  ${CYAN}[1]${RESET}  📋  List Containers"
    echo -e "  ${CYAN}[2]${RESET}  🚀  Create & Run New Container"
    echo -e "  ${CYAN}[3]${RESET}  ▶️   Start a Stopped Container"
    echo -e "  ${CYAN}[4]${RESET}  ⏹️   Stop a Running Container"
    echo -e "  ${CYAN}[5]${RESET}  🔁  Restart a Container"
    echo -e "  ${CYAN}[6]${RESET}  🗑️   Remove a Container"
    echo ""
    echo -e "  ${BOLD}${WHITE}MONITORING & INFO${RESET}"
    echo -e "  ${CYAN}[7]${RESET}  📊  Container Stats (Live)"
    echo -e "  ${CYAN}[8]${RESET}  📜  View Container Logs"
    echo -e "  ${CYAN}[9]${RESET}  🔍  Inspect a Container"
    echo -e "  ${CYAN}[10]${RESET} 💻  Exec into Container (Shell)"
    echo ""
    echo -e "  ${BOLD}${WHITE}IMAGE MANAGEMENT${RESET}"
    echo -e "  ${CYAN}[11]${RESET} 🖼️   List All Images"
    echo -e "  ${CYAN}[12]${RESET} ⬇️   Pull an Image"
    echo -e "  ${CYAN}[13]${RESET} 🗑️   Remove an Image"
    echo ""
    echo -e "  ${BOLD}${WHITE}VOLUMES & NETWORKS${RESET}"
    echo -e "  ${CYAN}[14]${RESET} 💾  Create & Attach Volume"
    echo -e "  ${CYAN}[15]${RESET} 🌐  List Networks"
    echo ""
    echo -e "  ${BOLD}${WHITE}SYSTEM${RESET}"
    echo -e "  ${CYAN}[16]${RESET} 🧹  Cleanup (Prune Resources)"
    echo -e "  ${CYAN}[17]${RESET} 📈  Docker System Info"
    echo -e "  ${RED}[0]${RESET}  🚪  Exit"
    echo ""
    divider
    prompt "Choose an option:"
}

# ─── Container Operations ───────────────────────────────────

list_containers() {
    section "Container List"

    echo -e "  ${BOLD}Running Containers:${RESET}"
    echo ""
    docker ps --format "  ${GREEN}●${RESET} {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | column -t
    echo ""

    if confirm "Show all containers including stopped?"; then
        echo ""
        echo -e "  ${BOLD}All Containers:${RESET}"
        echo ""
        docker ps -a --format "  {{if eq .State \"running\"}}${GREEN}●${RESET}{{else}}${RED}●${RESET}{{end}} {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | column -t
    fi

    pause
}

create_new_container() {
    section "Create New Container"

    prompt "Container name (leave blank for auto):"
    read -r container_name

    prompt "Docker image (e.g. nginx:latest):"
    read -r image_name
    if [ -z "$image_name" ]; then
        error "Image name is required."
        pause; return
    fi

    # Check if image exists locally, offer to pull
    if ! docker image inspect "$image_name" &>/dev/null; then
        warn "Image '$image_name' not found locally."
        if confirm "Pull it from Docker Hub?"; then
            echo ""
            docker pull "$image_name"
            [ $? -ne 0 ] && error "Failed to pull image." && pause && return
        fi
    fi

    prompt "Port mapping (e.g. 8080:80, leave blank to skip):"
    read -r port_mapping

    prompt "Volume mapping (e.g. my_vol:/app, leave blank to skip):"
    read -r volume_mapping

    prompt "Environment vars (e.g. KEY=val KEY2=val2, leave blank to skip):"
    read -ra env_vars

    echo -e "  ${ARROW} ${WHITE}Restart policy:${RESET}"
    echo -e "    ${DIM}[1] no  [2] always  [3] unless-stopped  [4] on-failure${RESET}"
    prompt "Choice [1-4] (default: 1):"
    read -r rp_choice
    case "$rp_choice" in
        2) restart_policy="always" ;;
        3) restart_policy="unless-stopped" ;;
        4) restart_policy="on-failure" ;;
        *) restart_policy="no" ;;
    esac

    if confirm "Run in detached mode (background)?"; then
        detach_flag="-d"
    else
        detach_flag="-it"
    fi

    # Build command
    cmd="docker run"
    [ -n "$container_name" ]  && cmd+=" --name $container_name"
    [ -n "$port_mapping" ]    && cmd+=" -p $port_mapping"
    [ -n "$volume_mapping" ]  && cmd+=" -v $volume_mapping"
    for ev in "${env_vars[@]}"; do
        cmd+=" -e $ev"
    done
    cmd+=" --restart $restart_policy $detach_flag $image_name"

    echo ""
    info "Running: ${DIM}$cmd${RESET}"
    echo ""

    eval "$cmd"
    [ $? -eq 0 ] && success "Container created successfully!" || error "Failed to create container."
    pause
}

start_container() {
    section "Start Stopped Container"

    echo -e "  ${BOLD}Stopped Containers:${RESET}"
    echo ""
    docker ps -a --filter "status=exited" --filter "status=created" \
        --format "  ${RED}●${RESET} {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    docker start "$cname" &>/dev/null
    [ $? -eq 0 ] && success "Container '$cname' started!" || error "Failed to start container '$cname'."
    pause
}

stop_container() {
    section "Stop Running Container"

    echo -e "  ${BOLD}Running Containers:${RESET}"
    echo ""
    docker ps --format "  ${GREEN}●${RESET} {{.ID}}\t{{.Names}}\t{{.Image}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    docker stop "$cname" &>/dev/null
    [ $? -eq 0 ] && success "Container '$cname' stopped." || error "Failed to stop container '$cname'."
    pause
}

restart_container() {
    section "Restart Container"

    docker ps -a --format "  ${CYAN}●${RESET} {{.ID}}\t{{.Names}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    docker restart "$cname" &>/dev/null
    [ $? -eq 0 ] && success "Container '$cname' restarted." || error "Failed to restart container '$cname'."
    pause
}

remove_container() {
    section "Remove Container"

    docker ps -a --format "  ${RED}●${RESET} {{.ID}}\t{{.Names}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    # Check if running
    if docker ps -q --filter "name=$cname" | grep -q .; then
        warn "Container is running."
        confirm "Force remove?" || { pause; return; }
        docker rm -f "$cname" &>/dev/null
    else
        docker rm "$cname" &>/dev/null
    fi

    [ $? -eq 0 ] && success "Container '$cname' removed." || error "Failed to remove container '$cname'."
    pause
}

# ─── Monitoring ─────────────────────────────────────────────

container_stats() {
    section "Live Container Stats"
    info "Press Ctrl+C to exit stats view."
    echo ""
    docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    pause
}

view_logs() {
    section "Container Logs"

    docker ps -a --format "  ${CYAN}●${RESET} {{.Names}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    prompt "Number of lines to show (default: 50):"
    read -r lines
    lines=${lines:-50}

    if confirm "Follow logs in real-time? (Ctrl+C to stop)"; then
        docker logs --tail "$lines" -f "$cname"
    else
        docker logs --tail "$lines" "$cname" 2>&1 | less
    fi
    pause
}

inspect_container() {
    section "Inspect Container"

    docker ps -a --format "  ${CYAN}●${RESET} {{.Names}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    echo ""
    echo -e "  ${BOLD}Quick Info:${RESET}"
    echo ""
    docker inspect "$cname" --format "
  Name     : {{.Name}}
  Image    : {{.Config.Image}}
  Status   : {{.State.Status}}
  Started  : {{.State.StartedAt}}
  IP Addr  : {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}
  Ports    : {{range \$p, \$c := .NetworkSettings.Ports}}{{if \$c}}{{(index \$c 0).HostPort}}->{{end}}{{end}}
  Restart  : {{.HostConfig.RestartPolicy.Name}}" 2>/dev/null

    echo ""
    if confirm "View full JSON inspect output?"; then
        docker inspect "$cname" | less
    fi
    pause
}

exec_container() {
    section "Exec Into Container"

    echo -e "  ${BOLD}Running Containers:${RESET}"
    docker ps --format "  ${GREEN}●${RESET} {{.Names}}\t{{.Image}}" | column -t
    echo ""

    prompt "Enter container name or ID:"
    read -r cname
    [ -z "$cname" ] && error "No container specified." && pause && return

    echo -e "  ${ARROW} ${WHITE}Choose shell:${RESET}"
    echo -e "    ${DIM}[1] /bin/bash  [2] /bin/sh  [3] custom${RESET}"
    prompt "Choice [1-3] (default: 2):"
    read -r sh_choice

    case "$sh_choice" in
        1) shell="/bin/bash" ;;
        3)
            prompt "Enter shell path:"
            read -r shell
            ;;
        *) shell="/bin/sh" ;;
    esac

    info "Opening shell in '$cname'... (type 'exit' to leave)"
    echo ""
    docker exec -it "$cname" "$shell"
    pause
}

# ─── Image Management ───────────────────────────────────────

list_images() {
    section "Docker Images"
    echo ""
    docker images --format "  {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedSince}}" | \
        column -t -N "  REPOSITORY,TAG,IMAGE ID,SIZE,CREATED"
    pause
}

pull_image() {
    section "Pull Docker Image"

    prompt "Enter image name (e.g. ubuntu:22.04):"
    read -r img
    [ -z "$img" ] && error "Image name required." && pause && return

    echo ""
    docker pull "$img"
    [ $? -eq 0 ] && success "Image '$img' pulled successfully." || error "Failed to pull '$img'."
    pause
}

remove_image() {
    section "Remove Docker Image"

    docker images --format "  {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}" | column -t
    echo ""

    prompt "Enter image name or ID:"
    read -r img
    [ -z "$img" ] && error "Image not specified." && pause && return

    if confirm "Force remove (even if used by stopped containers)?"; then
        docker rmi -f "$img"
    else
        docker rmi "$img"
    fi
    [ $? -eq 0 ] && success "Image '$img' removed." || error "Failed to remove '$img'."
    pause
}

# ─── Volumes & Networks ─────────────────────────────────────

create_and_attach_volume() {
    section "Create & Attach Volume"

    prompt "Enter a name for the new volume:"
    read -r volume_name
    [ -z "$volume_name" ] && error "Volume name required." && pause && return

    docker volume create "$volume_name" &>/dev/null
    [ $? -ne 0 ] && error "Failed to create volume '$volume_name'." && pause && return
    success "Volume '$volume_name' created."

    echo ""
    echo -e "  ${BOLD}Available Containers:${RESET}"
    docker ps -a --format "  {{.Names}}\t{{.Status}}" | column -t
    echo ""

    prompt "Enter container name or ID to attach volume:"
    read -r cname
    if ! docker inspect "$cname" &>/dev/null; then
        error "Container '$cname' not found."
        pause; return
    fi

    prompt "Mount point inside container (e.g. /app/data):"
    read -r mount_point
    [ -z "$mount_point" ] && error "Mount point required." && pause && return

    warn "Container will be stopped and recreated to attach the volume."
    confirm "Proceed?" || { pause; return; }

    img=$(docker inspect --format='{{.Config.Image}}' "$cname")
    docker stop "$cname" &>/dev/null
    docker rm "$cname" &>/dev/null
    docker run -d --name "$cname" --mount source="$volume_name",target="$mount_point" "$img"

    [ $? -eq 0 ] \
        && success "Volume '$volume_name' attached to '$cname' at '$mount_point'." \
        || error "Failed to rerun container with volume."
    pause
}

list_networks() {
    section "Docker Networks"
    echo ""
    docker network ls --format "  {{.ID}}\t{{.Name}}\t{{.Driver}}\t{{.Scope}}" | \
        column -t -N "  ID,NAME,DRIVER,SCOPE"
    pause
}

# ─── System ─────────────────────────────────────────────────

cleanup() {
    section "Cleanup Docker Resources"

    echo -e "  ${YELLOW}This will prune:${RESET}"
    echo -e "  ${DIM}  • All stopped containers"
    echo -e "  • All dangling images"
    echo -e "  • All unused networks"
    echo -e "  • All unused volumes${RESET}"
    echo ""

    confirm "Are you sure you want to continue?" || { pause; return; }

    echo ""
    info "Removing stopped containers..."
    docker container prune -f

    info "Removing dangling images..."
    docker image prune -f

    if confirm "Remove ALL unused images (not just dangling)?"; then
        docker image prune -af
    fi

    info "Removing unused networks..."
    docker network prune -f

    info "Removing unused volumes..."
    docker volume prune -f

    echo ""
    success "Docker cleanup complete!"
    pause
}

system_info() {
    section "Docker System Info"
    echo ""
    docker system df
    echo ""
    docker info 2>/dev/null | grep -E "Containers:|Running:|Paused:|Stopped:|Images:|Server Version:|Operating System:|Total Memory:"
    pause
}

# ─── Entry Point ────────────────────────────────────────────

check_docker

while true; do
    show_menu
    read -r choice

    case "$choice" in
        1)  list_containers ;;
        2)  create_new_container ;;
        3)  start_container ;;
        4)  stop_container ;;
        5)  restart_container ;;
        6)  remove_container ;;
        7)  container_stats ;;
        8)  view_logs ;;
        9)  inspect_container ;;
        10) exec_container ;;
        11) list_images ;;
        12) pull_image ;;
        13) remove_image ;;
        14) create_and_attach_volume ;;
        15) list_networks ;;
        16) cleanup ;;
        17) system_info ;;
        0)
            echo ""
            echo -e "  ${CYAN}Thanks for using DockerMate. Goodbye! 🐳${RESET}"
            echo ""
            exit 0
            ;;
        *)
            warn "Invalid option. Please choose from the menu."
            sleep 1
            ;;
    esac
done
