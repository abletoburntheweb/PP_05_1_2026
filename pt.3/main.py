import sys
from PyQt5.QtGui import QPixmap
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QLineEdit, QPushButton, QMessageBox, QGridLayout,
    QListWidget, QDialog, QDialogButtonBox, QFormLayout, QSizePolicy
)
from PyQt5.QtCore import Qt, pyqtSignal
from db import get_connection
import random


class PuzzleCaptcha(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QGridLayout()
        self.layout.setSpacing(0)
        self.layout.setContentsMargins(0, 0, 0, 0)
        self.setLayout(self.layout)
        self.fragments = []
        self.correct_order = [0, 1, 2, 3]
        self.current_order = [0, 1, 2, 3]
        random.shuffle(self.current_order)
        self.selected_idx = None
        self.init_ui()

    def init_ui(self):
        for i in range(4):
            lbl = QLabel()
            lbl.setMinimumSize(100, 100)
            lbl.setSizePolicy(QSizePolicy.Ignored, QSizePolicy.Ignored)
            lbl.setAlignment(Qt.AlignCenter)
            lbl.setStyleSheet("border: 1px solid #aaa; background: #f8f8f8;")
            try:
                idx = self.current_order[i]
                pixmap = QPixmap(f"{idx+1}.png")
                if pixmap.isNull():
                    lbl.setText(f"Фрагм.{idx+1}")
                else:
                    lbl.setPixmap(pixmap.scaled(100, 100, Qt.KeepAspectRatio, Qt.SmoothTransformation))
            except Exception as e:
                lbl.setText(f"Ошибка: {e}")

            lbl.mousePressEvent = lambda event, idx=i: self.on_fragment_click(idx)
            self.fragments.append(lbl)
            row = i // 2
            col = i % 2
            self.layout.addWidget(lbl, row, col)

    def on_fragment_click(self, idx):
        if self.selected_idx is None:
            self.selected_idx = idx
            self.fragments[idx].setStyleSheet("border: 2px solid blue; background: #e0f0ff;")
        else:
            self.current_order[self.selected_idx], self.current_order[idx] = \
                self.current_order[idx], self.current_order[self.selected_idx]
            self.update_display()
            self.selected_idx = None

    def update_display(self):
        for i, lbl in enumerate(self.fragments):
            idx = self.current_order[i]
            try:
                pixmap = QPixmap(f"{idx+1}.png")
                if not pixmap.isNull():
                    lbl.setPixmap(pixmap.scaled(100, 100, Qt.KeepAspectRatio, Qt.SmoothTransformation))
                else:
                    lbl.setText(f"Фрагм.{idx+1}")
            except:
                lbl.setText(f"Фрагм.{idx+1}")

    def is_solved(self):
        return self.current_order == self.correct_order


class LoginWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Авторизация — ООО «Полесье»")
        self.setMinimumSize(400, 350)
        self.setFixedSize(400, 350)

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
        login = self.le_login.text().strip()
        password = self.le_password.text().strip()

        if not login or not password:
            self.lbl_error.setText("Логин и пароль обязательны!")
            return
        if not self.captcha.is_solved():
            self.lbl_error.setText("Пазл не решён. Соберите изображение из фрагментов.")
            self.increment_block_count_if_needed(login)
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
            self.lbl_error.setText("Вы ввели неверный логин или пароль. Пожалуйста проверьте ещё раз введенные данные")
            self.increment_block_count_if_needed(login)
            return

        role, blocked, block_count, db_password = result

        if blocked:
            self.lbl_error.setText("Вы заблокированы. Обратитесь к администратору")
            return

        if password != db_password:
            self.lbl_error.setText("Вы ввели неверный логин или пароль. Пожалуйста проверьте ещё раз введенные данные")
            self.increment_block_count_if_needed(login, role)
            return

        QMessageBox.information(self, "Успешно", "Вы успешно авторизовались")
        if role == 'Администратор':
            self.open_admin_panel()
        else:
            QMessageBox.information(self, "Информация", "Вы вошли как пользователь. Функционал ограничен.")
        self.close()

    def increment_block_count_if_needed(self, login, role=None):
        if role is None:
            try:
                with get_connection() as conn:
                    cur = conn.cursor()
                    cur.execute("SELECT role FROM users WHERE login = %s", (login,))
                    result = cur.fetchone()
                    if result:
                        role = result[0]
                    else:
                        return  # пользователь не найден
            except Exception:
                return

        # Не увеличиваем счётчик для администратора
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
                    # Показываем сообщение о блокировке
                    self.lbl_error.setText("Вы заблокированы. Обратитесь к администратору")
                else:
                    cur.execute("UPDATE users SET block_count = %s WHERE login = %s", (new_count, login))
                conn.commit()
        except Exception as e:
            print(f"Ошибка обновления блокировки: {e}")

    def open_admin_panel(self):
        self.admin_win = AdminWindow()
        self.admin_win.show()


class AdminWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Рабочий стол — Администратор | ООО «Полесье»")
        self.setMinimumSize(500, 400)

        central = QWidget()
        layout = QVBoxLayout()

        self.user_list = QListWidget()
        self.refresh_user_list()

        self.btn_add = QPushButton("Добавить пользователя")
        self.btn_edit = QPushButton("Редактировать")
        self.btn_unblock = QPushButton("Снять блокировку")

        self.btn_add.clicked.connect(self.add_user)
        self.btn_edit.clicked.connect(self.edit_user)
        self.btn_unblock.clicked.connect(self.unblock_user)

        btn_layout = QHBoxLayout()
        btn_layout.addWidget(self.btn_add)
        btn_layout.addWidget(self.btn_edit)
        btn_layout.addWidget(self.btn_unblock)

        layout.addWidget(self.user_list)
        layout.addLayout(btn_layout)

        central.setLayout(layout)
        self.setCentralWidget(central)

    def refresh_user_list(self):
        self.user_list.clear()
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("SELECT login, role, is_blocked FROM users ORDER BY id")
            for row in cur.fetchall():
                status = " (заблокирован)" if row[2] else ""
                self.user_list.addItem(f"{row[0]} ({row[1]}){status}")

    def add_user(self):
        dialog = EditUserDialog(self, new=True)
        if dialog.exec_() == QDialog.Accepted:
            self.refresh_user_list()

    def edit_user(self):
        item = self.user_list.currentItem()
        if not item:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для редактирования")
            return
        login = item.text().split(' ')[0]
        dialog = EditUserDialog(self, login=login)
        if dialog.exec_() == QDialog.Accepted:
            self.refresh_user_list()

    def unblock_user(self):
        item = self.user_list.currentItem()
        if not item:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для разблокировки")
            return
        login = item.text().split(' ')[0]
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("UPDATE users SET is_blocked = FALSE, block_count = 0 WHERE login = %s", (login,))
            conn.commit()
        self.refresh_user_list()


class EditUserDialog(QDialog):
    def __init__(self, parent, new=False, login=None):
        super().__init__(parent)
        self.new = new
        self.login = login
        self.setWindowTitle("Добавить пользователя" if new else "Редактировать пользователя")
        self.setModal(True)

        layout = QFormLayout()

        self.le_login = QLineEdit()
        self.le_password = QLineEdit()
        self.le_password.setEchoMode(QLineEdit.Password)

        from PyQt5.QtWidgets import QComboBox
        self.role_combo = QComboBox()
        self.role_combo.addItems(["Администратор", "Пользователь"])

        layout.addRow("Логин:", self.le_login)
        layout.addRow("Пароль:", self.le_password)
        layout.addRow("Роль:", self.role_combo)

        if not new:
            self.load_user_data()

        buttons = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        buttons.accepted.connect(self.accept)
        buttons.rejected.connect(self.reject)

        layout.addWidget(buttons)
        self.setLayout(layout)

    def load_user_data(self):
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("SELECT login, role FROM users WHERE login = %s", (self.login,))
            row = cur.fetchone()
            if row:
                self.le_login.setText(row[0])
                self.role_combo.setCurrentText(row[1])

    def accept(self):
        login = self.le_login.text().strip()
        password = self.le_password.text().strip()
        role = self.role_combo.currentText()

        if not login or not password:
            QMessageBox.warning(self, "Ошибка", "Логин и пароль обязательны")
            return

        try:
            with get_connection() as conn:
                cur = conn.cursor()
                if self.new:
                    cur.execute("SELECT login FROM users WHERE login = %s", (login,))
                    if cur.fetchone():
                        QMessageBox.warning(self, "Ошибка", "Пользователь с таким логином уже существует")
                        return
                    cur.execute("""
                        INSERT INTO users (login, password_hash, role) VALUES (%s, %s, %s)
                    """, (login, password, role))
                else:
                    if password == "":  # Если поле пароля пустое, не обновляем
                        cur.execute("UPDATE users SET role = %s WHERE login = %s", (role, self.login))
                    else:
                        cur.execute("UPDATE users SET password_hash = %s, role = %s WHERE login = %s",
                                    (password, role, self.login))
                conn.commit()
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось сохранить: {str(e)}")
            return

        super().accept()


if __name__ == "__main__":
    app = QApplication(sys.argv)

    window = LoginWindow()
    window.show()
    sys.exit(app.exec_())
