# Python Project Template

This is a template for Python projects in the Boot.dev curriculum.

## Setup

1. Create a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```
   pip install -r requirements.txt
   pip install -r requirements-dev.txt
   ```

3. Run the application:
   ```
   python -m src.main
   ```

4. Run tests:
   ```
   pytest tests/
   ```

## Project Structure

- `src/`: Source code
- `tests/`: Test files
- `docs/`: Documentation
- `requirements.txt`: Production dependencies
- `requirements-dev.txt`: Development dependencies
EOF

# Create a directory for the JS/TS template
mkdir -p ~/Projects/bootdev/templates/js-ts-project

# Navigate to the JS/TS template directory
cd ~/Projects/bootdev/templates/js-ts-project

# Create project structure
mkdir -p src tests

# Create basic files
touch src/index.js
touch src/index.ts
touch tests/index.test.js
touch package.json
touch tsconfig.json
touch .eslintrc.json
touch README.md

# Create a .gitignore file
curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore
```