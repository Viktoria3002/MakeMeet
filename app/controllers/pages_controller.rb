class PagesController < ApplicationController
  def page1
    @title = "Страница 1"
    @content = "Добро пожаловать на первую страницу нашего приложения!"
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
end
