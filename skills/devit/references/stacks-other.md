# Devit — Stack Detection: Python, Go, Rust

> Loaded from `references/start.md` Step 2 only when the project's primary manifest isn't a Node/JS/TS `package.json`.

### Python
- Manifests: `pyproject.toml`, `setup.cfg`, `requirements.txt`, `Pipfile`
- Commands:
  - type-check → `mypy .` (if mypy in deps), else `pyright`
  - lint → `ruff check .` (if ruff in deps), else `flake8`
  - test → `pytest`
  - build → `python -m build` or project-specific
- Test placement: `tests/` or `test/` directory, files named `test_*.py` or `*_test.py`

### Go
- Manifest: `go.mod`
- Commands:
  - type-check → `go vet ./...`
  - lint → `golangci-lint run` (if present), else `go vet ./...`
  - test → `go test ./...`
  - build → `go build ./...`
- Test placement: co-located `*_test.go` files

### Rust
- Manifest: `Cargo.toml`
- Commands:
  - type-check → `cargo check`
  - lint → `cargo clippy`
  - test → `cargo test`
  - build → `cargo build`
- Test placement: inline `#[cfg(test)]` modules or `tests/` integration directory
