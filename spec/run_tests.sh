#!/bin/bash

# очистка экрана
echo -en "\E[2J"

# запуск тестов LIMIT раз
LIMIT=1

for ((a=1; a <= LIMIT ; a++))
do
  echo "Запуск теста № $a..."
  echo

  # rake spec:controllers
  # rake spec:features
  # rake spec:helpers
  # rake spec:models
  # rake spec:rcov
  rake spec

  echo "Очистка тестовой БД после теста № $a..."
  echo
  echo
  rake db:test:prepare
done

exit 0
