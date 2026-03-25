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

  def page4
    @title = "Страница 4"
    @content = "Четвертая страница завершает нашу навигацию."
  end

  def profile_details
    # Детальная страница профиля
  end

  def article
    # Статья по спринту "Улучшить утренние ритуалы"
  end
end
