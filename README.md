# Boot.dev Development Environment Setup Guide

This guide documents the complete development environment setup for the Boot.dev curriculum, using a hybrid approach with local installations and Docker containers.

## Table of Contents

1. [Environment Overview](#environment-overview)
2. [Local Development Setup](#local-development-setup)
3. [Docker-Based Services](#docker-based-services)
4. [Project Templates](#project-templates)
5. [Helper Scripts and Aliases](#helper-scripts-and-aliases)
6. [Workflow Guide](#workflow-guide)

## Environment Overview

This setup uses a hybrid approach that provides:

- **Local language installations** for Python, C, JavaScript/TypeScript, and Go
- **Docker containers** for databases, Linux practice, and web servers
- **Project templates** for quickly starting new projects
- **Helper scripts and aliases** for streamlining common tasks

### Prerequisites

- macOS with Homebrew installed
- Docker Desktop
- Cursor editor
- iTerm2 with zsh and Oh My Zsh

## Local Development Setup

### Python Setup

Python is installed using pyenv for version management and equipped with virtual environment tools:

```bash
# Install pyenv and configure
brew install pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc

# Install Python 3.11
pyenv install 3.11
pyenv global 3.11

# Set up tools for Python virtual environments
brew install pipx
pipx ensurepath
pipx install virtualenv
pipx install virtualenvwrapper

# Configure virtualenvwrapper
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export VIRTUALENVWRAPPER_PYTHON=$(which python3)' >> ~/.zshrc
echo 'source $(which virtualenvwrapper.sh)' >> ~/.zshrc
source ~/.zshrc
```

**Usage:**
- Create a new virtual environment: `mkvirtualenv myproject`
- Activate a virtual environment: `workon myproject`
- Deactivate a virtual environment: `deactivate`

### C Language Setup

C development tools are installed for memory management learning:

```bash
# Install gcc compiler and tools
brew install gcc
brew install gdb
brew install --HEAD valgrind
```

**Usage:**
- Compile a C program: `gcc -Wall -g myprogram.c -o myprogram`
- Run with memory leak detection: `valgrind --leak-check=full ./myprogram`

### JavaScript/TypeScript Setup

Node.js with version management using nvm:

```bash
# Install Node.js with nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
source ~/.zshrc

# Install latest LTS version of Node.js
nvm install --lts

# Install TypeScript globally
npm install -g typescript
```

**Usage:**
- Install different Node.js version: `nvm install 16`
- Switch Node.js version: `nvm use 18`
- Compile TypeScript: `tsc myfile.ts`

### Go (Golang) Setup

Go installation for backend development:

```bash
# Install Go
brew install go

# Add Go paths
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
source ~/.zshrc
```

**Usage:**
- Run a Go program: `go run main.go`
- Build a Go program: `go build main.go`

### Git Configuration

Git configuration for version control:

```bash
# Configure Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main

# Set up useful Git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

## Docker-Based Services

### Directory Structure

```
/Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/
├── databases/
│   └── docker-compose.yml
├── linux-playground/
│   └── docker-compose.yml
└── servers/
    ├── nginx/
    │   ├── html/
    │   └── conf/
    ├── node-server/
    │   ├── package.json
    │   ├── server.js
    │   └── Dockerfile
    └── docker-compose.yml
```

### Database Services

The `databases/docker-compose.yml` file sets up PostgreSQL, MySQL, and Adminer:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: bootdev-postgres
    environment:
      POSTGRES_USER: bootdev
      POSTGRES_PASSWORD: bootdev
      POSTGRES_DB: bootdevdb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
    networks:
      - bootdev-net

  mysql:
    image: mysql:8
    container_name: bootdev-mysql
    environment:
      MYSQL_ROOT_PASSWORD: bootdev
      MYSQL_DATABASE: bootdevdb
      MYSQL_USER: bootdev
      MYSQL_PASSWORD: bootdev
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped
    networks:
      - bootdev-net
    command: --default-authentication-plugin=mysql_native_password

  adminer:
    image: adminer:latest
    container_name: bootdev-adminer
    ports:
      - "8080:8080"
    networks:
      - bootdev-net
    restart: unless-stopped
    depends_on:
      - postgres
      - mysql

networks:
  bootdev-net:
    driver: bridge

volumes:
  postgres_data:
  mysql_data:
```

**Starting Database Services:**
```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/databases
docker-compose up -d
```

Or using the alias:
```bash
bootdev-db-start
```

**Connecting to Databases:**
- PostgreSQL: `docker exec -it bootdev-postgres psql -U bootdev -d bootdevdb`
- MySQL: `docker exec -it bootdev-mysql mysql -u bootdev -pbootdev bootdevdb`
- Adminer Web Interface: http://localhost:8080
  - System: PostgreSQL/MySQL
  - Server: bootdev-postgres/bootdev-mysql
  - Username: bootdev
  - Password: bootdev
  - Database: bootdevdb

### Linux Environment

The `linux-playground/docker-compose.yml` file sets up Linux containers for practice:

```yaml
version: '3.8'

services:
  ubuntu:
    image: ubuntu:latest
    container_name: bootdev-ubuntu
    stdin_open: true
    tty: true
    volumes:
      - ./shared:/shared
    command: /bin/bash

  alpine:
    image: alpine:latest
    container_name: bootdev-alpine
    stdin_open: true
    tty: true
    volumes:
      - ./shared:/shared
    command: /bin/sh
```

**Starting Linux Containers:**
```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/linux-playground
docker-compose up -d
```

Or using the alias:
```bash
bootdev-linux-start
```

**Connecting to Linux Containers:**
- Ubuntu: `docker exec -it bootdev-ubuntu bash`
- Alpine: `docker exec -it bootdev-alpine sh`

### Web Server Environment

The `servers/docker-compose.yml` file sets up Nginx and Node.js servers:

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:latest
    container_name: bootdev-nginx
    ports:
      - "8081:80"
    volumes:
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/conf:/etc/nginx/conf.d
    restart: unless-stopped
    networks:
      - bootdev-net

  node-server:
    build:
      context: ./node-server
      dockerfile: Dockerfile
    container_name: bootdev-node
    ports:
      - "3000:3000"
    volumes:
      - ./node-server:/app
      - /app/node_modules
    restart: unless-stopped
    networks:
      - bootdev-net

networks:
  bootdev-net:
    driver: bridge
```

**Starting Web Servers:**
```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/servers
docker-compose up -d
```

Or using the alias:
```bash
bootdev-servers-start
```

**Accessing Web Servers:**
- Nginx: http://localhost:8081
- Node.js: http://localhost:3000

## Project Templates

### Directory Structure

```
/Users/okkystafford/Documents/repositories/Boot.dev/templates/
├── python-project/
│   ├── src/
│   ├── tests/
│   ├── docs/
│   ├── requirements.txt
│   └── requirements-dev.txt
├── js-ts-project/
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── tsconfig.json
└── c-project/
    ├── src/
    ├── include/
    ├── tests/
    └── Makefile
```

### Initializing a New Project

Use the initialization script to create a new project based on a template:

```bash
# Syntax
bootdev-init <project-name> <template-type>

# Examples
bootdev-init my-python-app python
bootdev-init js-calculator js-ts
bootdev-init memory-manager c
```

The script will:
1. Create a new project directory
2. Copy template files
3. Initialize a Git repository
4. Set up the development environment based on the template type

### Python Project Usage

After initializing a Python project:

```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/my-python-app
source venv/bin/activate
python -m src.main      # Run the application
pytest tests/           # Run tests
```

### JavaScript/TypeScript Project Usage

After initializing a JS/TS project:

```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/js-calculator
npm install
npm start               # Run JavaScript version
npm run build           # Build TypeScript version
npm test                # Run tests
```

### C Project Usage

After initializing a C project:

```bash
cd /Users/okkystafford/Documents/repositories/Boot.dev/memory-manager
make                    # Compile the project
make run                # Run the application
make test               # Run tests
valgrind --leak-check=full ./build/main  # Check for memory leaks
```

## Helper Scripts and Aliases

The environment includes several helper scripts and aliases to streamline common tasks.

### Available Commands

| Command | Description |
|---------|-------------|
| `bootdev` | Go to main BootDev directory |
| `bootdev-templates` | Go to templates directory |
| `bootdev-docker` | Go to Docker configurations directory |
| `bootdev-db-start` | Start database containers |
| `bootdev-linux-start` | Start Linux playground containers |
| `bootdev-servers-start` | Start web server containers |
| `bootdev-ubuntu` | Connect to Ubuntu container |
| `bootdev-alpine` | Connect to Alpine container |
| `bootdev-init` | Initialize new project (args: name, type) |
| `bootdev-venv` | Activate Python virtual environment in current directory |
| `pg-connect` | Connect to PostgreSQL |
| `mysql-connect` | Connect to MySQL |
| `bootdev-help` | Show all available commands |

These aliases are defined in `~/.bootdev_aliases.zsh` and loaded automatically when you open a new terminal.

## Workflow Guide

### Typical Python Development Workflow

1. Initialize a project: `bootdev-init my-python-app python`
2. Navigate to the project: `cd /Users/okkystafford/Documents/repositories/Boot.dev/my-python-app`
3. Activate the virtual environment: `source venv/bin/activate`
4. Edit code in Cursor
5. Run the application: `python -m src.main`
6. Run tests: `pytest tests/`
7. Commit changes: `git add . && git commit -m "Description of changes"`

### Typical Database Workflow

1. Start database containers: `bootdev-db-start`
2. Access Adminer web interface: http://localhost:8080
3. Create tables and insert data through Adminer
4. Connect to PostgreSQL for direct SQL: `pg-connect`
5. Execute SQL commands
6. Exit the database connection: `\q` (PostgreSQL) or `exit` (MySQL)

### Typical Linux Practice Workflow

1. Start Linux containers: `bootdev-linux-start`
2. Connect to Ubuntu container: `bootdev-ubuntu`
3. Practice Linux commands
4. Exit the container: `exit`

### Typical Web Server Development Workflow

1. Start web servers: `bootdev-servers-start`
2. Edit files in `/Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/servers/nginx/html/` or `/Users/okkystafford/Documents/repositories/Boot.dev/docker-configs/servers/node-server/`
3. Access nginx server: http://localhost:8081
4. Access Node.js server: http://localhost:3000
5. View logs: `docker logs bootdev-nginx` or `docker logs bootdev-node`

## Maintenance

### Updating Software

- Python packages: `pip install --upgrade <package>`
- Node.js packages: `npm update`
- Docker images: `docker-compose pull` in the respective directory

### Cleanup

- Remove stopped containers: `docker container prune`
- Remove unused images: `docker image prune`
- Remove unused volumes: `docker volume prune`

---

This development environment is designed to support all aspects of the Boot.dev curriculum, providing a balance between local development convenience and containerized service isolation.