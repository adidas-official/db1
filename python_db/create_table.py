import psycopg2
from config import load_config

def generate_test_values():
    commands = []
    for i in range(99):
        insert = f"INSERT INTO test (name) VALUES ({str(i).zfill(1)})"
        commands.append(insert)
    return commands


def create_table():
    """ Create table in database """

    try:
        config = load_config()
        with psycopg2.connect(**config) as conn:
            with conn.cursor() as cur:
                for command in generate_test_values():
                    print(command)
                    cur.execute(command)
                # cur.execute("DROP TABLE test")
                
    except (psycopg2.DatabaseError, Exception) as error:
        print(error)

create_table()