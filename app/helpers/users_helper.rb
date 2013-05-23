# encoding: utf-8

module UsersHelper
  def link_to_change_privileges user
    future_role =
      if user.has_role? :admin
        'пользователи'
      else
        'редакторы'
      end

    link_to "В #{future_role}!", user_path(user), method: :put,
      confirm: 'Изменить привилегии пользователя?'
  end
end
