# MLOps Project 1

End-to-end ML pipeline with data ingestion, preprocessing, model training, and
a Flask web app for inference.

## Project layout

- `application.py` - Flask app entrypoint.
- `pipeline/` - Training pipeline orchestration.
- `src/` - Core ML components (ingestion, preprocessing, training, utils).
- `config/` - Configuration files and paths.
- `templates/`, `static/` - Flask UI assets.
- `custom_jenkins/` - Jenkins Docker image build context.

## Setup

```
python -m venv venv
venv\Scripts\activate
pip install -e .
```

## Run the training pipeline

```
python pipeline/training_pipeline.py
```

## Run the web app

```
python application.py
```

App runs at `http://localhost:5000`.

## Docker

The Docker image builds the app and runs the training pipeline during the build
step.

```
docker build -t mlops-project .
docker run -p 5000:5000 mlops-project
```

## CI/CD

`Jenkinsfile` sets up a Python venv, installs the package, then builds and
pushes a Docker image to Google Artifact Registry.
