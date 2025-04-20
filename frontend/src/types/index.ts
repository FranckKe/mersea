export type Locale = "en" | "es" | "fr"

export type Page = {
  id: string
  name: string
  language: Locale
  content: string
  category: "about" | "information" | "welcome"
  slug: string
}

export type Tracer = {
  id: string
  name: string
  color: string
  photo: string
  description: string
  origin: string
  kind: string
  category: "archive" | "container" | "drift" | "research"
  created_at: string
}

export type User = {
  id: string
  name: string
  //   todo: string TODO other properties
  reports_count: number
  last_activity: string
}
