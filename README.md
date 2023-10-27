# About The Project

[![e2e-tests](https://github.com/BrunoFBarbosa/robot-framework-playwright/actions/workflows/webtesting-workflow.yml/badge.svg)](https://github.com/BrunoFBarbosa/robot-framework-playwright/actions/workflows/webtesting-workflow.yml)

A web automation framework to learn about the integration of Robot Framework 🤖 , Playwright 🎭 and Github Actions ✔ in order to consolidate the knowledge from the course [Robot Framework With Playwright And Github Actions](https://www.udemy.com/course/robot-framework-com-playwright-e-github-actions/). The application under test is https://front.serverest.dev/

# Main Topics Covered In This Project

- Web elements interactions using the Browser (Playwright) Library
- Playwright Trace viewer and Record Video features
- HTTP requests
- Context Storages
- Multiple browsers support using Github Actions

## Getting Started

### Prerequisites
- Python 3.10.6
- PIP 22.2.1
- Node v19.1.0

### Installation
1. Clone the repo
```
git clone https://github.com/BrunoFBarbosa/robot-framework-playwright.git
```
2. Navigate to the project's folder and install the dependencies
```
cd robot-framework-playwright/
pip install -U -r requirements.txt
sudo npm install @playwright/test
sudo npx playwright install-deps
rfbrowser init
```

### Running The Tests Locally
In order to run the tests you can use the `robot` command

Examples:

1. Running all the tests in the `tests` folder with a headless Chromium browser and storing the results in the `results` folder:
```
robot -d ./results -v HEADLESS:true -v BROWSER:chromium tests
```

2. Running a specific test with the `login` tag against a firefox browser:
```
robot -d ./results -v HEADLESS:true -v BROWSER:firefox -i login tests
```

### Github Actions

This project contains 3 workflows used for a simple CI service, they can be found at [workflows](https://github.com/BrunoFBarbosa/robot-framework-playwright/tree/main/.github/workflows)

#### 1. **webtesting-workflow.yml**

The main workflow used whenever there is a push action to the repo.
It uses a matrix strategy to run all tests against the 3 major web browsers (Chromium, Firefox and Webkit). The `fail-fast` property is set to `false` in order to the test to continue even if it fails on a specific browser, i.e 
if a test fails on the chromium browser, the tests running on the firefox and webkit will continue to run.
```
strategy:
      matrix:
        browser: [chromium, firefox, webkit]
      fail-fast: false
```

#### 2. **webtesting-manual-workflow.yml**

A workflow that can be triggered manually in order to run any specific test tag against the browsers, using the same matrix strategy from the previous workflow. You can go [here](https://github.com/BrunoFBarbosa/robot-framework-playwright/actions/workflows/webtesting-manual-workflow.yml), click on Run Workflow and choose a desired tag to run.
```
on:
  workflow_dispatch:
    inputs:
      tag:
        type: string
        description: Qual é a TAG do teste a ser executada?
        required: true
```

#### 3. **webtesting-manual-browser-workflow.yml**

A workflow that can be triggered manually similar to the previous workflow. The difference here is that it does not uses a matrix strategy. You can choose which browser you want to run the test against. You can go [here](https://github.com/BrunoFBarbosa/robot-framework-playwright/actions/workflows/webtesting-manual-browser-workflow.yml), click on `Run Workflow` and choose a desired tag and browser to run.
```
on:
  workflow_dispatch:
    inputs:
      tag:
        type: string
        description: Qual é a TAG do teste a ser executada?
        required: true
      browser:
        type: choice
        options:
        - chromium
        - firefox
        - webkit
        description: Qual é o navegador onde serão executados os testes?
        required: true
```
