from PyQt5.QtWidgets import (
    QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QPushButton, QListWidget, QMessageBox
)
from PyQt5.QtWidgets import QDialog
from db import get_connection
from forms.edit_user_dialog import EditUserDialog


class AdminWindow(QMainWindow):
    """Административная панель управления пользователями"""

    def __init__(self):
        super().__init__()
        self.setWindowTitle("Рабочий стол — Администратор | ООО «Полесье»")
        self.setMinimumSize(500, 400)

        central = QWidget()
        layout = QVBoxLayout()

        self.user_list = QListWidget()
        self._refresh_user_list()

        self.btn_add = QPushButton("Добавить пользователя")
        self.btn_edit = QPushButton("Редактировать")
        self.btn_unblock = QPushButton("Снять блокировку")
        self.btn_logout = QPushButton("Выход из учетной записи")

        self.btn_add.clicked.connect(self.add_user)
        self.btn_edit.clicked.connect(self.edit_user)
        self.btn_unblock.clicked.connect(self.unblock_user)
        self.btn_logout.clicked.connect(self.logout)

        btn_layout = QHBoxLayout()
        btn_layout.addWidget(self.btn_add)
        btn_layout.addWidget(self.btn_edit)
        btn_layout.addWidget(self.btn_unblock)
        btn_layout.addWidget(self.btn_logout)

        layout.addWidget(self.user_list)
        layout.addLayout(btn_layout)

        central.setLayout(layout)
        self.setCentralWidget(central)

    def _refresh_user_list(self):
        """Обновить список пользователей"""
        self.user_list.clear()
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("SELECT login, role, is_blocked FROM users ORDER BY id")
            for row in cur.fetchall():
                status = " (заблокирован)" if row[2] else ""
                self.user_list.addItem(f"{row[0]} ({row[1]}){status}")

    def add_user(self):
        """Добавить нового пользователя"""
        dialog = EditUserDialog(self, new=True)
        if dialog.exec_() == QDialog.Accepted:
            self._refresh_user_list()

    def edit_user(self):
        """Редактировать выбранного пользователя"""
        item = self.user_list.currentItem()
        if not item:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для редактирования")
            return
        login = item.text().split(' ')[0]
        dialog = EditUserDialog(self, login=login)
        if dialog.exec_() == QDialog.Accepted:
            self._refresh_user_list()

    def unblock_user(self):
        """Снять блокировку с пользователя"""
        item = self.user_list.currentItem()
        if not item:
            QMessageBox.warning(self, "Ошибка", "Выберите пользователя для разблокировки")
            return
        login = item.text().split(' ')[0]
        with get_connection() as conn:
            cur = conn.cursor()
            cur.execute("UPDATE users SET is_blocked = FALSE, block_count = 0 WHERE login = %s", (login,))
            conn.commit()
        self._refresh_user_list()

    def logout(self):
        """Выйти из учетной записи"""
        from forms.login_window import LoginWindow
        self.login_win = LoginWindow()
        self.login_win.show()
        self.close()