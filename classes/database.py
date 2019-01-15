import cx_Oracle


class Database:
    def __init__(self):
        self.__db = cx_Oracle.connect("SYSTEM", "ander2299", "localhost")
        self.__cursor = self.__db.cursor()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.__cursor.close()
        self.__db.close()

    def autorization(self, p_login, p_password):
        isUser = self.__cursor.callfunc("user_package.autorization", cx_Oracle.STRING, [p_login, p_password])
        return isUser

    def registration(self, p_id_code, p_last_name, p_first_name, p_middle_name, p_email, p_login, p_password):
        isUserCreated = self.__cursor.callfunc("user_package.registration", cx_Oracle.NUMBER,
                                               [p_id_code, p_last_name, p_first_name, p_middle_name,
                                                p_login, p_password, p_email])
        return isUserCreated

    def getUser(self, p_login):
        query = 'select * from table(user_package.get_user(:login))'
        self.__cursor.execute(query, login=p_login)
        userInfo = self.__cursor.fetchall()
        user = userInfo[0]

        return user


