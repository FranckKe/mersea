import dayjs from "dayjs"
import advancedFormat from "dayjs/plugin/advancedFormat"
import localeData from "dayjs/plugin/localeData"
import "dayjs/locale/en"
import "dayjs/locale/es"
import "dayjs/locale/fr"

dayjs.extend(advancedFormat)
dayjs.extend(localeData)

dayjs.locale("fr")

export default dayjs
