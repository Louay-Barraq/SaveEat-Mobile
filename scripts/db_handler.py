import os
import sys
import uuid
from datetime import datetime
from supabase import create_client, Client

try:
    from tabulate import tabulate
    HAS_TABULATE = True
except ImportError:
    HAS_TABULATE = False
    # To get pretty tables, run: pip install tabulate

# --- CONFIGURATION ---
# Set these from your Supabase project settings
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://hzbesrpxlldozjzeahwl.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6YmVzcnB4bGxkb3pqemVhaHdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY3MTA4MzcsImV4cCI6MjA2MjI4NjgzN30.lQk4fSIWzF_rauI-TW1xV9U0bZi8TvwHdFHnSdSy7vc')

# --- TABLE SCHEMA ---
TABLES = {
    'restaurant': [
        {'name': 'id', 'type': 'uuid', 'nullable': False, 'auto': True},
        {'name': 'name', 'type': 'text', 'nullable': False},
        {'name': 'location', 'type': 'text', 'nullable': True},
        {'name': 'created_at', 'type': 'timestamptz', 'nullable': True, 'auto': True},
    ],
    'table_model': [
        {'name': 'id', 'type': 'uuid', 'nullable': False, 'auto': True},
        {'name': 'restaurant_id', 'type': 'uuid', 'nullable': True},
        {'name': 'table_number', 'type': 'int4', 'nullable': False},
        {'name': 'created_at', 'type': 'timestamptz', 'nullable': True, 'auto': True},
    ],
    'waste_entry': [
        {'name': 'id', 'type': 'uuid', 'nullable': False, 'auto': True},
        {'name': 'table_id', 'type': 'uuid', 'nullable': True},
        {'name': 'restaurant_id', 'type': 'uuid', 'nullable': True},
        {'name': 'timestamp', 'type': 'timestamptz', 'nullable': False},
        {'name': 'waste_amount', 'type': 'float8', 'nullable': False},
        {'name': 'meal_time', 'type': 'text', 'nullable': True, 'enum': ['breakfast', 'lunch', 'dinner']},
        {'name': 'predicted_percentage', 'type': 'float8', 'nullable': True},
        {'name': 'report_time', 'type': 'time', 'nullable': True},
        {'name': 'created_at', 'type': 'timestamptz', 'nullable': True, 'auto': True},
    ],
    'app_user': [
        {'name': 'id', 'type': 'uuid', 'nullable': False, 'auto': True},
        {'name': 'email', 'type': 'text', 'nullable': False},
        {'name': 'role', 'type': 'text', 'nullable': True, 'enum': ['admin', 'staff']},
        {'name': 'restaurant_id', 'type': 'uuid', 'nullable': True},
        {'name': 'created_at', 'type': 'timestamptz', 'nullable': True, 'auto': True},
    ],
    'robot_model': [
        {'name': 'id', 'type': 'uuid', 'nullable': False, 'auto': True},
        {'name': 'current_table_id', 'type': 'uuid', 'nullable': True},
        {'name': 'status', 'type': 'text', 'nullable': False},
        {'name': 'last_active_at', 'type': 'timestamptz', 'nullable': True},
        {'name': 'battery_percentage', 'type': 'float8', 'nullable': True},
        {'name': 'created_at', 'type': 'timestamptz', 'nullable': True, 'auto': True},
        {'name': 'name', 'type': 'text', 'nullable': True},
        {'name': 'password_hash', 'type': 'text', 'nullable': True},
    ],
}

def get_supabase():
    return create_client(SUPABASE_URL, SUPABASE_KEY)

def parse_timestamp(val):
    if not val:
        return datetime.now().isoformat()
    try:
        # Try ISO format first
        return datetime.fromisoformat(val).isoformat()
    except Exception:
        pass
    try:
        # Try DD/MM/YYYY
        dt = datetime.strptime(val, '%d/%m/%Y')
        return dt.replace(hour=0, minute=10, second=0).isoformat()
    except Exception:
        pass
    print('Invalid date format. Using current time.')
    return datetime.now().isoformat()

def parse_uuid(val):
    if not val:
        return str(uuid.uuid4())
    try:
        return str(uuid.UUID(val))
    except Exception:
        print('Invalid UUID. Generating a new one.')
        return str(uuid.uuid4())

def prompt_enum(enum_list):
    print('Choose one of:', ', '.join(enum_list))
    while True:
        val = input('> ').strip()
        if val in enum_list:
            return val
        print('Invalid. Try again.')

def prompt_value(col):
    if col.get('auto', False):
        return None
    if 'enum' in col:
        return prompt_enum(col['enum'])
    val = input(f"Enter value for {col['name']} ({col['type']})" + (" [optional]" if col['nullable'] else "") + ': ').strip()
    # Special handling for timestamp fields
    if col['type'] in ['timestamptz', 'timestamp with time zone']:
        return parse_timestamp(val)
    # Special handling for UUID fields
    if col['type'] == 'uuid':
        # Only auto-generate for primary key (id)
        if col['name'] == 'id':
            return parse_uuid(val)
        # For foreign keys, if blank, return None (null)
        if not val:
            return None
        try:
            return str(uuid.UUID(val))
        except Exception:
            print('Invalid UUID. Please enter a valid UUID or leave blank for null.')
            return prompt_value(col)
    if not val and col['nullable']:
        return None
    if col['type'] in ['int4', 'integer'] and val:
        try:
            return int(val)
        except Exception:
            print('Invalid integer. Try again.')
            return prompt_value(col)
    if col['type'] in ['float8', 'double precision'] and val:
        try:
            return float(val)
        except Exception:
            print('Invalid float. Try again.')
            return prompt_value(col)
    if col['type'] == 'time' and val:
        # Accept as string (HH:MM:SS)
        return val
    return val

def list_rows(supabase, table):
    print(f'--- Rows in {table} ---')
    res = supabase.table(table).select('*').limit(50).execute()
    if res.data:
        colnames = list(res.data[0].keys())
        rows = [[row.get(col, '') for col in colnames] for row in res.data]
        if HAS_TABULATE:
            print(tabulate(rows, headers=colnames, tablefmt='psql'))
        else:
            # fallback
            print('\t'.join(colnames))
            for row in rows:
                print('\t'.join(str(x) for x in row))
    else:
        print('No rows found.')
    print('--- End ---')

def insert_row(supabase, table):
    cols = [c for c in TABLES[table] if not c.get('auto', False)]
    row = {}
    for col in cols:
        val = prompt_value(col)
        if val is not None:
            row[col['name']] = val
    res = supabase.table(table).insert(row).execute()
    print('Inserted:', res.data)

def update_row(supabase, table):
    # Define update filter columns for each table
    update_filters = {
        'robot_model': ['name', 'password_hash'],
        'app_user': ['email'],
        'waste_entry': ['meal_time', 'predicted_percentage'],
        'table_model': ['table_number'],
        'restaurant': ['name'],
    }
    filter_cols = update_filters.get(table, [TABLES[table][0]['name']])
    filter_vals = {}
    print(f"Enter values for filter columns: {', '.join(filter_cols)} (leave blank to skip)")
    for col in filter_cols:
        # Find column type from schema
        col_schema = next((c for c in TABLES[table] if c['name'] == col), {'name': col, 'type': 'text', 'nullable': False})
        val = prompt_value(col_schema)
        if val is not None and val != '':
            filter_vals[col] = val
    if not filter_vals:
        print('No filter values provided. Aborting update.')
        return
    print('Enter new values for fields to update (leave blank to skip):')
    updates = {}
    for col in TABLES[table]:
        if col['name'] in filter_cols:
            # Allow updating filter columns too
            val = prompt_value(col)
            if val is not None and val != '':
                updates[col['name']] = val
        elif not col.get('auto', False):
            val = prompt_value(col)
            if val is not None and val != '':
                updates[col['name']] = val
    if not updates:
        print('No updates provided.')
        return
    query = supabase.table(table).update(updates)
    for col, val in filter_vals.items():
        query = query.eq(col, val)
    res = query.execute()
    print('Updated:', res.data)

def delete_row(supabase, table):
    pk_col = TABLES[table][0]['name']  # Assume first col is PK
    pk_val = prompt_value({'name': pk_col, 'type': 'uuid', 'nullable': False})
    res = supabase.table(table).delete().eq(pk_col, pk_val).execute()
    print('Deleted:', res.data)

def main():
    actions = ['list', 'insert', 'update', 'delete']
    print('Choose action:')
    for i, act in enumerate(actions):
        print(f"{i+1}. {act}")
    act_idx = int(input('>>> ')) - 1
    action = actions[act_idx]

    print('Choose table:')
    tables = list(TABLES.keys())
    for i, t in enumerate(tables):
        print(f"{i+1}. {t}")
    table_idx = int(input('>>> ')) - 1
    table = tables[table_idx]

    supabase = get_supabase()
    if action == 'list':
        list_rows(supabase, table)
    elif action == 'insert':
        insert_row(supabase, table)
    elif action == 'update':
        update_row(supabase, table)
    elif action == 'delete':
        delete_row(supabase, table)

if __name__ == '__main__':
    main()

# To get pretty tables, run: pip install tabulate 