mysql -u root -p lahman2016 < select_features.sql | sed $'s/\t/,/g' > data/data.csv
