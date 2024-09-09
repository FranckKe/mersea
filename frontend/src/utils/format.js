import moment from 'moment'

// TODO bind locale as well
export function formatDate(value) {
    return moment(String(value)).format('Do MMMM YYYY')
}
