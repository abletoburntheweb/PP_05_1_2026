from PyQt5.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, QLabel,
    QLineEdit, QPushButton, QMessageBox
)
from PyQt5.QtCore import Qt
from db import get_connection
from components.puzzle_captcha import PuzzleCaptcha


class LoginWindow(QMainWindow):
    """Окно авторизации пользователя"""

    def __init__(self):
        super().__init__()
        self.setWindowTitle("Авторизация — ООО «Полесье»")
        self.setMinimumSize(400, 350)

        central = QWidget()
        layout = QVBoxLayout()

        self.le_login = QLineEdit()
        self.le_login.setPlaceholderText("Логин")
        self.le_login.setMinimumWidth(250)

        self.le_password = QLineEdit()
        self.le_password.setPlaceholderText("Пароль")
        self.le_password.setEchoMode(QLineEdit.Password)
        self.le_password.setMinimumWidth(250)

        self.captcha = PuzzleCaptcha()

        self.btn_login = QPushButton("Войти")
        self.btn_login.clicked.connect(self.on_login)

        self.lbl_error = QLabel("")
        self.lbl_error.setStyleSheet("color: red;")
        self.lbl_error.setAlignment(Qt.AlignCenter)

        layout.addWidget(QLabel("Вход в систему"), alignment=Qt.AlignCenter)
        layout.addWidget(self.le_login)
        layout.addWidget(self.le_password)
        layout.addWidget(self.captcha)
        layout.addWidget(self.btn_login)
        layout.addWidget(self.lbl_error)

        central.setLayout(layout)
        self.setCentralWidget(central)

    def on_login(self):
        """Обработка входа пользователя"""
        login = self.le_login.text().strip()
        password = self.le_password.text().strip()

        if not login or not password:
            self.lbl_error.setText("Логин и пароль обязательны!")
            return

        if not self.captcha.is_solved():
            self.lbl_error.setText("Пазл не решён. Соберите изображение из фрагментов.")
            self._increment_block_count_if_needed(login)
            return

        try:
            with get_connection() as conn:
                cur = conn.cursor()
                cur.execute(
                    "SELECT role, is_blocked, block_count, password_hash FROM users WHERE login = %s",
                    (login,)
                )
                result = cur.fetchone()
        except Exception as e:
            self.lbl_error.setText("Ошибка подключения к базе данных.")
            print(f"Ошибка БД: {e}")
            return

        if not result:
            self.lbl_error.setText("Вы ввели неверный логин или пароль. Пожалуйста, проверьте ещё раз введенные данные")
            self._increment_block_count_if_needed(login)
            return

        role, blocked, block_count, db_password = result

        if blocked:
            self.lbl_error.setText("Вы заблокированы. Обратитесь к администратору")
            return

        if password != db_password:
            self.lbl_error.setText("Вы ввели неверный логин или пароль. Пожалуйста, проверьте ещё раз введенные данные")
            self._increment_block_count_if_needed(login, role)
            return

        QMessageBox.information(self, "Успешно", "Вы успешно авторизовались")

        if role == 'Администратор':
            self.open_admin_panel()
        else:
            QMessageBox.information(self, "Информация", "Вы вошли как пользователь. Функционал ограничен.")
            self.close()

    def _increment_block_count_if_needed(self, login, role=None):
        """Увеличить счётчик неудачных попыток"""
        if role is None:
            try:
                with get_connection() as conn:
                    cur = conn.cursor()
                    cur.execute("SELECT role FROM users WHERE login = %s", (login,))
                    result = cur.fetchone()
                    if result:
                        role = result[0]
                    else:
                        return
            except Exception:
                return

        if role == 'Администратор':
            return

        try:
            with get_connection() as conn:
                cur = conn.cursor()
                cur.execute("SELECT block_count FROM users WHERE login = %s", (login,))
                result = cur.fetchone()
                if result is None:
                    return
                count = result[0]
                new_count = count + 1
                if new_count >= 3:
                    cur.execute("UPDATE users SET is_blocked = TRUE WHERE login = %s", (login,))
                    self.lbl_error.setText("Вы заблокированы. Обратитесь к администратору")
                else:
                    cur.execute("UPDATE users SET block_count = %s WHERE login = %s", (new_count, login))
                conn.commit()
        except Exception as e:
            print(f"Ошибка обновления блокировки: {e}")

    def open_admin_panel(self):
        """Открыть административную панель"""
        from forms.admin_window import AdminWindow
        self.admin_win = AdminWindow()
        self.admin_win.show()
        self.close()