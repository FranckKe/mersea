export function capitalize(value?: string) {
  if (!value) return ""
  return `${value.charAt(0).toUpperCase()}${value.slice(1)}`
}

export function normalize(value?: string) {
  if (!value) return ""
  return value
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
}
