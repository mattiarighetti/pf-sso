ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    return_url:optional
}
if {![info exists return_url]} {
    set return_url "http://www.professionefinanza.com"
}
ad_return_template
