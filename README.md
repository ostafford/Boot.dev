# Boot.dev Learning Environment

This repository contains my software engineering learning projects and environment setup.

## Environment Structure

- `python/`: Python projects and tools
- `go/`: Go projects and tools
- `c/`: C language projects
- `javascript/`: JavaScript/TypeScript projects
- `web/`: Web development projects
- `docker-services/`: Containerized development services
- `hybrid-examples/`: Example projects using both local and containerized development

## Development Workflows

### Python Development

#### Local Development:
```bash
# Create a new project
mkdir -p python/my-project
cd python/my-project

# Set up virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the project
python -m src.main
