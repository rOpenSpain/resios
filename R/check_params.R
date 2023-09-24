# REE ####
check_lang <- function(lang) {
  match.arg(lang, c("es", "en"))
}

check_category <- function(category) {
  match.arg(category, c("balance", "demanda", "generacion", "intercambios",
                        "transporte"))
}

check_taxonomy_ids <- function(ids) {
  if (!is.null(ids) && is.numeric(ids) && all(!is.na(ids))) {
    stop("Taxonomy_ids must be numeric")
  }
}
check_taxonomy_terms <- function(terms) {
  if (!is.null(terms) && is.character(terms) && all(!is.na(terms))) {
    stop("Taxonomy_ids must be characters")
  }
}

cat_wid <- list(balance = "balance-electrico",
     demanda = c(
       "evolucion","variacion-componentes",
       "variacion-componentes-movil","ire-general","ire-general-anual",
       "ire-general-movil","ire-industria",
       "ire-industria-anual","ire-industria-movil","ire-servicios",
       "ire-servicios-anual","ire-servicios-movil",
       "ire-otras","ire-otras-anual","ire-otras-movil",
       "demanda-maxima-diaria","demanda-maxima-horaria",
       "perdidas-transporte",
       "potencia-maxima-instantanea","variacion-demanda",
       "potencia-maxima-instantanea-variacion",
       "potencia-maxima-instantanea-variacion-historico","demanda-tiempo-real",
       "variacion-componentes-anual"),
     generacion = c("estructura-generacion",
                    "evolucion-renovable-no-renovable","estructura-renovables",
                    "estructura-generacion-emisiones-asociadas",
                    "evolucion-estructura-generacion-emisiones-asociadas",
                    "no-renovables-detalle-emisiones-CO2","maxima-renovable",
                    "potencia-instalada","maxima-renovable-historico",
                    "maxima-sin-emisiones-historico"),
     intercambios = c("francia-frontera","portugal-frontera",
                      "marruecos-frontera","andorra-frontera","lineas-francia",
                      "lineas-portugal","lineas-marruecos",
                      "lineas-andorra","francia-frontera-programado",
                      "portugal-frontera-programado",
                      "marruecos-frontera-programado","andorra-frontera-programado",
                      "enlace-baleares","frontera-fisicos",
                      "todas-fronteras-fisicos","frontera-programados",
                      "todas-fronteras-programados"),
     transport = c("energia-no-suministrada-ens","indice-indisponibilidad",
                   "tiempo-interrupcion-medio-tim","kilometros-lineas",
                   "indice-disponibilidad","numero-cortes","ens-tim",
                   "indice-disponibilidad-total"),
     mercados = c("componentes-precio-energia-cierre-desglose",
                  "componentes-precio","energia-gestionada-servicios-ajuste",
                  "energia-restricciones","precios-restricciones",
                  "reserva-potencia-adicional",
                  "banda-regulacion-secundaria","energia-precios-regulacion-secundaria",
                  "energia-precios-regulacion-terciaria",
                  "energia-precios-gestion-desvios",
                  "coste-servicios-ajuste","volumen-energia-servicios-ajuste-variacion",
                  "precios-mercados-tiempo-real",
                  "energia-precios-ponderados-gestion-desvios-before",
                  "energia-precios-ponderados-gestion-desvios",
                  "energia-precios-ponderados-gestion-desvios-after")
)

check_category <- function(category) {
  match.arg(category, names(cat_wid))
}
check_widget <- function(widget) {
  match.arg(widget, unlist(cat_wid, FALSE, FALSE))
}

check_category_widget <- function(category, widget) {
  category <- check_category(category)
  widget <- check_widget(widget)
  if (any(widget %in% cat_wid[[category]])) {
    return(widget[widget %in% cat_wid[[category]]])
  } else {
    stop("Not a good widget for the given category.")
  }
}

# ESIOS ####

check_time_trunc <- function(time_trunc) {
  match.arg(time_trunc, c("five_minutes", "ten_minutes", "fifteen_minutes",
                          "hour", "day", "month", "year"))
}

check_agg <- function(agg) {
  match.arg(agg, c("sum", "average"))
}

check_geo_trunc <- function(geo_trunc) {
  match.arg(geo_trunc, c("country", "electric_system", "autonomous_community",
                         "province", "electric_subsystem", "town", "drainage_basin"))
}

check_date <- function(date){
  strftime(date , "%Y-%m-%dT%H:%M:%S%Z")
}
