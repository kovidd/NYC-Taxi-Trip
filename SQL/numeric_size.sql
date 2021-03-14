-- byte size of numeric datatype
SELECT pg_column_size('1234.123456'::NUMERIC(10,6)); --12
SELECT pg_column_size('123.1234'::NUMERIC(7,4)); --10
-- Saves a space of roughly 112mb

-- Ref: https://stackoverflow.com/questions/16402019/postgresql-optimizing-columns-size-for-numeric-fields
SELECT pg_column_size('123'::numeric(21,7)); --8
SELECT pg_column_size('123.1'::numeric(21,7)); --10
SELECT pg_column_size('123.12'::numeric(21,7)); --10
SELECT pg_column_size('123.123'::numeric(21,7)); --10
SELECT pg_column_size('123.1234'::numeric(21,7)); --10
SELECT pg_column_size('123.12345'::numeric(21,7)); --12
SELECT pg_column_size('123.123456'::numeric(21,7)); --12
SELECT pg_column_size('123.1234567'::numeric(21,7)); --12 

