LOAD DATA
INFILE 'C:\bstu_labs\labs-6-sem\db\DB_Lab11\input_oracle.txt'
APPEND INTO TABLE products
FIELDS TERMINATED BY ","
(
  product_id,
  product_name "UPPER(:product_name)",
  category_id,
  price DECIMAL EXTERNAL "ROUND(:price, 1)",
  description "UPPER(:description)",
  image_url "UPPER(:image_url)",
  quantity DECIMAL EXTERNAL "ROUND(:quantity, 1)",
  date_column DATE "DD-MM-YYYY"
)