import cx_Oracle
import os

db = cx_Oracle.connect("SYSTEM", "ander2299", "localhost")
curs = db.cursor()

path = 'sql/'
files = os.listdir(path)

#for file in files:
f = open('sql/user_package.sql')
full_sql = f.read()
sql_commands = full_sql.split(';')

for sql_command in sql_commands:
	try:
		curs.execute(sql_command)
	except Exception:
		print(sql_command)
		pass
f.close()

@sql/GROUP_PACKAGE.sql
@sql/lesson_package.sql
@sql/student_package.sql
@sql/student_presence_package.sql
@sql/teacher_package.sql
@sql/user_package.sql
