import pandas as pd
import os
from sqlalchemy import create_engine
from urllib.parse import quote_plus # <--- NEW LIBRARY TO FIX PASSWORD ISSUE

# --- CONFIGURATION ---
# Database Credentials
db_user = 'postgres'
db_password = 'Identity@89'  # Your password (keep it as is)
db_host = 'localhost'
db_port = '2832'
db_name = 'postgres' 

# Paths
base_path = r'../01_Raw_Data' 

# Map CSV filenames to clean Table Names for the database
files_to_tables = {
    'olist_orders_dataset.csv': 'orders',
    'olist_order_items_dataset.csv': 'order_items',
    'olist_products_dataset.csv': 'products',
    'olist_customers_dataset.csv': 'customers',
    'olist_geolocation_dataset.csv': 'geolocation',
    'olist_order_payments_dataset.csv': 'payments',
    'olist_order_reviews_dataset.csv': 'reviews',
    'olist_sellers_dataset.csv': 'sellers',
    'product_category_name_translation.csv': 'category_translation'
}

def main():
    # 1. URL Encode the password to handle the '@' symbol safely
    encoded_pass = quote_plus(db_password)

    # 2. Create Database Connection using the encoded password
    connection_str = f'postgresql+psycopg2://{db_user}:{encoded_pass}@{db_host}:{db_port}/{db_name}'
    
    try:
        engine = create_engine(connection_str)
        print(f"[SUCCESS] Connected to PostgreSQL database: {db_name}")
    except Exception as e:
        print(f"[ERROR] Could not connect to database. Check password/port.\nError: {e}")
        return

    # 3. Iterate through files and load to SQL
    print("\n--- Starting Data Ingestion ---")
    
    for csv_file, table_name in files_to_tables.items():
        file_path = os.path.join(base_path, csv_file)
        
        if os.path.exists(file_path):
            print(f"Processing: {csv_file} -> Table: {table_name}")
            
            try:
                # Read CSV
                df = pd.read_csv(file_path)
                
                # Load to SQL
                df.to_sql(name=table_name, con=engine, if_exists='replace', index=False, chunksize=1000)
                
                print(f"   -> Loaded {len(df)} rows successfully.")
                
            except Exception as e:
                print(f"   -> [ERROR] Failed to load {table_name}: {e}")
        else:
            print(f"   -> [WARNING] File not found: {csv_file}")

    print("\n--- Ingestion Complete ---")

if __name__ == "__main__":
    main()