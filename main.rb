require "ruby_grammar_builder"

grammar = Grammar.new(
    name: "pkg-config",
    scope_name: "source.pc",
    fileTypes: [
        "pc"
    ],
    version: "0.0.0",
)

grammar.import("pattern/comment.rb")
grammar.import("pattern/string.rb")

grammar[:line_continuation_character] = Pattern.new(
  match: /\\\n/,
  tag_as: "constant.character.escape.line-continuation",
)

grammar[:ever_present_context] = [
  :comment,
  :line_continuation_character,
  :escape_char,
  :variable_ref,
]

grammar[:keyword] = %w[
  Name
  Description
  URL
  Version
  Conflicts
].map do |w|
  Pattern.new(
    match: w,
    tag_as: "keyword.other.#{w.downcase}.pc",
  ).zeroOrMoreOf(@spaces).then(
    match: ":",
    tag_as: "punctuation.section.colon",
  )
end

grammar[:keyword] += %w[
  Cflags
  Libs
  Requires
].map do |w|
  Pattern.new(
    match: /\b#{w}\b/,
    tag_as: "keyword.other.#{w.downcase}.pc",
  ).maybe(
    Pattern.new(
      match: /\.private\b/,
      tag_as: "keyword.other.#{w.downcase}.private.pc"
    )
  ).zeroOrMoreOf(@spaces).then(
    match: ":",
    tag_as: "punctuation.section.colon",
  )
end

grammar[:variable] = Pattern.new(
  match: /[_a-z]?\w+/,
  tag_as: "variable.other.pc"
)

grammar[:$initial_context] = [
  :ever_present_context,
  :keyword,
  :string_context,
]

grammar.save_to(
  syntax_name: "pc",
  syntax_dir: "./syntaxes",
)
