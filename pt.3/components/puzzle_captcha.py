from PyQt5.QtWidgets import QWidget, QLabel, QGridLayout
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QSizePolicy
import random


class PuzzleCaptcha(QWidget):
    """Интерактивная капча в виде пазла из 4 фрагментов"""

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

        self._init_ui()

    def _init_ui(self):
        """Инициализация интерфейса капчи"""
        for i in range(4):
            lbl = QLabel()
            lbl.setMinimumSize(100, 100)
            lbl.setSizePolicy(QSizePolicy.Ignored, QSizePolicy.Ignored)
            lbl.setAlignment(Qt.AlignCenter)
            lbl.setStyleSheet("border: 1px solid #aaa; background: #f8f8f8;")

            try:
                idx = self.current_order[i]
                pixmap = QPixmap(f"images/{idx + 1}.png")
                if pixmap.isNull():
                    lbl.setText(f"Фрагм.{idx + 1}")
                else:
                    lbl.setPixmap(pixmap.scaled(100, 100, Qt.KeepAspectRatio, Qt.SmoothTransformation))
            except Exception as e:
                lbl.setText(f"Ошибка: {e}")

            lbl.mousePressEvent = lambda event, idx=i: self._on_fragment_click(idx)
            self.fragments.append(lbl)

            row = i // 2
            col = i % 2
            self.layout.addWidget(lbl, row, col)

    def _on_fragment_click(self, idx):
        """Обработка клика по фрагменту пазла"""
        if self.selected_idx is None:
            self.selected_idx = idx
            self.fragments[idx].setStyleSheet("border: 2px solid blue; background: #e0f0ff;")
        else:
            self.current_order[self.selected_idx], self.current_order[idx] = \
                self.current_order[idx], self.current_order[self.selected_idx]
            self._update_display()
            self.selected_idx = None

    def _update_display(self):
        """Обновить отображение фрагментов"""
        for i, lbl in enumerate(self.fragments):
            idx = self.current_order[i]
            try:
                pixmap = QPixmap(f"images/{idx + 1}.png")
                if not pixmap.isNull():
                    lbl.setPixmap(pixmap.scaled(100, 100, Qt.KeepAspectRatio, Qt.SmoothTransformation))
                else:
                    lbl.setText(f"Фрагм.{idx + 1}")
            except:
                lbl.setText(f"Фрагм.{idx + 1}")

    def is_solved(self):
        """Проверить, собран ли пазл правильно"""
        return self.current_order == self.correct_order