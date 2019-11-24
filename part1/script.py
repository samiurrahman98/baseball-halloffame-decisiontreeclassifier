import matlab.engine
import pandas as pd
from sklearn.model_selection import train_test_split

import csv


DATA_FILENAME = "data/data.csv"
TRAIN_SAMPLE_FILENAME = "data/train_sample.csv"
TRAIN_CLASSIFICATIONS_FILENAME = "data/train_classifications.csv"
TEST_SAMPLE_FILENAME = "data/test_sample.csv"
TEST_CLASSIFICATIONS_FILENAME = "data/test_classifications.csv"
PREDICTIONS_FILENAME = "data/predictions.csv"


GROUP_NUM = 4


N = 5


def split():
    data = pd.read_csv(DATA_FILENAME, index_col=0)

    y = data.classification
    X = data.drop("classification", axis=1)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

    X_train.to_csv(TRAIN_SAMPLE_FILENAME)
    y_train.to_csv(TRAIN_CLASSIFICATIONS_FILENAME, header=True)
    X_test.to_csv(TEST_SAMPLE_FILENAME)
    y_test.to_csv(TEST_CLASSIFICATIONS_FILENAME, header=True)


def run_classifier():
    eng = matlab.engine.start_matlab()
    eng.classifier(nargout=0)


def calculate_measurements(tp, tn, fp, fn):
    split()
    run_classifier()

    classifications = open(TEST_CLASSIFICATIONS_FILENAME)
    predictions = open(PREDICTIONS_FILENAME)

    reader_c = csv.DictReader(classifications)
    reader_p = csv.reader(predictions)

    for row in reader_c:
        label = row["classification"]
        prediction = next(reader_p, "")

        if label == "Y" and prediction == "Y":
            tp += 1
        elif label == "N" and prediction == "N":
            tn += 1
        elif label == "N" and prediction == "Y":
            fp += 1
        elif label == "Y" and prediction == "N":
            fn += 1

    return tp, tn, fp, fn


def calculate_accuracy():
    tp, tn, fp, fn = 0, 0, 0, 0

    for i in range(N):
        tp, tn, fp, fn = calculate_measurements(tp, tn, fp, fn)

    return (tp + tn) / (tp + tn + fp + fn)


def main():
    calculate_accuracy()


if __name__ == '__main__':
    main()
