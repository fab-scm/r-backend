Test repository for R-Scripts running in backend on node server environment.
Testing to implement it to the AWS later on.

start the app on port 9090
- npm start

Routes
- /async --> trains a model, performs LULC-classification, calculates the AOA (with DI) and extracts the the areas where we need to find more training data as GeoJSON
- /test --> calls a function from the test.R