from PyQt5.QtWidgets import (
    QDialog, QFormLayout, QLineEdit, QComboBox,
    QDialogButtonBox, QMessageBox
)
from db import get_connection


class EditUserDialog(QDialog):
    """Диалог добавления/редактирования пользователя"""

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

        self.role_combo = QComboBox()
        self.role_combo.addItems(["Администратор", "Пользователь"])

        layout.addRow("Логин:", self.le_login)
        layout.addRow("Пароль:", self.le_password)
        layout.addRow("Роль:", self.role_combo)

        if not new:
            self._load_user_data()

        buttons = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        buttons.accepted.connect(self.accept)
        buttons.rejected.connect(self.reject)

        layout.addWidget(buttons)
        self.setLayout(layout)

    def _load_user_data(self):
        """Загрузить данные пользователя"""
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("SELECT login, role FROM users WHERE login = %s", (self.login,))
            row = cur.fetchone()
            if row:
                self.le_login.setText(row[0])
                self.role_combo.setCurrentText(row[1])

    def accept(self):
        """Сохранить данные пользователя"""
        login = self.le_login.text().strip()
        password = self.le_password.text().strip()
        role = self.role_combo.currentText()

        if not login or (self.new and not password):
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
                    cur.execute(
                        "INSERT INTO users (login, password_hash, role) VALUES (%s, %s, %s)",
                        (login, password, role)
                    )
                else:
                    if password == "":
                        cur.execute("UPDATE users SET role = %s WHERE login = %s", (role, self.login))
                    else:
                        cur.execute(
                            "UPDATE users SET password_hash = %s, role = %s WHERE login = %s",
                            (password, role, self.login)
                        )
                conn.commit()
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось сохранить: {str(e)}")
            return

        super().accept()