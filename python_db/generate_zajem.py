import psycopg2
from config import load_config
from random import choice, randint, shuffle
from datetime import datetime, timedelta


def get_data(file):
    with open(file) as n:
        data = [line.strip() for line in n.readlines()]
    return data

def generate_people():
    commands = []
    basic = f"INSERT INTO lektor (jmeno, prijmeni, adresa) VALUES ('bude', 'upresneno', '-')"
    commands.append(basic)

    adresy = get_data("addresses.txt")
    jmena = []
    prijmeni = []

    for name in get_data("names.txt"):
        line = name.split(" ")
        jmena.append(line[0])
        prijmeni.append(line[1])

    for i in range(1, 11):
        insert = f"INSERT INTO lektor (jmeno, prijmeni, adresa) VALUES ('{choice(jmena)}', '{choice(prijmeni)}', '{choice(adresy)}')"
        commands.append(insert)
    
    for i in range(1, 101):
        insert = f"INSERT INTO zajemce (jmeno, prijmeni, adresa) VALUES ('{choice(jmena)}', '{choice(prijmeni)}', '{choice(adresy)}')"
        commands.append(insert)

    return commands

def generate_courses():
    commands = []
    cities = ["Praha", "Brno", "Zlin", "Ostrava", "Karlovy Vary"]
    config = load_config()
    conn = psycopg2.connect(**config)
    cur = conn.cursor()

    # for each lektor
    for i in range(2, 22):
        command = f"SELECT * FROM kompetence WHERE lektor_id = {i}"
        cur.execute(command)
        competency = cur.fetchall()
        courses = [c[-1] for c in competency]

        datum = datetime.today() + timedelta(days=randint(10, 300))
        datum = datum.strftime('%m-%d-%Y')

        for n in range(randint(2, len(competency) + 1)):
            command = f"""INSERT INTO kurz
                (delka, datum, misto, cena, sablona_id, lektor_id, stav_id)
                VALUES
                ({randint(10, 20) * 10},
                '{datum}',
                '{choice(cities)}',
                {randint(150, 300) * 100},
                {choice(courses)},
                {i},
                {randint(1, 3)});
            """
            commands.append(command)
    cur = None
    conn.close()
    return commands

def generate_competency():
    commands = []

    # for each teacher
    for teacher_id in range(2, 22):
        num_of_courses = randint(2, 6)
        picked = []
    #   for random_numb_of_courses
        for n in range(num_of_courses):
            while (True):
                course_id = randint(2, 11)
                if course_id not in picked:
                    break
            picked.append(course_id)

    #       insert into kompetence (teacher_id, random_course_id)
            command = f"INSERT INTO kompetence (lektor_id, sablona_id) VALUES ({teacher_id}, {course_id})"
            commands.append(command)

    return commands

def generate_templates():
    commands = ["INSERT INTO sablona (nazev) values ('Bude upresneno')"]

    kurzy = ["html", "css", "php", "javascript", "python", "c++", "sql", "TCP/IP", "social networks", "photo editing"]


    for kurz in kurzy:
        command = f"INSERT INTO sablona (nazev) values ('{kurz}')"
        commands.append(command)

    return commands

def generate_reserve():
    commands = []

    zajemci = [i for i in range(1, 201)]

    for i in range(1, 101):
        sablony = [i for i in range(2, 12)]
        shuffle(zajemci)
        shuffle(sablony)
        zajemce_id = zajemci.pop()
        for j in range(1, randint(2, 5)):
            sablona_id = sablony.pop()
            command = f"""INSERT INTO rezervace
            (zajemce_id, sablona_id)
            VALUES ({zajemce_id}, {sablona_id});
            """ 
            commands.append(command)
        
    return commands

def generate_ucast():
    commands = []

    config = load_config()
    conn = psycopg2.connect(**config)
    cur = conn.cursor()

    command = f"""select id_kurz, zajemce_id, kurz.datum
        from rezervace
        join sablona on sablona.id_sablona = rezervace.sablona_id
        join kurz on sablona.id_sablona = kurz.sablona_id;
    """
    cur.execute(command)
    zajemci = cur.fetchall()
    for _ in range(randint(1, len(zajemci) -1)):
        zajemce = zajemci.pop(randint(1, len(zajemci) -1))
        kurz_id, zajemce_id, datum = zajemce
        uhrada = datum - timedelta(days=randint(3, 30))
        certifikat = str(datum) + "-certifikat.pdf"
        command = f"""
            INSERT INTO ucast (kurz_id, zajemce_id, certifikat, uhrada)
            VALUES ({kurz_id}, {zajemce_id}, '{certifikat}', '{uhrada}');
        """
        commands.append(command)

    return commands

def run_query(commands):
    """ Create table in database """

    try:
        config = load_config()
        with psycopg2.connect(**config) as conn:
            with conn.cursor() as cur:
                for command in commands:
                    print(command)
                    cur.execute(command)
    except (psycopg2.DatabaseError, Exception) as error:
        print(error)

# run_query(generate_templates())
# run_query(generate_courses())
# run_query(generate_reserve())
# run_query(generate_people())
# run_query(generate_competency())
# run_query(generate_reserve())
run_query(generate_ucast())