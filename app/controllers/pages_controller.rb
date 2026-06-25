class PagesController < ApplicationController
  def about
    # Страница О сервисе с приветственным экраном
  end

  def register
    # Страница регистрации
  end

  def registration
    # Форма регистрации
  end

  def login
    # Страница входа
  end

  def auth_welcome
    # Мотивирующий экран после входа или регистрации
  end

  def page1
    # Главная страница с hero секцией и медиа контентом
  end

  def page2
    @title = "Страница 2"
    @content = "Это вторая страница с интересным контентом."
  end

  def page3
    @title = "Страница 3"
    @content = "Третья страница содержит дополнительную информацию."
  end

  def create_sprint
    # Страница создания собственного спринта
  end

  def page4
    @title = "Страница 4"
    @content = "Четвертая страница завершает нашу навигацию."
  end

  def profile_details
    # Детальная страница профиля
  end

  def settings
    # Страница настроек профиля
  end

  def settings_change_password
    # Страница смены пароля из настроек
  end

  def article
    # Статья по спринту "Улучшить утренние ритуалы"
  end

  def article_freelance
    # Статья "Лучшие помощники в работе на фрилансе"
  end
end
