[
  # Mix.Task behaviour and Mix.shell/0 are not available to dialyzer
  # because Mix is a dev/test dependency not included in PLT
  {"lib/mix/tasks/maquina_lv.install.ex", :callback_info_missing},
  {"lib/mix/tasks/maquina_lv.install.ex", :unknown_function}
]
