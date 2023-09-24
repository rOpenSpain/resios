ree_call <- function(lang = c("es", "en"),
                     category, widget, ...){
  path <- paste0(check_lang(lang), "/datos/", check_category(category), "/",
                 check_category_widget(category, widget))
  resp <- req_perform(prep_ree(path, ...))
  resp_body_json(resp)
}
