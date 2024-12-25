from setuptools import setup, find_packages

setup(
    name="eswatini-cdi-automation",
    version="0.1.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=[
        "requests",
        "pandas",
        "schedule",
    ],
    entry_points={
        "console_scripts": [
            "run-job=my-python-project.src.main:main",
        ],
    },
    author="Akvo Foundation",
    author_email="tech.consultancy@akvo.org",
    description=(
        "A project to handle cronjobs for data processing and uploading CDI"
    ),
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    url="https://github.com/akvo/cdi-scripts",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.6",
)
